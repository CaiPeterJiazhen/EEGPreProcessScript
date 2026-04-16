function report = smoke_test_preprocess(source_root, varargin)
%SMOKE_TEST_PREPROCESS Run a one-command smoke test for batch preprocessing.
%
% Default behavior:
% - Use the patient source directory when source_root is omitted
% - Process only 1 CNT file
% - Do not overwrite existing outputs
% - Do not persist any config changes
%
% Example:
%   report = smoke_test_preprocess();
%   report = smoke_test_preprocess("F:\CJZFile\EEG_M1\Health-tACS-M1-RestingStateEEG");

script_dir = fileparts(mfilename('fullpath'));
src_dir = fullfile(script_dir, 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end

if nargin < 1 || strlength(string(source_root)) == 0
    source_root = default_smoke_test_source_root();
end

source_root = string(source_root);
if ~isfolder(source_root)
    error('EEGPreprocess:InvalidSmokeTestSourceRoot', ...
        'Smoke-test source root does not exist: %s', char(source_root));
end

cfg = load_preprocess_config();
overrides = struct();
overrides.limit_files = 1;
overrides.overwrite_existing = false;

if ~isempty(varargin)
    if rem(numel(varargin), 2) ~= 0
        error('EEGPreprocess:InvalidArguments', ...
            'Optional smoke-test arguments must be provided as name/value pairs.');
    end

    for idx = 1:2:numel(varargin)
        overrides.(char(varargin{idx})) = varargin{idx + 1};
    end
end

if ~isfield(overrides, 'save_log')
    overrides.save_log = true;
end

override_fields = fieldnames(overrides);
for idx = 1:numel(override_fields)
    field_name = override_fields{idx};
    cfg.(field_name) = overrides.(field_name);
end
cfg = normalize_preprocess_config(cfg);

fprintf('Running EEG preprocess smoke test...\n');
fprintf('Source root: %s\n', char(source_root));
fprintf('target_sample_rate: %g\n', cfg.target_sample_rate);
fprintf('highpass_hz: %g\n', cfg.highpass_hz);
fprintf('lowpass_hz: %g\n', cfg.lowpass_hz);
fprintf('limit_files: %g\n', cfg.limit_files);

results = run_preprocess_batch(source_root, cfg);
output_exists = false(numel(results), 1);

for idx = 1:numel(results)
    status = string(results(idx).status);
    if status == "processed" || status == "skipped_existing"
        output_exists(idx) = isfile(results(idx).set_path) && isfile(results(idx).fdt_path);
    end
end

summary = summarize_smoke_test_results(results, output_exists, source_root);

fprintf('Smoke test finished.\n');
fprintf('Processed: %d\n', summary.processed_count);
fprintf('Skipped existing: %d\n', summary.skipped_existing_count);
fprintf('Failed: %d\n', summary.failed_count);
fprintf('All expected outputs exist: %d\n', summary.all_outputs_exist);

if summary.any_failures
    fprintf('Failure messages:\n');
    for idx = 1:numel(summary.failure_messages)
        fprintf('  [%d] %s\n', idx, summary.failure_messages(idx));
    end
end

report = struct();
report.source_root = source_root;
report.config_used = cfg;
report.results = results;
report.output_exists = output_exists;
report.summary = summary;
end
