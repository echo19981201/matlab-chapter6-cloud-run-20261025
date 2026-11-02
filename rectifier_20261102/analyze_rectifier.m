function data = analyze_rectifier(simOut, name, p, root)
v = simOut.get('vdc');
i = simOut.get('idc');
abc = simOut.get('iabc');
assert(isa(v, 'timeseries') && isa(i, 'timeseries') && ...
    isa(abc, 'timeseries'), '测量信号必须以 Timeseries 格式保存。');
t = double(v.Time(:));
vdc = double(v.Data(:));
idc = double(i.Data(:));
iabc = squeeze(double(abc.Data));
if size(iabc, 1) ~= numel(t) && size(iabc, 2) == numel(t)
    iabc = iabc.';
end
assert(size(iabc, 1) == numel(t) && size(iabc, 2) == 3, ...
    '三相电流信号必须为 N×3。');
assert(numel(i.Time) == numel(t) && numel(abc.Time) == numel(t), ...
    '三组测量数据的采样点数不一致。');
assert(max(abs(double(i.Time(:)) - t)) < p.sampleTime / 100 && ...
    max(abs(double(abc.Time(:)) - t)) < p.sampleTime / 100, ...
    '三组测量数据的时间戳不一致。');
assert(max(abs(diff(t) - p.sampleTime)) < p.sampleTime / 100, ...
    '仿真输出未按指定时间步长等间隔采样。');

fs = 1 / p.sampleTime;
n = round(p.fftCycles * fs / p.frequency);
assert(abs(n - p.fftCycles * fs / p.frequency) < 1e-8, ...
    'FFT 周期长度不是整数采样点，请调整 sampleTime。');
t0 = p.fftStart;
t1 = t0 + p.fftCycles / p.frequency;
sel = t >= t0 - p.sampleTime / 100 & t < t1 - p.sampleTime / 100;
assert(sum(sel) == n, '稳态 FFT 窗中的采样点数与设置不符。');
tw = t(sel);
assert(abs(tw(1) - t0) < p.sampleTime / 100 && ...
    abs(tw(end) - (t1 - p.sampleTime)) < p.sampleTime / 100, ...
    '稳态 FFT 窗没有准确对齐基波整周期。');
prior = t >= t0 - p.fftCycles / p.frequency - p.sampleTime / 100 & ...
    t < t0 - p.sampleTime / 100;
assert(sum(prior) == n, '缺少前一整周期窗口用于稳态校验。');
meanV = mean(vdc(sel));
meanI = mean(idc(sel));
assert(abs(meanV - mean(vdc(prior))) < 0.01 * meanV && ...
    abs(meanI - mean(idc(prior))) < 0.01 * meanI, ...
    '最终窗口与前一窗口均值不一致，请延长仿真时间。');

orders = (0:p.maxHarmonic).';
assert(p.maxHarmonic * p.frequency < fs / 2, '谐波截止频率超过奈奎斯特频率。');
df = fs / n;
bins = round(orders * p.frequency / df);
assert(max(abs(bins * df - orders * p.frequency)) < 1e-8, ...
    'FFT 基波与谐波未落在频谱整数格点上。');
y = iabc(sel, 1);
y = y - mean(y);
spectrum = fft(y) / n;
amplitudes = 2 * abs(spectrum(bins + 1));
amplitudes(1) = abs(spectrum(1));
fundamental = amplitudes(2);
assert(fundamental > 1, '交流 A 相基波电流异常。');
thd = 100 * sqrt(sum(amplitudes(3:end).^2)) / fundamental;
vSpectrum = fft(vdc(sel) - meanV) / n;
ripple300 = 2 * abs(vSpectrum(round(6 * p.frequency / df) + 1));
expected = 1.35 * p.lineVoltageRms;
assert(abs(meanV - expected) < 0.15 * expected, ...
    '直流平均电压偏离三相六脉波整流的合理范围。');
assert(ripple300 > 0.5, '直流电压没有检测到 300 Hz 六脉波纹波。');

data.model = name;
data.parameters = p;
data.time = t;
data.vdc = vdc;
data.idc = idc;
data.iabc = iabc;
data.fft.timeWindow = [t0 t1];
data.fft.sampleRate = fs;
data.fft.sampleCount = n;
data.fft.fundamentalHz = p.frequency;
data.fft.harmonicOrders = orders;
data.fft.amplitudePeakA = amplitudes;
data.fft.thdPercent = thd;
data.meanVoltageV = meanV;
data.meanCurrentA = meanI;
data.currentRippleStdA = std(idc(sel));
data.sixPulse300HzPeakV = ripple300;
data.currentRipplePeakToPeakA = max(idc(sel))-min(idc(sel));
data.phaseCurrentSumMaxA = max(abs(sum(iabc(sel,:),2)));
assert(data.phaseCurrentSumMaxA < 0.05, '三相线电流之和异常。');
dataDir=fullfile(root,'data');
if ~exist(dataDir,'dir'), mkdir(dataDir); end
writematrix([t vdc idc iabc],fullfile(dataDir,[name '_waveforms.csv']));
writematrix([orders orders*p.frequency amplitudes],fullfile(dataDir,[name '_harmonics.csv']));
metrics=rmfield(data,{'time','vdc','idc','iabc'});
fid=fopen(fullfile(dataDir,[name '_metrics.json']),'w','n','UTF-8');
fwrite(fid,jsonencode(metrics),'char'); fclose(fid);

imageDir = fullfile(root, 'results');
if ~exist(imageDir, 'dir')
    mkdir(imageDir);
end
if strcmp(name, 'rectifier_R')
    label = 'R 负载';
else
    label = 'R-L 负载';
end
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1150 690]);
subplot(2, 1, 1);
plot(tw, vdc(sel), 'b', 'LineWidth', 1.1);
grid on;
xlim([t0 t1]);
ylabel('直流输出电压 / V');
title(sprintf('%s：稳态直流输出电压（均值 %.2f V）', label, meanV));
subplot(2, 1, 2);
plot(tw, idc(sel), 'r', 'LineWidth', 1.1);
grid on;
xlim([t0 t1]);
xlabel('时间 / s');
ylabel('直流输出电流 / A');
title(sprintf('稳态直流输出电流（均值 %.2f A）', meanI));
exportgraphics(fig, fullfile(imageDir, [name '_DC.png']), 'Resolution', 180);
close(fig);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1150 580]);
plot(tw, iabc(sel, :), 'LineWidth', 1.0);
grid on;
xlim([t0 t1]);
xlabel('时间 / s');
ylabel('交流侧相电流 / A');
legend({'A 相', 'B 相', 'C 相'}, 'Location', 'northeast');
title([label '：交流侧三相电流（稳态）']);
exportgraphics(fig, fullfile(imageDir, [name '_AC.png']), 'Resolution', 180);
close(fig);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1150 580]);
stem(orders * p.frequency, amplitudes, 'filled');
grid on;
xlim([0 p.maxHarmonic * p.frequency]);
xlabel('频率 / Hz');
ylabel('A 相电流峰值幅值 / A');
title(sprintf('%s：A 相电流 FFT，THD_{2-%d} = %.2f%%', ...
    label, p.maxHarmonic, thd), 'Interpreter', 'tex');
exportgraphics(fig, fullfile(imageDir, [name '_FFT.png']), 'Resolution', 180);
close(fig);
fprintf('%s：Vdc 均值 %.3f V，Idc 均值 %.3f A，300 Hz 纹波 %.3f V，A 相 THD(2-%d) %.3f%%\n', ...
    label, meanV, meanI, ripple300, p.maxHarmonic, thd);
end
