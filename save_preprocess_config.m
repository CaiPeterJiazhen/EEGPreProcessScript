function save_preprocess_config(cfg, config_path)
%SAVE_PREPROCESS_CONFIG Persist config values as JSON.

ensure_src_on_path();
if nargin < 2 || strlength(string(config_path)) == 0
    config_path = default_config_path();
end

cfg = normalize_preprocess_config(cfg);
config_path = string(config_path);
config_dir = fileparts(char(config_path));

if ~isempty(config_dir) && ~isfolder(config_dir)
    mkdir(config_dir);
end

serializable = struct();
serializable.output_root = char(cfg.output_root);
serializable.lookup_file = char(cfg.lookup_file);
serializable.eeglab_path = char(cfg.eeglab_path);
serializable.target_sample_rate = cfg.target_sample_rate;
serializable.highpass_hz = cfg.highpass_hz;
serializable.lowpass_hz = cfg.lowpass_hz;
serializable.notch_band_hz = cfg.notch_band_hz;
serializable.remove_channels = cellstr(cfg.remove_channels);
serializable.reference_labels = cellstr(cfg.reference_labels);
serializable.overwrite_existing = cfg.overwrite_existing;
serializable.limit_files = cfg.limit_files;
serializable.save_log = cfg.save_log;

json_text = jsonencode(serializable);
fid = fopen(char(config_path), 'w');

if fid == -1
    error('EEGPreprocess:ConfigWriteFailed', ...
        'Unable to write config file: %s', config_path);
end

cleanup = onCleanup(@() fclose(fid));
fwrite(fid, json_text, 'char');
end

function config_path = default_config_path()
config_path = fullfile(local_project_dir(), 'config', 'preprocess_config.json');
end

function project_dir = local_project_dir()
[project_dir, ~, ~] = fileparts(mfilename('fullpath'));
end

function ensure_src_on_path()
src_dir = fullfile(local_project_dir(), 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end
end
