# EEG Batch Preprocess Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a MATLAB/EEGLAB batch helper that automates preprocessing steps 1-6 for all `.cnt` files under a chosen source root and writes mirrored `.set/.fdt` outputs under `F:\CJZFile\EEG_scriptProcess`.

**Architecture:** Use a small MATLAB function set with one batch entry point, one single-file pipeline, and several pure helper functions for config, path mapping, file collection, and reference-channel lookup. Keep the batch orchestration independent from EEGLAB-specific calls so helper logic remains testable without running EEGLAB.

**Tech Stack:** MATLAB, EEGLAB, JSON config, MATLAB `functiontests`

---

### Task 1: Create test coverage for pure helper behavior

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`
- Test: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`

- [ ] **Step 1: Write the failing tests**

```matlab
function tests = test_eeg_preprocess_helpers
tests = functiontests(localfunctions);
end

function testDefaultConfigContainsExpectedFixedValues(testCase)
cfg = default_preprocess_config();
verifyEqual(testCase, cfg.target_sample_rate, 250);
verifyEqual(testCase, cfg.highpass_hz, 0.5);
verifyEqual(testCase, cfg.lowpass_hz, 45);
verifyEqual(testCase, cfg.notch_band_hz, [49 51]);
verifyEqual(testCase, cfg.reference_labels, ["M1" "M2"]);
verifyEqual(testCase, cfg.remove_channels, ["HEO" "VEO" "EKG" "EMG"]);
end
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
& 'F:\Matlab2020a\bin\matlab.exe' -batch "addpath('F:\CJZProjectFile\EEGPreProcessScript'); addpath('F:\CJZProjectFile\EEGPreProcessScript\tests'); results = runtests('test_eeg_preprocess_helpers'); assertSuccess(results);"
```

Expected:

- Fail in this environment because the helper functions do not exist yet.
- If MATLAB starts, the first failure should reference missing helper functions.

- [ ] **Step 3: Add more failing tests for config persistence, output mapping, file discovery, and reference lookup**

```matlab
function testSaveAndLoadConfigRoundTripsEditableParameters(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's'));

cfgPath = fullfile(tmpDir, 'preprocess_config.json');
cfg = default_preprocess_config();
cfg.target_sample_rate = 200;
cfg.highpass_hz = 1.0;
cfg.lowpass_hz = 40;

save_preprocess_config(cfg, cfgPath);
loaded = load_preprocess_config(cfgPath);

verifyEqual(testCase, loaded.target_sample_rate, 200);
verifyEqual(testCase, loaded.highpass_hz, 1.0);
verifyEqual(testCase, loaded.lowpass_hz, 40);
verifyEqual(testCase, loaded.notch_band_hz, [49 51]);
end
```

- [ ] **Step 4: Run tests again and confirm the expected missing-function failures**

Run the same MATLAB command as Step 2.

- [ ] **Step 5: Commit**

```bash
git add tests/test_eeg_preprocess_helpers.m docs/superpowers/specs/2026-04-15-eeg-batch-preprocess-design.md docs/superpowers/plans/2026-04-15-eeg-batch-preprocess.md
git commit -m "test: add EEG batch preprocess helper coverage"
```

### Task 2: Implement config and helper functions

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\default_preprocess_config.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\load_preprocess_config.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\save_preprocess_config.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\collect_cnt_files.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\build_output_paths.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\find_reference_channel_indices.m`
- Test: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`

- [ ] **Step 1: Write minimal helper implementations**

```matlab
function cfg = default_preprocess_config()
cfg = struct();
cfg.output_root = "F:\CJZFile\EEG_scriptProcess";
cfg.lookup_file = "F:\CJZFile\EEG_M1\standard_1005.ced";
cfg.target_sample_rate = 250;
cfg.highpass_hz = 0.5;
cfg.lowpass_hz = 45;
cfg.notch_band_hz = [49 51];
cfg.remove_channels = ["HEO" "VEO" "EKG" "EMG"];
cfg.reference_labels = ["M1" "M2"];
end
```

- [ ] **Step 2: Run helper tests**

Run:

```powershell
& 'F:\Matlab2020a\bin\matlab.exe' -batch "addpath('F:\CJZProjectFile\EEGPreProcessScript'); addpath('F:\CJZProjectFile\EEGPreProcessScript\tests'); results = runtests('test_eeg_preprocess_helpers'); table(results)"
```

Expected:

- Remaining failures should now be limited to not-yet-implemented helpers.

- [ ] **Step 3: Fill in the remaining helpers until the helper tests pass**

