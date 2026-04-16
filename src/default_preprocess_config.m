function cfg = default_preprocess_config()
%DEFAULT_PREPROCESS_CONFIG Return the default batch preprocessing config.

cfg = struct();
cfg.output_root = "F:\CJZFile\EEG_scriptProcess";
cfg.lookup_file = "F:\CJZFile\EEG_M1\standard_1005.ced";
cfg.eeglab_path = "";
cfg.target_sample_rate = 250;
cfg.highpass_hz = 0.5;
cfg.lowpass_hz = 45;
cfg.notch_band_hz = [49 51];
cfg.remove_channels = ["HEO" "VEO" "EKG" "EMG"];
cfg.reference_mode = "average";
cfg.reference_labels = ["M1" "M2"];
cfg.overwrite_existing = false;
cfg.limit_files = 0;
cfg.save_log = true;
end
