function cfg = collect_gui_config(ui)
%COLLECT_GUI_CONFIG Collect preprocessing config values from GUI controls.

cfg = load_preprocess_config();
cfg.target_sample_rate = double(ui.SampleRateField.Value);
cfg.highpass_hz = double(ui.HighpassField.Value);
cfg.lowpass_hz = double(ui.LowpassField.Value);
cfg.reference_mode = string(ui.ReferenceModeDropDown.Value);
cfg.overwrite_existing = logical(ui.OverwriteCheckBox.Value);
cfg.save_log = logical(ui.SaveLogCheckBox.Value);
cfg.output_root = string(ui.OutputDirField.Value);
cfg.lookup_file = string(ui.LookupFileField.Value);
cfg = normalize_preprocess_config(cfg);
end
