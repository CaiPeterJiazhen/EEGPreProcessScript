# EEGPreProcessScript

## 项目简介

这是一个基于 `MATLAB + EEGLAB` 的 EEG 预处理辅助项目，用于自动完成预处理流程的前六步，并将结果保存为 `.set/.fdt` 文件，方便后续在 EEGLAB 中继续手动处理。

当前固定自动执行的步骤为：

1. 导入 `.cnt` 文件
2. 加载电极定位文件 `F:\CJZFile\EEG_M1\standard_1005.ced`
3. 删除 `HEO / VEO / EKG / EMG`
4. 降采样
5. 高通、低通、固定 `49-51 Hz` 工频陷波
6. 固定使用 `M1 / M2` 重参考

第 7 步及之后的预处理仍由用户手动完成。

## 适用场景

- 批量处理患者或健康人 EEG 的 `.cnt` 文件
- 使用 GUI 选择任意目录并递归处理
- 保持原始目录层级关系输出 `.set/.fdt`
- 在正式批处理前先做 1 个文件的烟雾测试

## 项目特点

- 支持图形界面操作
- 支持命令行批处理
- 支持任意目录递归扫描 `.cnt`
- 输出保持“所选目录以下”的层级结构
- 固定执行 `49-51 Hz` 陷波
- 固定执行 `M1/M2` 重参考
- 采样率、高通、低通参数可保存、可修改

## 环境要求

首次使用前，请确认本机具备以下环境：

- Windows
- MATLAB
- EEGLAB
- EEG 原始数据为 `.cnt` 格式
- 电极定位文件存在：
  - `F:\CJZFile\EEG_M1\standard_1005.ced`

建议先确保 EEGLAB 可以在 MATLAB 中正常启动。

## 第一次安装与准备

### 1. 获取项目

如果你是第一次从 GitHub 使用本项目：

```powershell
git clone https://github.com/CaiPeterJiazhen/EEGPreProcessScript.git
cd EEGPreProcessScript
```

如果你已经有本地项目目录，则直接使用本地目录即可。

### 2. 打开 MATLAB 并加入路径

```matlab
cd('F:\CJZProjectFile\EEGPreProcessScript');
addpath(genpath('F:\CJZProjectFile\EEGPreProcessScript'));
```

如果你希望以后自动识别该目录，也可以在确认路径正确后执行：

```matlab
savepath
```

### 3. 确认 EEGLAB 可用

如果 MATLAB 当前没有自动找到 EEGLAB，请先手动启动 EEGLAB，或者在配置文件中设置 `eeglab_path`。

示例：

```matlab
cfg = load_preprocess_config();
cfg.eeglab_path = '你的EEGLAB安装目录';
save_preprocess_config(cfg);
```

### 4. 检查默认配置文件

配置文件位于：

- `config/preprocess_config.json`

你可以在 MATLAB 中读取当前配置：

```matlab
cfg = load_preprocess_config();
disp(cfg)
```

## 第一次使用推荐流程

第一次使用建议按下面顺序操作：

1. 启动 GUI
2. 选择一个源目录
3. 选择一个输出目录
4. 点击 `Smoke Test`
5. 确认生成一对 `.set/.fdt`
6. 用 EEGLAB 手动打开结果检查
7. 再进行完整批处理

## GUI 使用方法

### 启动 GUI

```matlab
launch_preprocess_gui
```

### GUI 操作步骤

1. 点击 `Select Source`
   - 选择任意一个源目录
   - GUI 会递归扫描其下所有 `.cnt`
2. 点击 `Select Output`
   - 选择输出根目录
3. 查看 `CNT files` 数量预览
4. 按需设置参数：
   - `Sample Rate`
   - `High-pass`
   - `Low-pass`
   - `Overwrite`
   - `Save Log`
5. 先点击 `Smoke Test`
6. 确认没问题后点击 `Start Processing`

### GUI 输出规则

GUI 会保留“所选目录以下”的结构，并以“所选目录名”作为输出中的顶层目录。

例如：

- 选择的源目录：
  `F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG\基线\sub05殷文海`
- 选择的输出根目录：
  `F:\CJZFile\EEG_scriptProcess_GUI`
- 输出结果：
  `F:\CJZFile\EEG_scriptProcess_GUI\sub05殷文海\...`

如果你选择的是整个患者目录：

- 源目录：
  `F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG`
- 输出结果：
  `F:\CJZFile\EEG_scriptProcess_GUI\Patient_tACS_M1_EEG\...`

## 命令行使用方法

### 读取配置

```matlab
cfg = load_preprocess_config();
disp(cfg)
```

### 修改并保存参数

```matlab
cfg = load_preprocess_config();
cfg.target_sample_rate = 250;
cfg.highpass_hz = 0.5;
cfg.lowpass_hz = 45;
save_preprocess_config(cfg);
```

