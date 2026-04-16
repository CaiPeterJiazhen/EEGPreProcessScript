function [results, run_info] = run_preprocess_batch(source_root, varargin)
%RUN_PREPROCESS_BATCH Batch preprocess all CNT files under one source root.
%
% Example:
%   cfg = load_preprocess_config();
%   cfg.target_sample_rate = 250;
%   cfg.highpass_hz = 0.5;
%   cfg.lowpass_hz = 45;
%   save_preprocess_config(cfg);
%   results = run_preprocess_batch("F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG");
%
% With GUI or custom callbacks:
%   cfg = load_preprocess_config();
%   cfg.output_root = "F:\custom_output";
%   cfg.log_callback = @(msg) disp(msg);
%   [results, run_info] = run_preprocess_batch("F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG", cfg);

ensure_src_on_path();
source_root = string(source_root);
[config_path, overrides] = parse_inputs(varargin{:});
[log_callback, overrides] = extract_log_callback(overrides);

cfg = load_preprocess_config(config_path);
cfg = apply_overrides(cfg, overrides);
ensure_eeglab_available(cfg);

files = collect_cnt_files(source_root);
if isempty(files)
    error('EEGPreprocess:NoCntFiles', ...
        'No CNT files were found under: %s', char(source_root));
end

if cfg.limit_files > 0
    files = files(1:min(cfg.limit_files, numel(files)));
end

results = repmat(empty_result(), numel(files), 1);
emit_log(log_callback, sprintf('Found %d CNT file(s) under %s', numel(files), char(source_root)));

for idx = 1:numel(files)
    emit_log(log_callback, sprintf('[%d/%d] Processing %s', idx, numel(files), char(files(idx))));
    started_at = tic;

    try
        current_result = preprocess_cnt_file(files(idx), source_root, cfg);
    catch err
        current_result = empty_result();
        current_result.input_file = files(idx);
        current_result.status = "failed";
        current_result.message = string(getReport(err, 'basic', 'hyperlinks', 'off'));
    end

    current_result.elapsed_seconds = toc(started_at);
    results(idx) = current_result;
    emit_result_log(log_callback, idx, numel(files), current_result);
end

run_info = summarize_results(results, source_root, cfg.output_root);

if cfg.save_log
    run_info.log_path = write_batch_log(results, source_root, cfg.output_root);
    emit_log(log_callback, sprintf('Batch log saved to %s', char(run_info.log_path)));
else
    run_info.log_path = "";
end

emit_log(log_callback, sprintf('Processed: %d | Skipped existing: %d | Failed: %d', ...
    run_info.processed_count, run_info.skipped_existing_count, run_info.failed_count));
end

function [config_path, overrides] = parse_inputs(varargin)
config_path = "";
overrides = struct();

if isempty(varargin)
    return;
end

if numel(varargin) == 1 && isstruct(varargin{1})
    overrides = varargin{1};
    return;
end

if rem(numel(varargin), 2) ~= 0
    error('EEGPreprocess:InvalidArguments', ...
        'Optional arguments must be provided as name/value pairs.');
end

for idx = 1:2:numel(varargin)
    name = string(varargin{idx});
    value = varargin{idx + 1};

    if strcmpi(name, "config_path")
        config_path = string(value);
    else
        overrides.(char(name)) = value;
    end
end
end

function [log_callback, overrides] = extract_log_callback(overrides)
log_callback = [];

if isfield(overrides, 'log_callback')
    log_callback = overrides.log_callback;
    overrides = rmfield(overrides, 'log_callback');
end
end

function cfg = apply_overrides(cfg, overrides)
override_fields = fieldnames(overrides);

for idx = 1:numel(override_fields)
    field_name = override_fields{idx};
    cfg.(field_name) = overrides.(field_name);
end

cfg = normalize_preprocess_config(cfg);
end

function emit_log(log_callback, message)
message = string(message);
fprintf('%s\n', char(message));

if isempty(log_callback)
    return;
end

if ~isa(log_callback, 'function_handle')
    error('EEGPreprocess:InvalidLogCallback', ...
        'log_callback must be a function handle.');
end

try
    log_callback(message);
catch err
    fprintf('Log callback failed: %s\n', err.message);
end
end

function emit_result_log(log_callback, idx, total_count, current_result)
status = string(current_result.status);
input_file = string(current_result.input_file);

switch status
    case "processed"
        emit_log(log_callback, sprintf('[%d/%d] Processed %s', idx, total_count, char(input_file)));
    case "skipped_existing"
        emit_log(log_callback, sprintf('[%d/%d] Skipped existing output for %s', idx, total_count, char(input_file)));
    case "failed"
        emit_log(log_callback, sprintf('[%d/%d] Failed %s', idx, total_count, char(input_file)));
        if strlength(string(current_result.message)) > 0
            emit_log(log_callback, string(current_result.message));
        end
    otherwise
        emit_log(log_callback, sprintf('[%d/%d] Status %s for %s', idx, total_count, char(status), char(input_file)));
end
end

function result = empty_result()
result = struct( ...
    'input_file', "", ...
    'output_dir', "", ...
    'set_path', "", ...
    'fdt_path', "", ...
    'status', "", ...
    'message', "", ...
    'channel_count', NaN, ...
    'sample_rate', NaN, ...
    'elapsed_seconds', NaN);
end

function run_info = summarize_results(results, source_root, output_root)
statuses = string({results.status});

run_info = struct();
run_info.source_root = string(source_root);
run_info.output_root = string(output_root);
run_info.total_files = numel(results);
run_info.processed_count = sum(statuses == "processed");
run_info.skipped_existing_count = sum(statuses == "skipped_existing");
run_info.failed_count = sum(statuses == "failed");
run_info.log_path = "";
end

function log_path = write_batch_log(results, source_root, output_root)
[~, source_name] = fileparts(char(source_root));
log_dir = fullfile(char(output_root), 'logs');

if ~isfolder(log_dir)
    mkdir(log_dir);
end

timestamp = string(datestr(now, 'yyyymmdd_HHMMSS'));
source_name = string(source_name);
log_name = source_name + "_preprocess_log_" + timestamp + ".csv";
log_path = string(fullfile(log_dir, char(log_name)));
result_table = struct2table(results);
writetable(result_table, char(log_path));
end

function ensure_src_on_path()
script_dir = fileparts(mfilename('fullpath'));
src_dir = fullfile(script_dir, 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end
end
