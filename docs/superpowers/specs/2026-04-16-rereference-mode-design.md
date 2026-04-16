# EEG 重参考模式设计

## 背景

当前脚本固定使用 `M1/M2` 作为重参考。根据最新的 EEGLAB 操作记录，脚本需要支持两种可切换的重参考方式：

- `平均参考`
- `M1/M2 重参考`

并且默认模式需要调整为 `平均参考`。

## 目标

- 在配置中新增可保存的 `reference_mode`
- 在 GUI 中允许用户选择重参考方式
- 预处理时根据重参考方式决定：
  - 删除哪些通道
  - 调用哪种 `pop_reref(...)`
- 默认模式改为 `平均参考`

## 参考依据

### 平均参考

依据 [eeglabhist(average)latest.m](/F:/CJZProjectFile/EEGPreProcessScript/eeglabhist/eeglabhist(average)latest.m)：

1. 加载 `.cnt`
2. 应用电极定位文件
3. 删除 `M1/M2/HEO/VEO/EKG/EMG`
4. 降采样
5. 高通、低通、49-51 Hz 陷波
6. 执行 `pop_reref(EEG, [])`

### M1/M2 重参考

依据 [eeglabhist.m](/F:/CJZProjectFile/EEGPreProcessScript/eeglabhist/eeglabhist.m) 与现有实现：

1. 加载 `.cnt`
2. 应用电极定位文件
3. 删除 `HEO/VEO/EKG/EMG`
4. 降采样
5. 高通、低通、49-51 Hz 陷波
6. 保留 `M1/M2`，执行 `pop_reref(EEG, [M1 M2对应索引])`

## 配置设计

新增配置项：

- `reference_mode`

允许值：

- `average`
- `m1_m2`

默认值：

- `average`

兼容性要求：

- 旧配置文件没有 `reference_mode` 时，自动补默认值 `average`
- `reference_labels` 继续保留，用于 `m1_m2` 模式

## 处理逻辑设计

### 平均参考模式

- 删除通道集合：
  - `M1`
  - `M2`
  - `HEO`
  - `VEO`
  - `EKG`
  - `EMG`
- 重参考调用：
  - `pop_reref(EEG, [])`

### M1/M2 重参考模式

- 删除通道集合：
  - `HEO`
  - `VEO`
  - `EKG`
  - `EMG`
- 重参考调用：
  - `pop_reref(EEG, reference_indices)`

## GUI 设计

在参数区域新增一个“重参考方式”控件，推荐使用下拉框：

- `平均参考`
- `M1/M2 重参考`

要求：

- 默认显示 `平均参考`
- `Load Config` / `Save Config` 能读写该值

## 测试设计

优先补纯逻辑测试，不依赖 MATLAB 运行 EEGLAB：

- 默认配置的 `reference_mode` 应为 `average`
- 配置保存/读取应能 round-trip `reference_mode`
- 平均参考模式下，待删除通道应包含 `M1/M2`
- `M1/M2` 模式下，待删除通道不应包含 `M1/M2`
- 平均参考模式的重参考目标应为空数组
- `M1/M2` 模式的重参考目标应解析为对应索引

## 影响文件

- 修改：
  - `F:\CJZProjectFile\EEGPreProcessScript\src\default_preprocess_config.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\src\normalize_preprocess_config.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\save_preprocess_config.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\src\preprocess_cnt_file.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\src\collect_gui_config.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\src\apply_config_to_gui.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\config\preprocess_config.json`
- 新增：
  - `F:\CJZProjectFile\EEGPreProcessScript\src\get_remove_channels_for_reference_mode.m`
  - `F:\CJZProjectFile\EEGPreProcessScript\src\resolve_reference_targets.m`
