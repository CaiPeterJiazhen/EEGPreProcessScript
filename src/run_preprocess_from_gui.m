function report = run_preprocess_from_gui(ui, smoke_test)
%RUN_PREPROCESS_FROM_GUI Validate GUI inputs and run batch preprocessing.

if nargin < 2
    smoke_test = false;
end

source_root = string(strtrim(string(ui.SourceDirField.Value)));
output_root = string(strtrim(string(ui.OutputDirField.Value)));

if strlength(source_root) == 0
    error('EEGPreprocess:MissingSourceDir', 'Please select a source directory.');
end

if strlength(output_root) == 0
    error('EEGPreprocess:MissingOutputDir', 'Please select an output directory.');
end

if ~isfolder(source_root)
    error('EEGPreprocess:InvalidSourceDir', 'Source directory does not exist: %s', char(source_root));
end

if ~isfolder(output_root)
    mkdir(char(output_root));
end

cnt_count = count_cnt_files(source_root);
if cnt_count == 0
    error('EEGPreprocess:NoCntFiles', 'No CNT files were found under: %s', char(source_root));
end

cfg = collect_gui_config(ui);
cfg.output_root = output_root;
cfg.limit_files = 0;
if smoke_test
    cfg.limit_files = 1;
end
cfg.log_callback = @(msg) append_gui_log(ui.LogTextArea, msg);

ui.CntCountValueLabel.Text = sprintf('CNT files: %d', cnt_count);
append_gui_log(ui.LogTextArea, sprintf('Source root: %s', source_root));
append_gui_log(ui.LogTextArea, sprintf('Output root: %s', output_root));
if smoke_test
    append_gui_log(ui.LogTextArea, 'Running smoke test (limit_files = 1).');
else
    append_gui_log(ui.LogTextArea, 'Running full batch processing.');
end

[results, run_info] = run_preprocess_batch(source_root, cfg);
output_exists = false(numel(results), 1);

for idx = 1:numel(results)
    status = string(results(idx).status);
    if status == "processed" || status == "skipped_existing"
        output_exists(idx) = isfile(results(idx).set_path) && isfile(results(idx).fdt_path);
    end
end

summary = summarize_smoke_test_results(results, output_exists, source_root);
summary.log_path = run_info.log_path;

if summary.failed_count > 0
    ui.StatusValueLabel.Text = 'Completed with failures';
elseif smoke_test
    ui.StatusValueLabel.Text = 'Smoke test completed';
else
    ui.StatusValueLabel.Text = 'Completed';
end

ui.StatsValueLabel.Text = sprintf('Processed: %d | Skipped: %d | Failed: %d', ...
    summary.processed_count, summary.skipped_existing_count, summary.failed_count);
ui.LastLogField.Value = char(run_info.log_path);

report = struct();
report.source_root = source_root;
report.config_used = rmfield(cfg, 'log_callback');
report.results = results;
report.run_info = run_info;
report.output_exists = output_exists;
report.summary = summary;
end
