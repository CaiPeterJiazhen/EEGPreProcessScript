function apply_config_to_gui(ui, cfg)
%APPLY_CONFIG_TO_GUI Apply config values to GUI controls.

cfg = normalize_preprocess_config(cfg);
ui.SampleRateField.Value = cfg.target_sample_rate;
ui.HighpassField.Value = cfg.highpass_hz;
ui.LowpassField.Value = cfg.lowpass_hz;
ui.ReferenceModeDropDown.Value = char(cfg.reference_mode);
ui.OverwriteCheckBox.Value = cfg.overwrite_existing;
ui.SaveLogCheckBox.Value = cfg.save_log;
ui.OutputDirField.Value = char(cfg.output_root);
ui.LookupFileField.Value = char(cfg.lookup_file);
end
