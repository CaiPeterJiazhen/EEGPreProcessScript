# EEG Preprocess GUI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `uifigure` GUI for the existing EEGLAB preprocessing scripts that supports selecting any source directory, selecting any output directory, and running either a full batch or a one-file smoke test.

**Architecture:** Keep the GUI as a thin interaction layer. Extend the existing batch backend to support a custom output root and an optional log callback, then build a GUI runner around that backend. Preserve the current command-line workflows.

**Tech Stack:** MATLAB, EEGLAB, `uifigure`, JSON config, MATLAB `functiontests`

---

### Task 1: Add tests for GUI-facing pure helpers

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\count_cnt_files.m`

- [ ] **Step 1: Write the failing test for counting CNT files**

```matlab
function testCountCntFilesReturnsZeroForEmptyFolder(testCase)
    tmpDir = tempname;
    mkdir(tmpDir);
    cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

    count = count_cnt_files(tmpDir);

    verifyEqual(testCase, count, 0);
end
```

- [ ] **Step 2: Write the failing test for nested CNT counting**

```matlab
function testCountCntFilesCountsNestedCntFiles(testCase)
    tmpDir = tempname;
    mkdir(tmpDir);
    cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

    mkdir(fullfile(tmpDir, 'nested'));
    fclose(fopen(fullfile(tmpDir, 'a.cnt'), 'w'));
    fclose(fopen(fullfile(tmpDir, 'nested', 'b.cnt'), 'w'));
    fclose(fopen(fullfile(tmpDir, 'nested', 'ignore.txt'), 'w'));

    count = count_cnt_files(tmpDir);

    verifyEqual(testCase, count, 2);
end
```

- [ ] **Step 3: Run helper tests to verify failure**

Run on a working local MATLAB machine:

```powershell
& 'F:\Matlab2020a\bin\matlab.exe' -batch "addpath('F:\CJZProjectFile\EEGPreProcessScript'); addpath('F:\CJZProjectFile\EEGPreProcessScript\tests'); results = runtests('test_eeg_preprocess_helpers'); table(results)"
```

Expected:

- Tests fail because `count_cnt_files` does not exist yet.

- [ ] **Step 4: Implement `count_cnt_files.m`**

```matlab
function count = count_cnt_files(source_root)
    files = collect_cnt_files(source_root);
    count = numel(files);
end
```

- [ ] **Step 5: Re-run helper tests and confirm they pass**

Run the same MATLAB command as Step 3.

### Task 2: Extend the batch backend for GUI use

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\run_preprocess_batch.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`

- [ ] **Step 1: Add a failing test for overrideable output root**

```matlab
function testBuildOutputPathsUsesProvidedOutputRoot(testCase)
    paths = build_output_paths("F:\source\folder", "F:\source\folder\a.cnt", "F:\custom_out");
    verifyTrue(testCase, startsWith(paths.set_path, "F:\custom_out"));
end
```

- [ ] **Step 2: Add a failing test for GUI summary helpers if needed**

```matlab
function testSummarizeSmokeTestResultsTracksProcessedAndFailed(testCase)
    results = repmat(struct('status',"",'message',"",'set_path',"",'fdt_path',""), 2, 1);
    results(1).status = "processed";
    results(2).status = "failed";
    summary = summarize_smoke_test_results(results, [true false], "F:\root");
    verifyEqual(testCase, summary.processed_count, 1);
    verifyEqual(testCase, summary.failed_count, 1);
end
```

- [ ] **Step 3: Modify `run_preprocess_batch.m` to accept GUI overrides**

Required behavior:

- allow `output_root`
- allow `log_callback`
- keep current struct and name/value call patterns working

Core code shape:

```matlab
if isfield(overrides, 'log_callback')
    log_callback = overrides.log_callback;
else
    log_callback = [];
end
```

- [ ] **Step 4: Add centralized log emission inside the batch loop**

```matlab
emit_log(log_callback, sprintf('[%d/%d] Processing %s', idx, numel(files), files(idx)));
```

- [ ] **Step 5: Re-run tests and smoke-test the CLI path**

