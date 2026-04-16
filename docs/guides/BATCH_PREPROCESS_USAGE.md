# Batch EEG Preprocess Usage

## Files

- `launch_preprocess_gui.m`: GUI entry point
- `run_preprocess_batch.m`: command-line batch entry point
- `smoke_test_preprocess.m`: one-command smoke test
- `load_preprocess_config.m`: config loader
- `save_preprocess_config.m`: config saver
- `src\run_preprocess_from_gui.m`: GUI-to-batch bridge
- `src\validate_lookup_file_path.m`: lookup-file validator
- `config\preprocess_config.json`: saved editable parameters

## Fixed preprocessing steps

The script always performs these first six EEGLAB preprocessing steps:

1. Load `.cnt`
2. Apply channel lookup with a selected `.ced` file
3. Remove channels based on the selected reference mode:
   - always remove `HEO`, `VEO`, `EKG`, `EMG`
   - additionally remove `M1`, `M2` when `average` reference is selected
4. Resample
5. High-pass, low-pass, and fixed `49-51 Hz` notch filtering
6. Re-reference according to `reference_mode`:
   - default: `average`
   - optional: `m1_m2`

The script always enforces these fixed or mode-driven rules:

- `49-51 Hz` notch is always applied
- `HEO/VEO/EKG/EMG` are always removed when present
- `reference_mode = average` removes `M1/M2` before average rereference
- `reference_mode = m1_m2` keeps `M1/M2` and rereferences to them

## Editable parameters

You can edit and save these parameters:

- `target_sample_rate`
- `highpass_hz`
- `lowpass_hz`
- `overwrite_existing`
- `save_log`
- `eeglab_path`
- `lookup_file`
- `reference_mode`

The default saved config file is now:

- `F:\CJZProjectFile\EEGPreProcessScript\config\preprocess_config.json`

The default lookup file remains:

- `F:\CJZFile\EEG_M1\standard_1005.ced`

The default reference mode is:

- `average`

## GUI quick start

Open MATLAB, switch to the script folder, and add it to the path:

```matlab
cd('F:\CJZProjectFile\EEGPreProcessScript');
addpath(genpath('F:\CJZProjectFile\EEGPreProcessScript'));
```

Launch the GUI:

```matlab
launch_preprocess_gui
```

## GUI workflow

1. Click `选择源目录` and choose any directory.
2. Click `选择输出目录` and choose the output root.
3. In `电极定位文件`, either type a `.ced` path or click `选择文件`.
4. Check the `扫描结果` / `CNT 文件数` preview.
5. Choose `重参考方式` as `平均参考` or `M1/M2 重参考`.
6. Adjust sample rate / high-pass / low-pass if needed.
7. Click `烟雾测试` to process only one file first.
8. If the smoke test looks correct, click `开始处理`.

## Lookup-file validation

Before `烟雾测试` or `开始处理`, the GUI validates the lookup file:

- it cannot be empty
- it must exist
- it must use the `.ced` extension

Invalid values are rejected before batch preprocessing starts.

## GUI path rule

The GUI has only one input mode:

- manually choose any source directory

It recursively processes all `.cnt` files below that directory.

The output keeps only the structure below the selected directory, with the selected folder name as the top-level mirrored folder.

Example:

- Selected source directory:
  `F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG\baseline\sub05_patient`
- Selected output root:
  `F:\CJZFile\EEG_scriptProcess_GUI`
- Output:
  `F:\CJZFile\EEG_scriptProcess_GUI\sub05_patient\...`

If you select the full patient root:

- Source:
  `F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG`
- Output:
  `F:\CJZFile\EEG_scriptProcess_GUI\Patient_tACS_M1_EEG\...`

## GUI smoke test

Recommended first validation:

1. Choose a source directory.
2. Choose an output directory.
3. Confirm or select a valid `.ced` lookup file.
4. Choose the desired `reference_mode`.
5. Click `烟雾测试`.
6. Confirm the GUI shows:
   - `Processed: 1`
   - `Failed: 0`
7. Confirm one `.set/.fdt` pair exists under the selected output root.
8. Open the `.set` in EEGLAB for manual inspection.

## Command-line usage

Load current config:

```matlab
cfg = load_preprocess_config();
disp(cfg)
```

Modify and save parameters:

```matlab
cfg = load_preprocess_config();
cfg.target_sample_rate = 250;
cfg.highpass_hz = 0.5;
cfg.lowpass_hz = 45;
cfg.reference_mode = "average";   % or "m1_m2"
save_preprocess_config(cfg);
```

Process patient EEG:

```matlab
results = run_preprocess_batch("F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG");
```

Process healthy EEG:

```matlab
results = run_preprocess_batch("F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG");
```

Run the command-line smoke test:

```matlab
report = smoke_test_preprocess();
```

Healthy-control smoke test:

```matlab
report = smoke_test_preprocess("F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG");
```

Temporary override without saving config:

```matlab
results = run_preprocess_batch( ...
    "F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG", ...
    'target_sample_rate', 250, ...
    'highpass_hz', 0.5, ...
    'lowpass_hz', 45, ...
    'reference_mode', "average", ...
    'output_root', "F:\CJZFile\EEG_scriptProcess_Test");
```

## Reference material

Reference documents are now stored under:

- `F:\CJZProjectFile\EEGPreProcessScript\docs\reference\EEGLAB预处理.md`
- `F:\CJZProjectFile\EEGPreProcessScript\docs\reference\eeglabhist.m`

## Output layout

Outputs are saved as `.set/.fdt`.

When you use the default config, outputs are written under:

- `F:\CJZFile\EEG_scriptProcess`

Logs are written under:

- `F:\CJZFile\EEG_scriptProcess\logs\`

When you use the GUI, the output root is whatever directory you selected in the interface.

## What to verify manually

After a smoke test or batch run, check:

- the `.set/.fdt` files exist
- the saved sampling rate matches the configured value
- the selected `.ced` lookup file is correct
- `HEO/VEO/EKG/EMG` were removed
- the `49-51 Hz` notch was applied
- the rereference behavior matches the selected mode
- the output folder structure matches the selected source root

## Runtime limitation in this Codex session

The code was updated and statically reviewed here, but MATLAB execution could not be verified in this session because `matlab.exe -batch` failed with a local license error (`License Manager Error -9`). GUI and runtime behavior still need to be tested on your local MATLAB + EEGLAB machine.
