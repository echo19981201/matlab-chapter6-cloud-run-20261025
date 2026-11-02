# 三相桥式不控整流（R 与 R-L 负载）

本包包含由真实 MATLAB R2024b / Simulink 电气模型生成的两套 .slx、模型截图、仿真波形和原始数据。运行 `run_all` 可重新构建、仿真和导出。

## 所需软件

- MATLAB R2024b
- Simulink
- Simscape Electrical 的 Specialized Power Systems 模块库（含 `Universal Bridge`、`Three-Phase Source`、`powergui` 等；安装 Simscape Electrical 所需的 Simscape 许可也应可用）

FFT 使用 MATLAB 自带 `fft`，不调用 Signal Processing Toolbox、Control System Toolbox 或自定义第三方函数。

## 运行

解压后将 MATLAB 当前文件夹切换到本文件夹，在命令窗口运行：

```matlab
run_all
```

`build_rectifier_models` 也可以单独运行以先生成两套模型。`run_all` 完成后会生成 `models/rectifier_R.slx`、`models/rectifier_RL.slx`，每种负载的模型 PNG、直流稳态波形 PNG、三相交流电流 PNG、A 相 FFT/THD PNG，以及 `data/` 下包含 `simOut` 的实际仿真数据 MAT。所有文件再打包为 `rectifier_R_RL_MATLAB_verified.zip`。若构建、仿真、模型图像导出或数据校验失败，脚本报错，不会生成此最终压缩包。

导出模型 PNG 需要有图形显示能力的 MATLAB 会话；如果云运行节点完全禁用显示，Simulink 的模型打印功能可能不可用，此时先保留已生成的 `.slx` 和仿真数据，在可显示模型的会话中执行图像导出并重新运行完整脚本。

## 参数及测量口径

全部可改参数在 `rectifier_parameters.m`。经用户选定的电源线电压为 380 V（有效值）、频率 50 Hz；R 负载为 20 Ω；R-L 负载为串联 20 Ω 和 50 mH。这些参数是为仿真选定，并非原题原有数值。电源设为 Yg 且关闭内部阻抗。两模型均使用三桥臂、二极管型 `Universal Bridge`，功率电子器件 `Ron=1e-3 Ω`、`Lon=0`、`Vf=0`，纯电阻吸收支路 `Rs=1e5 Ω`、`Cs=inf`。

`powergui` 使用离散求解，步长 20 µs，采样率 50 kHz，仿真到 0.30 s。FFT 只用 0.20 s（含）到 0.30 s（不含）的稳态等间隔原始采样，共 5 个完整的 50 Hz 周期，5000 点，频率间隔 10 Hz。A 相电流先去直流分量，再使用单边峰值频谱；THD 为第 2 至第 50 次谐波峰值幅值的均方根合成量与 50 Hz 基波峰值幅值之比，最大分析频率 2500 Hz。分析前另以 0.10–0.20 s 窗口的均值检验稳态，不向 FFT 窗补点或插值。结果还校验直流平均电压约为 `1.35×380 V`、具有 300 Hz 六脉波纹波、R-L 电流纹波小于 R 负载。
