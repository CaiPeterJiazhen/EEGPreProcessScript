# EEG Lookup File GUI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a GUI-selectable electrode lookup file path with a manual text field, browse button, saved config support, and pre-run validation.

**Architecture:** Keep the current preprocessing backend unchanged and expose the existing `lookup_file` config value through the GUI. Add one small validation helper so lookup-file validation stays testable and isolated from the UI layout code.

**Tech Stack:** MATLAB, EEGLAB, `uifigure`, JSON config, MATLAB `functiontests`

---

### Task 1: Add failing tests for lookup-file validation

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\validate_lookup_file_path.m`

- [ ] **Step 1: Write a failing test for an empty lookup-file path**
- [ ] **Step 2: Write a failing test for a missing lookup-file path**
- [ ] **Step 3: Write a failing test for a non-`.ced` extension**
- [ ] **Step 4: Write a failing test for a valid `.ced` file**

### Task 2: Implement lookup-file validation

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\validate_lookup_file_path.m`

- [ ] **Step 1: Implement empty-path validation**
- [ ] **Step 2: Implement file-exists validation**
- [ ] **Step 3: Implement `.ced` extension validation**
- [ ] **Step 4: Return the normalized lookup-file path**

### Task 3: Wire the lookup-file field into the GUI

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\collect_gui_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\apply_config_to_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\run_preprocess_from_gui.m`

- [ ] **Step 1: Add a `Lookup File` text field and `Select File` button**
- [ ] **Step 2: Load the config lookup-file value into the new field**
- [ ] **Step 3: Save the GUI lookup-file value back into the config**
- [ ] **Step 4: Validate the lookup file before smoke test or batch run**

### Task 4: Update documentation

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\README.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\批处理预处理脚本中文使用说明.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\BATCH_PREPROCESS_USAGE.md`

- [ ] **Step 1: Document the new GUI lookup-file row**
- [ ] **Step 2: Document that the default path is still `F:\CJZFile\EEG_M1\standard_1005.ced`**
- [ ] **Step 3: Document the `.ced` validation behavior**

### Task 5: Static verification

**Files:**
- Verify modified GUI, helper, test, and docs files

- [ ] **Step 1: Confirm the GUI files reference `lookup_file` consistently**
- [ ] **Step 2: Confirm docs and config references are consistent**
- [ ] **Step 3: Report MATLAB runtime limitations honestly if local execution is still blocked**
