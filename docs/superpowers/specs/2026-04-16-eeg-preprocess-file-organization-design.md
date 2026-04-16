# EEG Preprocess File Organization Design

## Goal

Reorganize the EEG preprocessing project by file type without changing the current user-facing entry points or breaking existing preprocessing behavior.

## Scope

This reorganization applies only to local project structure inside `F:\CJZProjectFile\EEGPreProcessScript`.

It does not change:

- EEG preprocessing logic
- GUI behavior
- CLI entry-point names
- output data paths
- preprocessing parameter semantics

## Approved Approach

Use a low-risk layout:

- keep direct-use entry points in the project root
- move helper functions into `src\`
- move config files into `config\`
- move user guides into `docs\guides\`
- move reference material into `docs\reference\`
- keep tests in `tests\`

## Root Files To Keep

These files remain in the project root because users may call them directly:

- `launch_preprocess_gui.m`
- `run_preprocess_batch.m`
- `smoke_test_preprocess.m`
- `load_preprocess_config.m`
- `save_preprocess_config.m`

## Files To Move

### `src\`

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

### `config\`

- `preprocess_config.json`

### `docs\guides\`

- `BATCH_PREPROCESS_USAGE.md`
- `批处理预处理脚本中文使用说明.md`

### `docs\reference\`

- `EEGLAB预处理.md`
- `eeglabhist.m`

## Compatibility Strategy

Because MATLAB does not automatically resolve helper functions in subdirectories when only the root folder is visible, each root entry point must ensure `src\` is added to the MATLAB path before it calls moved helper functions.

`load_preprocess_config.m` and `save_preprocess_config.m` must change their default config location from the project root to:

- `F:\CJZProjectFile\EEGPreProcessScript\config\preprocess_config.json`

The root entry-point function names stay unchanged.

## Testing Impact

`tests\test_eeg_preprocess_helpers.m` must add the `src\` directory to the MATLAB path so tests can still call moved helper functions directly.

## Documentation Impact

User-facing documentation must be updated to reflect:

- the new config path
- the new guide paths
- the new reference file paths
- unchanged root entry-point names

## Non-Goals

This work does not:

- convert the project to a MATLAB package
- rename entry-point functions
- change preprocessing defaults
- remove the existing `docs\superpowers\...` planning/spec history
