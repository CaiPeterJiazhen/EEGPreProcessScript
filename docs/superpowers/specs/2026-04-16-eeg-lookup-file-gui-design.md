# EEG Lookup File GUI Design

## Goal

Allow users to choose the electrode lookup `.ced` file from the GUI while keeping the existing default path:

- `F:\CJZFile\EEG_M1\standard_1005.ced`

## Scope

This feature is GUI-only.

It does not change:

- command-line call patterns
- default preprocessing logic
- output paths
- fixed notch or rereference behavior

## Approved Interaction

Use **Scheme A**:

- add a `Lookup File` row in the GUI top directory section
- provide a text field for manual editing
- provide a `Select File` button for choosing a `.ced` file

## GUI Behavior

### Startup

- load `lookup_file` from the saved config
- show it in the GUI text field
- keep the existing default value if the config does not override it

### User edits

- user may type a path manually
- user may click `Select File` and choose a `.ced` file

### Save / Load config

- `Load Config` must refresh the lookup-file field
- `Save Config` must persist the current lookup-file field into `config\preprocess_config.json`

### Pre-run validation

Before `Smoke Test` or `Start Processing`, the GUI must reject invalid lookup-file values:

- empty path
- missing file
- non-`.ced` extension

If validation fails, the run must stop before entering batch preprocessing.

## Data Flow

- `launch_preprocess_gui.m` adds the new control row and browse callback
- `src\apply_config_to_gui.m` writes `cfg.lookup_file` into the GUI
- `src\collect_gui_config.m` reads the GUI field back into `cfg.lookup_file`
- `src\run_preprocess_from_gui.m` validates the lookup-file path before running the batch
- `src\preprocess_cnt_file.m` continues using the existing:
  - `pop_chanedit(EEG, 'lookup', char(cfg.lookup_file))`

## Validation Design

Add one small helper with a single responsibility:

- `src\validate_lookup_file_path.m`

Responsibilities:

- normalize the input into `string`
- error if empty
- error if the file does not exist
- error if the extension is not `.ced`

This keeps GUI validation logic out of `run_preprocess_from_gui.m` and makes it unit-testable.

## Files To Modify

- Modify: `F:\CJZProjectFile\EEGPreProcessScript\launch_preprocess_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\collect_gui_config.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\apply_config_to_gui.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\src\run_preprocess_from_gui.m`
- Create: `F:\CJZProjectFile\EEGPreProcessScript\src\validate_lookup_file_path.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\tests\test_eeg_preprocess_helpers.m`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\README.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\批处理预处理脚本中文使用说明.md`
- Modify: `F:\CJZProjectFile\EEGPreProcessScript\docs\guides\BATCH_PREPROCESS_USAGE.md`

## Non-Goals

This change does not:

- add lookup-file overrides to command-line usage
- change the default lookup file path
- allow non-`.ced` lookup sources
