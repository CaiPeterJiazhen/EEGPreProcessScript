# EEG Preprocess File Organization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize the EEG preprocessing project into type-based folders without changing the current entry-point function names or preprocessing behavior.

**Architecture:** Keep the five direct-use entry points in the project root and move internal helpers, config, and documentation into categorized folders. Update the root entry points so they bootstrap `src\` and update config lookup logic to the new `config\` location.

**Tech Stack:** MATLAB, EEGLAB, JSON config, Markdown docs, MATLAB `functiontests`

---

### Task 1: Create the target folder layout

**Files:**
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\config\`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\docs\reference\`

- [ ] **Step 1: Create the folder structure**

Create the folders listed above.

- [ ] **Step 2: Verify the new folders exist**

Check that all four directories now exist before moving files.

### Task 2: Move helper, config, and document files

**Files:**
- Move to `src\`:
  - `append_gui_log.m`
  - `apply_config_to_gui.m`
  - `build_output_paths.m`
  - `collect_cnt_files.m`
  - `collect_gui_config.m`
  - `count_cnt_files.m`
  - `default_preprocess_config.m`
  - `default_smoke_test_source_root.m`
  - `ensure_eeglab_available.m`
  - `find_reference_channel_indices.m`
  - `normalize_preprocess_config.m`
  - `preprocess_cnt_file.m`
  - `run_preprocess_from_gui.m`
  - `summarize_smoke_test_results.m`
- Move to `config\`:
  - `preprocess_config.json`
- Move to `docs\guides\`:
  - `BATCH_PREPROCESS_USAGE.md`
  - `批处理预处理脚本中文使用说明.md`
- Move to `docs\reference\`:
  - `EEGLAB预处理.md`
  - `eeglabhist.m`

- [ ] **Step 1: Move all helper `.m` files into `src\`**

Do not move the five root entry-point files.

- [ ] **Step 2: Move the JSON config into `config\`**

Keep the filename unchanged.

- [ ] **Step 3: Move usage guides into `docs\guides\`**

Do not move the `docs\superpowers\...` files.

- [ ] **Step 4: Move reference material into `docs\reference\`**

Preserve filenames unchanged.

### Task 3: Update root entry points and tests

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\run_preprocess_batch.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\smoke_test_preprocess.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\load_preprocess_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\save_preprocess_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`

- [ ] **Step 1: Make each root entry point bootstrap `src\`**

Each root entry point should add `F:\CJZProjectFile\EEGPreProcessScript\src` to the MATLAB path at runtime before calling helpers.

- [ ] **Step 2: Change config default lookup to `config\preprocess_config.json`**

Apply this change in both `load_preprocess_config.m` and `save_preprocess_config.m`.

- [ ] **Step 3: Update tests to add `src\` to the MATLAB path**

Ensure helper tests still resolve moved helper functions.

### Task 4: Update documentation references

**Files:**
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\BATCH_PREPROCESS_USAGE.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\批处理预处理脚本中文使用说明.md`

- [ ] **Step 1: Update guide references to the new config path**

The config path should now reference `config\preprocess_config.json`.

- [ ] **Step 2: Update guide file links to their new locations**

Keep the commands unchanged where entry points remain in root.

- [ ] **Step 3: Update reference-file links**

Reference files should now point to `docs\reference\...`.

### Task 5: Perform static verification

**Files:**
- Verify current project layout and key files

- [ ] **Step 1: Confirm root only retains the intended direct-use files plus folders**

Check the root directory after moves and edits.

- [ ] **Step 2: Confirm moved files exist in their new locations**

Verify `src\`, `config\`, `docs\guides\`, and `docs\reference\`.

- [ ] **Step 3: Confirm MATLAB runtime verification status honestly**

If MATLAB cannot run in this Codex environment, state that clearly instead of claiming functional execution success.
