function cfg = normalize_preprocess_config(cfg)
%NORMALIZE_PREPROCESS_CONFIG Normalize config values and fill defaults.

defaults = default_preprocess_config();
default_fields = fieldnames(defaults);

for idx = 1:numel(default_fields)
    field_name = default_fields{idx};
    if ~isfield(cfg, field_name) || isempty(cfg.(field_name))
        cfg.(field_name) = defaults.(field_name);
    end
end

cfg.output_root = string(cfg.output_root);
cfg.lookup_file = string(cfg.lookup_file);
cfg.eeglab_path = string(cfg.eeglab_path);

cfg.target_sample_rate = double(cfg.target_sample_rate);
cfg.highpass_hz = double(cfg.highpass_hz);
cfg.lowpass_hz = double(cfg.lowpass_hz);
cfg.notch_band_hz = reshape(double(cfg.notch_band_hz), 1, []);
cfg.limit_files = double(cfg.limit_files);

cfg.remove_channels = reshape(string(cfg.remove_channels), 1, []);
cfg.reference_labels = reshape(string(cfg.reference_labels), 1, []);

cfg.overwrite_existing = logical(cfg.overwrite_existing);
cfg.save_log = logical(cfg.save_log);

if cfg.target_sample_rate <= 0
    error('EEGPreprocess:InvalidSampleRate', ...
        'target_sample_rate must be greater than 0.');
end

if cfg.highpass_hz <= 0 || cfg.lowpass_hz <= 0
    error('EEGPreprocess:InvalidFilterRange', ...
        'highpass_hz and lowpass_hz must both be greater than 0.');
end

if cfg.highpass_hz >= cfg.lowpass_hz
    error('EEGPreprocess:InvalidFilterRange', ...
        'highpass_hz must be smaller than lowpass_hz.');
end

if numel(cfg.notch_band_hz) ~= 2
    error('EEGPreprocess:InvalidNotchBand', ...
        'notch_band_hz must contain exactly two values.');
end

if numel(cfg.reference_labels) ~= 2
    error('EEGPreprocess:InvalidReferenceLabels', ...
        'reference_labels must contain exactly two labels.');
end
end