Run:

```powershell
& 'F:\Matlab2020a\bin\matlab.exe' -batch "addpath('F:\CJZProjectFile\EEGPreProcessScript'); report = smoke_test_preprocess(); disp(report.summary)"
```

Expected:

- Existing command-line smoke test still works.

### Task 3: Build the GUI support helpers

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\collect_gui_config.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\apply_config_to_gui.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\append_gui_log.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\run_preprocess_from_gui.m`

- [ ] **Step 1: Write the failing test for GUI config collection where possible**

If UI objects are difficult to unit-test, limit tests to pure helpers and validate GUI behavior manually. Do not fake EEGLAB calls inside GUI helpers.

- [ ] **Step 2: Implement GUI config collection**

```matlab
function cfg = collect_gui_config(ui)
    cfg = load_preprocess_config();
    cfg.target_sample_rate = ui.SampleRateField.Value;
    cfg.highpass_hz = ui.HighpassField.Value;
    cfg.lowpass_hz = ui.LowpassField.Value;
    cfg.overwrite_existing = ui.OverwriteCheckBox.Value;
    cfg.save_log = ui.SaveLogCheckBox.Value;
    cfg.output_root = string(ui.OutputDirField.Value);
    cfg = normalize_preprocess_config(cfg);
end
```

- [ ] **Step 3: Implement GUI config application**

```matlab
function apply_config_to_gui(ui, cfg)
    ui.SampleRateField.Value = cfg.target_sample_rate;
    ui.HighpassField.Value = cfg.highpass_hz;
    ui.LowpassField.Value = cfg.lowpass_hz;
    ui.OverwriteCheckBox.Value = cfg.overwrite_existing;
    ui.SaveLogCheckBox.Value = cfg.save_log;
    ui.OutputDirField.Value = char(cfg.output_root);
end
```

- [ ] **Step 4: Implement GUI log appending**

```matlab
function append_gui_log(uiTextArea, message)
    current = string(uiTextArea.Value);
    if isempty(current)
        uiTextArea.Value = {char(message)};
    else
        uiTextArea.Value = [cellstr(current(:)); {char(message)}];
    end
    drawnow limitrate;
end
```

- [ ] **Step 5: Implement GUI runner**

`run_preprocess_from_gui.m` should:

- validate source/output directories
- count `.cnt`
- collect config
- set `limit_files = 1` when in smoke-test mode
- call `run_preprocess_batch`
- update summary labels and log path

### Task 4: Build the `uifigure` front end

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`

- [ ] **Step 1: Create the main window and path controls**

Include:

- source directory field
- output directory field
- source chooser button
- output chooser button
- cnt count label

- [ ] **Step 2: Create the parameter controls**

Include:

- sample rate numeric field
- high-pass numeric field
- low-pass numeric field
- overwrite checkbox
- save-log checkbox

- [ ] **Step 3: Create the status and log controls**

Include:

- current status label
- stats label
- last log path field
- multi-line text area for logs

- [ ] **Step 4: Create the action buttons**

Include callbacks for:

- load config
- save config
- start processing
- smoke test
- clear log

- [ ] **Step 5: Implement control locking during execution**

When processing starts:

- disable selectors and parameter fields
- set status to running

When processing ends:

- restore controls
- update status and summary labels

### Task 5: Update docs and manual validation steps

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\批处理预处理脚本中文使用说明.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\BATCH_PREPROCESS_USAGE.md`

- [ ] **Step 1: Add GUI startup instructions**

```matlab
launch_preprocess_gui
```

- [ ] **Step 2: Add GUI smoke-test instructions**

Document:

- choose source directory
- choose output directory
- click `烟雾测试`
- verify one `.set/.fdt` pair

- [ ] **Step 3: Add single-patient-folder example**

Use the documented example:

```text
F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG\基线\sub05殷文海
```

- [ ] **Step 4: Perform manual validation on the user machine**

Manual checks:

- GUI opens
- directory selection works
- cnt count updates
- smoke test generates output
- full run generates mirrored relative structure
