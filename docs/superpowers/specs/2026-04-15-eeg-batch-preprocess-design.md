# EEG Batch Preprocess Design

**Goal**

Build a MATLAB/EEGLAB helper that automates the first six preprocessing steps for every `.cnt` file under a selected source root, then saves the results as `.set/.fdt` files under `F:\CJZFile\EEG_scriptProcess` while preserving the original folder hierarchy and file basenames.

**Scope**

- Support one source root per run.
- Recursively process all `.cnt` files below that source root.
- Target source roots include:
  - `F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG`
  - `F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG`
- Automate only EEGLAB preprocessing steps 1-6.
- Leave all later preprocessing steps to manual work.

**Confirmed Pipeline**

Based on [eeglabhist.m](/F:/CJZProjectFile/EEGPreProcessScript/eeglabhist.m), the automated steps are:

1. Load `.cnt`
2. Apply channel lookup with `F:\CJZFile\EEG_M1\standard_1005.ced`
3. Remove `HEO`, `VEO`, `EKG`, `EMG`
4. Resample to a configurable sample rate
5. Apply configurable high-pass and low-pass filtering, then always apply fixed `49-51 Hz` notch filtering
6. Re-reference to fixed `M1/M2`

**Configuration**

The batch script should persist editable parameters in a JSON config file so the user can keep defaults but still change them later.

Editable:

- `target_sample_rate`
- `highpass_hz`
- `lowpass_hz`
- `overwrite_existing`
- `eeglab_path`
- `output_root`

Fixed by project decision:

- channel lookup file
- channels removed before preprocessing
- `49-51 Hz` notch filter
- `M1/M2` reference labels

**File Layout**

Planned files:

- `run_preprocess_batch.m`: batch entry point
- `preprocess_cnt_file.m`: single-file EEGLAB pipeline
- `default_preprocess_config.m`: default config struct
- `load_preprocess_config.m`: load or create config JSON
- `save_preprocess_config.m`: persist config JSON
- `collect_cnt_files.m`: recursive file discovery
- `build_output_paths.m`: mirror source hierarchy under output root
- `find_reference_channel_indices.m`: resolve `M1/M2` indices from labels
- `ensure_eeglab_available.m`: add/check EEGLAB availability
- `tests/test_eeg_preprocess_helpers.m`: helper and config tests

**Failure Handling**

- If one file fails, log the error and continue with the next file.
- If `M1/M2` cannot be found after lookup, fail that file with a clear message.
- If output already exists and overwrite is disabled, skip the file instead of overwriting silently.

**Verification Limits**

Command-line MATLAB execution is currently blocked in this environment by a local license error, so implementation can be written here but not executed end-to-end in this session.