```matlab
function paths = build_output_paths(source_root, input_file, output_root)
[~, source_name] = fileparts(char(source_root));
relative_file = erase(string(input_file), string(source_root) + filesep);
[relative_dir, base_name] = fileparts(relative_file);
paths.output_dir = fullfile(string(output_root), string(source_name), string(relative_dir));
paths.set_path = fullfile(paths.output_dir, base_name + ".set");
paths.fdt_path = fullfile(paths.output_dir, base_name + ".fdt");
end
```

- [ ] **Step 4: Re-run helper tests**

Run the same MATLAB command as Step 2.

- [ ] **Step 5: Commit**

```bash
git add default_preprocess_config.m load_preprocess_config.m save_preprocess_config.m collect_cnt_files.m build_output_paths.m find_reference_channel_indices.m tests/test_eeg_preprocess_helpers.m
git commit -m "feat: add EEG batch preprocess helpers"
```

### Task 3: Implement EEGLAB orchestration

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\ensure_eeglab_available.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\preprocess_cnt_file.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\run_preprocess_batch.m`

- [ ] **Step 1: Implement the EEGLAB availability check**

```matlab
function ensure_eeglab_available(cfg)
if isfield(cfg, 'eeglab_path') && strlength(string(cfg.eeglab_path)) > 0
    addpath(genpath(char(cfg.eeglab_path)));
end

if exist('eeglab', 'file') ~= 2
    error('EEGPreprocess:MissingEEGLAB', 'EEGLAB was not found on the MATLAB path.');
end
end
```

- [ ] **Step 2: Implement the single-file preprocessing pipeline**

```matlab
EEG = pop_loadcnt(char(input_file), 'dataformat', 'auto', 'memmapfile', '');
EEG = pop_chanedit(EEG, 'lookup', char(cfg.lookup_file));
EEG = pop_select(EEG, 'nochannel', cellstr(existing_remove_labels));
EEG = pop_resample(EEG, cfg.target_sample_rate);
EEG = pop_eegfiltnew(EEG, 'locutoff', cfg.highpass_hz, 'plotfreqz', 0);
EEG = pop_eegfiltnew(EEG, 'hicutoff', cfg.lowpass_hz, 'plotfreqz', 0);
EEG = pop_eegfiltnew(EEG, 'locutoff', cfg.notch_band_hz(1), 'hicutoff', cfg.notch_band_hz(2), 'revfilt', 1, 'plotfreqz', 0);
EEG = pop_reref(EEG, ref_indices);
pop_saveset(EEG, 'filename', char(set_name), 'filepath', char(output_dir), 'savemode', 'twofiles');
```

- [ ] **Step 3: Implement the batch entry point with per-file try/catch**

```matlab
function results = run_preprocess_batch(source_root, varargin)
cfg = load_preprocess_config();
files = collect_cnt_files(source_root);
for idx = 1:numel(files)
    try
        results(idx) = preprocess_cnt_file(files(idx), source_root, cfg);
    catch err
        results(idx) = struct('input_file', files(idx), 'status', "failed", 'message', string(err.message));
    end
end
end
```

- [ ] **Step 4: Run a one-file smoke test**

Run:

```powershell
& 'F:\Matlab2020a\bin\matlab.exe' -batch "addpath('F:\CJZProjectFile\EEGPreProcessScript'); results = run_preprocess_batch('F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG', 'limit_files', 1); disp(results(1));"
```

Expected:

- In a healthy local MATLAB+EEGLAB environment, one `.set/.fdt` pair is created under `F:\CJZFile\EEG_scriptProcess\Patient_tACS_M1_EEG\...`

- [ ] **Step 5: Commit**

```bash
git add ensure_eeglab_available.m preprocess_cnt_file.m run_preprocess_batch.m
git commit -m "feat: add EEGLAB batch preprocessing pipeline"
```

### Task 4: Final validation and usage notes

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\superpowers\specs\2026-04-15-eeg-batch-preprocess-design.md`

- [ ] **Step 1: Reconcile plan and implementation**

Check:

- config fields match helper expectations
- output path logic still mirrors source hierarchy
- notch filtering remains fixed to `49-51 Hz`
- reference remains fixed to `M1/M2`

- [ ] **Step 2: Re-run helper tests and smoke test**

Run the Task 2 and Task 3 commands again.

- [ ] **Step 3: Record any environment blockers**

If MATLAB cannot run in the current machine session, note the exact license failure and hand off the validation command set.

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/specs/2026-04-15-eeg-batch-preprocess-design.md docs/superpowers/plans/2026-04-15-eeg-batch-preprocess.md
git commit -m "docs: record EEG batch preprocessing validation notes"
```
