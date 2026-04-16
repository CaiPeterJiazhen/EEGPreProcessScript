# EEG Rereference Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add selectable rereference modes with `average` as the default while preserving the existing preprocessing flow.

**Architecture:** Keep the current batch pipeline intact and isolate the new behavior in config-aware helpers. One helper decides which channels to remove for the chosen rereference mode, and one helper decides what rereference target should be passed to EEGLAB. The GUI and config layer only expose and persist the mode.

**Tech Stack:** MATLAB, EEGLAB, JSON config, MATLAB functiontests

---

### Task 1: Add config and helper tests

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`

- [ ] Add failing tests for `reference_mode` default, save/load round-trip, remove-channel selection, and rereference-target resolution.
- [ ] Run the relevant MATLAB tests in a healthy local environment and confirm the new tests fail before implementation.

### Task 2: Implement config and helper logic

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\default_preprocess_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\normalize_preprocess_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\save_preprocess_config.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\get_remove_channels_for_reference_mode.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\resolve_reference_targets.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\config\preprocess_config.json`

- [ ] Add `reference_mode` with default `average`.
- [ ] Validate allowed values `average` and `m1_m2`.
- [ ] Persist `reference_mode` to JSON.
- [ ] Implement helper that returns remove-channel labels based on mode.
- [ ] Implement helper that returns `[]` for average or parsed indices for `m1_m2`.

### Task 3: Wire rereference mode into preprocessing

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\preprocess_cnt_file.m`

- [ ] Replace the fixed remove-channel logic with `get_remove_channels_for_reference_mode(...)`.
- [ ] Replace the fixed `M1/M2` rereference logic with `resolve_reference_targets(...)`.
- [ ] Preserve the existing filter order and output format.

### Task 4: Expose rereference mode in the GUI

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\collect_gui_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\apply_config_to_gui.m`

- [ ] Add a GUI control for “重参考方式”.
- [ ] Default it to `平均参考`.
- [ ] Ensure `Load Config` / `Save Config` round-trip the selected mode.

### Task 5: Update docs and verify statically

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\README.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\批处理预处理脚本中文使用说明.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\BATCH_PREPROCESS_USAGE.md`

- [ ] Update docs to say the default is now average reference.
- [ ] Document the exact behavior difference between average and `M1/M2`.
- [ ] Run static checks (`rg`, `git diff`) to confirm references are consistent.
