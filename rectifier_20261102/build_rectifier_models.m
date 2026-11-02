function names = build_rectifier_models(p, root)
if nargin < 1 || isempty(p)
    p = rectifier_parameters;
end
if nargin < 2 || isempty(root)
    root = fileparts(mfilename('fullpath'));
end
if isempty(ver('simulink'))
    error('需要 Simulink。');
end
library = '';
for candidate = {'sps_lib', 'powerlib'}
    try
        load_system(candidate{1});
        library = candidate{1};
        break
    catch
    end
end
if isempty(library)
    error('找不到 Simscape Electrical Specialized Power Systems 库（sps_lib 或 powerlib）。');
end
modelDir = fullfile(root, 'models');
if ~exist(modelDir, 'dir')
    mkdir(modelDir);
end
names = {'rectifier_R', 'rectifier_RL'};
for k = 1:2
    name = names{k};
    if bdIsLoaded(name)
        close_system(name, 0);
    end
    new_system(name);
    set_param(name, 'SolverType', 'Fixed-step', 'Solver', 'FixedStepDiscrete', ...
        'FixedStep', num2str(p.sampleTime, 17), ...
        'StopTime', num2str(p.stopTime, 17), ...
        'ReturnWorkspaceOutputs', 'on');

    pg = add_power_block(library, 'powergui', [80 40 180 85], name);
    set_mask(pg, '^Simulation type', 'Discrete');
    set_mask(pg, '^Sample time', num2str(p.sampleTime, 17));

    src = add_power_block(library, 'Three-Phase Source', [60 175 170 305], name);
    set_mask(src, '^Configuration', 'Yg');
    set_mask(src, '^Specify internal voltages for each phase', 'off');
    set_mask(src, '^Phase-to-phase voltage', num2str(p.lineVoltageRms, 17));
    set_mask(src, '^Frequency', num2str(p.frequency, 17));
    set_mask(src, '^Internal\W*$', 'off');

    ac = add_power_block(library, 'Three-Phase V-I Measurement', [310 170 425 310], name);
    set_mask(ac, '^Voltage measurement', 'no');
    set_mask(ac, '^Current measurement', 'yes');
    set_mask(ac, '^Currents in pu', 'off');

    bridge = add_power_block(library, 'Universal Bridge', [570 170 690 315], name);
    set_mask(bridge, '^Number of bridge arms', '3');
    set_mask(bridge, '^Power Electronic device', 'Diodes');
    set_mask(bridge, '^Snubber resistance', '1e5');
    set_mask(bridge, '^Snubber capacitance', 'inf');
    set_mask(bridge, '^Ron', '1e-3');
    set_mask(bridge, '^Lon', '0');
    set_mask(bridge, '^Forward voltage Vf', '0');

    dcCurrent = add_power_block(library, 'Current Measurement', [805 182 890 250], name);
    load = add_power_block(library, 'Series RLC Branch', [1000 182 1095 275], name);
    if k == 1
        set_mask(load, '^Branch type', 'R');
    else
        set_mask(load, '^Branch type', 'RL');
        set_mask(load, '^Inductance', num2str(p.inductance, 17));
    end
    set_mask(load, '^Resistance', num2str(p.resistance, 17));
    dcVoltage = add_power_block(library, 'Voltage Measurement', [805 360 900 435], name);

    sourcePorts = only_three_ports(src);
    [acIn, acOut] = measurement_ports(ac);
    [bridgeAc, bridgeDc] = bridge_ports(bridge);
    for phase = 1:3
        join(name, sourcePorts(phase), acIn(phase));
        join(name, acOut(phase), bridgeAc(phase));
    end
    [curPlus, curMinus] = terminal_pair(dcCurrent);
    [loadPlus, loadMinus] = terminal_pair(load);
    [voltPlus, voltMinus] = terminal_pair(dcVoltage);
    join(name, bridgeDc(1), curPlus);
    join(name, curMinus, loadPlus);
    join(name, loadMinus, bridgeDc(2));
    join(name, bridgeDc(1), voltPlus);
    join(name, bridgeDc(2), voltMinus);

    add_log(name, ac, 'iabc', [480 405 595 445]);
    add_log(name, dcCurrent, 'idc', [1030 365 1145 405]);
    add_log(name, dcVoltage, 'vdc', [1030 465 1145 505]);
    % Keep electrical topology unchanged; show readable diagram labels.
    labels = {src,'三相电源'; ac,'三相电流测量'; bridge,'三相六二极管整流桥'; ...
        dcCurrent,'直流电流测量'; load,'串联负载'; dcVoltage,'直流电压测量'};
    for q=1:size(labels,1)
        set_param(labels{q,1},'ShowName','on','FontName','Noto Sans CJK SC','FontSize','11');
        set_param(labels{q,1},'Name',labels{q,2});
    end
    if k==1, loadLabel=sprintf('R 负载：%g Ω',p.resistance); else, loadLabel=sprintf('R-L 负载：%g Ω + %g mH',p.resistance,1000*p.inductance); end
    note=Simulink.Annotation(name,sprintf('三相桥式不控整流 — %s\n线电压 %g V（有效值），%g Hz；三桥臂，每臂两只二极管',loadLabel,p.lineVoltageRms,p.frequency));
    note.Position=[310 35]; note.FontName='Noto Sans CJK SC'; note.FontSize=13;
    set_param(name,'ZoomFactor','FitSystem');
    save_system(name, fullfile(modelDir, [name '.slx']));
    fprintf('已构建并保存模型：%s\n', fullfile(modelDir, [name '.slx']));
