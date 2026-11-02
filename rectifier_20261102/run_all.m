function run_all
root = fileparts(mfilename('fullpath'));
p = rectifier_parameters;
assert(p.frequency > 0 && p.resistance > 0 && p.inductance > 0 && ...
    p.sampleTime > 0 && p.fftCycles >= 1 && ...
    p.fftStart >= p.fftCycles / p.frequency && ...
    p.fftStart + p.fftCycles / p.frequency <= p.stopTime + 1e-10, ...
    '参数设置与仿真或 FFT 时间窗不兼容。');
names = build_rectifier_models(p, root);
imageDir = fullfile(root, 'results');
dataDir = fullfile(root, 'data');
if ~exist(imageDir, 'dir')
    mkdir(imageDir);
end
if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end
records = cell(1, 2);
for k = 1:2
    name = names{k};
    fprintf('正在仿真：%s\n', name);
    simOut = sim(name);
    records{k} = analyze_rectifier(simOut, name, p, root);
    data = records{k};
    save(fullfile(dataDir, [name '_simulation.mat']), 'simOut', 'data', 'p', '-v7.3');
    open_system(name);
    modelPng = fullfile(imageDir, [name '_model.png']);
    print(['-s' name], '-dpng', modelPng);
    assert(isfile(modelPng), '模型图像没有成功导出：%s', name);
    save_system(name);
end
assert(records{2}.currentRippleStdA < records{1}.currentRippleStdA, ...
    'R-L 负载的稳态电流纹波没有小于 R 负载，请检查模型接线与测量值。');
fprintf('R 负载电流标准差 %.4f A；R-L 负载电流标准差 %.4f A。\n', ...
    records{1}.currentRippleStdA, records{2}.currentRippleStdA);
files = {'README.md', 'rectifier_parameters.m', 'build_rectifier_models.m', ...
    'analyze_rectifier.m', 'run_all.m'};
for folder = {'models', 'results', 'data'}
    entries = dir(fullfile(root, folder{1}));
    entries = entries(~[entries.isdir]);
    for k = 1:numel(entries)
        files{end + 1} = fullfile(folder{1}, entries(k).name);
    end
end
assert(numel(dir(fullfile(root, 'models', '*.slx'))) == 2 && ...
    numel(dir(fullfile(root, 'results', '*.png'))) == 8 && ...
    numel(dir(fullfile(root, 'data', '*.mat'))) == 2, ...
    '交付文件数量不正确：应有 2 个模型、8 张结果图、2 个原始数据文件。');
archive = fullfile(root, 'rectifier_R_RL_MATLAB_verified.zip');
zip(archive, files, root);
fprintf('已生成包含真实仿真模型、图像、数据及源码的压缩包：%s\n', archive);
end