### 处理患者目录

```matlab
results = run_preprocess_batch("F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG");
```

### 处理健康人目录

```matlab
results = run_preprocess_batch("F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG");
```

### 执行一键烟雾测试

```matlab
report = smoke_test_preprocess();
```

健康人目录烟雾测试：

```matlab
report = smoke_test_preprocess("F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG");
```

### 临时覆盖参数但不保存配置

```matlab
results = run_preprocess_batch( ...
    "F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG", ...
    'target_sample_rate', 250, ...
    'highpass_hz', 0.5, ...
    'lowpass_hz', 45, ...
    'output_root', "F:\CJZFile\EEG_scriptProcess_Test");
```

## 可修改参数说明

当前支持修改的参数：

- `target_sample_rate`
- `highpass_hz`
- `lowpass_hz`
- `overwrite_existing`
- `save_log`
- `eeglab_path`

固定不允许修改的处理规则：

- `49-51 Hz` 陷波始终执行
- `M1/M2` 重参考始终执行
- `HEO/VEO/EKG/EMG` 始终删除

## 输出结果说明

输出文件格式固定为：

- `.set`
- `.fdt`

默认配置下，输出根目录为：

- `F:\CJZFile\EEG_scriptProcess`

日志目录为：

- `F:\CJZFile\EEG_scriptProcess\logs\`

如果使用 GUI，则输出根目录以 GUI 中选择的目录为准。

## 项目目录结构

```text
EEGPreProcessScript/
├─ README.md
├─ launch_preprocess_gui.m
├─ run_preprocess_batch.m
├─ smoke_test_preprocess.m
├─ load_preprocess_config.m
├─ save_preprocess_config.m
├─ config/
│  └─ preprocess_config.json
├─ src/
│  ├─ run_preprocess_from_gui.m
│  ├─ preprocess_cnt_file.m
│  ├─ normalize_preprocess_config.m
│  └─ ...其他辅助函数
├─ docs/
│  ├─ guides/
│  ├─ reference/
│  └─ superpowers/
└─ tests/
```

目录说明：

- 根目录保留用户直接调用的入口函数
- `src/` 放辅助函数
- `config/` 放配置文件
- `docs/guides/` 放使用文档
- `docs/reference/` 放参考资料
- `tests/` 放测试文件

## 首次使用建议检查项

建议至少检查以下内容：

- `.set/.fdt` 是否真实生成
- 采样率是否等于设置值
- `HEO/VEO/EKG/EMG` 是否已删除
- `49-51 Hz` 陷波是否生效
- `M1/M2` 重参考是否生效
- 输出目录层级是否符合所选源目录

## 常见问题

### 1. MATLAB 找不到 EEGLAB

可能原因：

- EEGLAB 没有加入 MATLAB 路径
- `eeglab_path` 没设置

处理方法：

- 先手动启动 EEGLAB
- 或在配置中填写 `eeglab_path`
- 或手动 `addpath(genpath(EEGLAB目录))`

### 2. 找不到 M1 或 M2

可能原因：

- 原始数据中通道标签异常
- 电极定位或通道信息不一致

处理方法：

- 检查数据中的通道标签
- 检查 `standard_1005.ced`
- 确认 `M1` / `M2` 未被误删

### 3. 输出文件已存在但没有覆盖

原因：

- `overwrite_existing = false`

处理方法：

- 在 GUI 勾选 `Overwrite`
- 或在配置文件里把 `overwrite_existing` 改为 `true`

### 4. 只处理了少量文件

原因：

- `limit_files` 不为 `0`
- 你运行的是烟雾测试

处理方法：

- 用完整批处理入口
- 确认 `limit_files = 0`

## 注意事项

- 本仓库不包含 EEG 原始数据
- 本仓库默认使用项目外部的 EEG 数据目录
- 使用前请先确认本机路径配置与实际数据路径一致
- 第一次运行务必先做 `Smoke Test`
- 建议每次参数修改后先抽查 1 个结果文件

## 相关文档

- [中文使用说明](docs/guides/批处理预处理脚本中文使用说明.md)
- [英文使用说明](docs/guides/BATCH_PREPROCESS_USAGE.md)
- [EEGLAB 预处理参考](docs/reference/EEGLAB预处理.md)
- [EEGLAB 历史脚本参考](docs/reference/eeglabhist.m)

## 当前验证边界

本项目在当前整理过程中已完成静态检查和结构修正，但在当前 Codex 环境中无法实际运行 MATLAB 批处理验证，因为 `matlab.exe -batch` 返回的是本机许可证错误 `License Manager Error -9`。

因此，最终运行验证仍需要你在自己的 `MATLAB + EEGLAB` 环境中完成。