end
end

function block = add_power_block(library, title, pos, model)
allblocks = find_system(library, 'LookUnderMasks', 'all', 'FollowLinks', 'on', 'Type', 'Block');
normalized = regexprep(get_param(allblocks, 'Name'), '\s+', ' ');
hits = allblocks(strcmp(normalized, title));
hits = hits(~strcmp(hits, library));
if isempty(hits)
    error('在 %s 中找不到模块：%s', library, title);
end
[~, order] = sort(cellfun(@numel, hits));
source = hits{order(1)};
block = [model '/' title];
add_block(source, block, 'Position', pos);
end

function set_mask(block, pattern, value)
names = get_param(block, 'MaskNames');
prompts = get_param(block, 'MaskPrompts');
match = find(~cellfun('isempty', regexpi(prompts, pattern, 'once')));
if numel(match) ~= 1
    error('模块 %s 的参数 %s 未唯一匹配；请检查该模块的 MaskPrompts。', block, pattern);
end
set_param(block, names{match}, value);
end

function group = port_groups(block)
h = get_param(block, 'PortHandles');
sides = {'LConn', 'RConn', 'TConn', 'BConn'};
group = cell(1, 4);
for k = 1:4
    if isfield(h, sides{k})
        group{k} = h.(sides{k})(:);
    else
        group{k} = [];
    end
end
end

function p = sort_by_height(p)
y = zeros(numel(p), 1);
for k = 1:numel(p)
    xy = get_param(p(k), 'Position');
    y(k) = xy(2);
end
[~, order] = sort(y);
p = p(order);
end

function p = only_three_ports(block)
groups = port_groups(block);
counts = cellfun(@numel, groups);
ix = find(counts == 3);
if numel(ix) ~= 1
    error('%s 应恰有一组三相电气端口。', block);
end
p = sort_by_height(groups{ix});
end

function [left, right] = measurement_ports(block)
groups = port_groups(block);
if numel(groups{1}) ~= 3 || numel(groups{2}) ~= 3
    error('%s 应具有左右各三个电气端口。', block);
end
left = sort_by_height(groups{1});
right = sort_by_height(groups{2});
end

function [ac, dc] = bridge_ports(block)
groups = port_groups(block);
counts = cellfun(@numel, groups);
ixAc = find(counts == 3);
ixDc = find(counts == 2);
if numel(ixAc) ~= 1 || numel(ixDc) ~= 1
    error('%s 必须是三相六二极管桥，并有三个交流端口、两个直流端口。', block);
end
ac = sort_by_height(groups{ixAc});
dc = sort_by_height(groups{ixDc});
end

function [positive, negative] = terminal_pair(block)
groups = port_groups(block);
p = vertcat(groups{:});
if numel(p) ~= 2
    error('%s 应具有两个电气端口。', block);
end
xy = zeros(2, 2);
for k = 1:2
    xy(k, :) = get_param(p(k), 'Position');
end
if max(xy(:, 1)) - min(xy(:, 1)) >= max(xy(:, 2)) - min(xy(:, 2))
    [~, order] = sort(xy(:, 1));
else
    [~, order] = sort(xy(:, 2));
end
positive = p(order(1));
negative = p(order(2));
end

function join(model, a, b)
add_line(model, a, b, 'autorouting', 'on');
end

function add_log(model, sensor, variable, pos)
block = [model '/log_' variable];
add_block('simulink/Sinks/To Workspace', block, 'Position', pos, ...
    'VariableName', variable, 'SaveFormat', 'Timeseries', ...
    'Decimation', '1', 'MaxDataPoints', 'inf');
output = get_param(sensor, 'PortHandles');
sink = get_param(block, 'PortHandles');
if numel(output.Outport) ~= 1
    error('%s 必须只有一个测量输出端。', sensor);
end
add_line(model, output.Outport(1), sink.Inport(1), 'autorouting', 'on');
end
