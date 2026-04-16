function cfg = load_preprocess_config(config_path)
%LOAD_PREPROCESS_CONFIG Load config JSON or create it from defaults.

ensure_src_on_path();
if nargin < 1 || strlength(string(config_path)) == 0
    config_path = default_config_path();
end

config_path = string(config_path);
defaults = normalize_preprocess_config(default_preprocess_config());

if ~isfile(config_path)
    save_preprocess_config(defaults, config_path);
    cfg = defaults;
    return;
end

raw_text = fileread(char(config_path));
raw_text = strip_utf8_bom(raw_text);
if strlength(strtrim(string(raw_text))) == 0
    save_preprocess_config(defaults, config_path);
    cfg = defaults;
    return;
end

loaded = jsondecode(raw_text);
cfg = defaults;
loaded_fields = fieldnames(loaded);

for idx = 1:numel(loaded_fields)
    field_name = loaded_fields{idx};
    cfg.(field_name) = loaded.(field_name);
end

cfg = normalize_preprocess_config(cfg);
end

function text = strip_utf8_bom(text)
if ~isempty(text) && text(1) == char(65279)
    text = text(2:end);
end
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
