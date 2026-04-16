function report = run_preprocess_from_gui(ui, smoke_test)
%RUN_PREPROCESS_FROM_GUI Validate GUI inputs and run batch preprocessing.

if nargin < 2
    smoke_test = false;
end

source_root = string(strtrim(string(ui.SourceDirField.Value)));
output_root = string(strtrim(string(ui.OutputDirField.Value)));

if strlength(source_root) == 0
    error('EEGPreprocess:MissingSourceDir', '请选择源目录。');
end

if strlength(output_root) == 0
    error('EEGPreprocess:MissingOutputDir', '请选择输出目录。');
end

if ~isfolder(source_root)
    error('EEGPreprocess:InvalidSourceDir', '源目录不存在: %s', char(source_root));
end

if ~isfolder(output_root)
    mkdir(char(output_root));
end

cnt_count = count_cnt_files(source_root);
if cnt_count == 0
    error('EEGPreprocess:NoCntFiles', '在该目录下未找到 CNT 文件: %s', char(source_root));
end

cfg = collect_gui_config(ui);
cfg.lookup_file = validate_lookup_file_path(cfg.lookup_file);
cfg.output_root = output_root;
cfg.limit_files = 0;
if smoke_test
    cfg.limit_files = 1;
end
cfg.log_callback = @(msg) append_gui_log(ui.LogTextArea, msg);

if cfg.reference_mode == "average"
    reference_mode_text = "平均参考";
else
    reference_mode_text = "M1/M2 重参考";
end

ui.LookupFileField.Value = char(cfg.lookup_file);
ui.CntCountValueField.Value = sprintf('CNT 文件数 %d', cnt_count);
append_gui_log(ui.LogTextArea, sprintf('源目录: %s', char(source_root)));
append_gui_log(ui.LogTextArea, sprintf('输出目录: %s', char(output_root)));
append_gui_log(ui.LogTextArea, sprintf('电极定位文件: %s', char(cfg.lookup_file)));
append_gui_log(ui.LogTextArea, sprintf('重参考方式: %s', char(reference_mode_text)));
if smoke_test
    append_gui_log(ui.LogTextArea, '正在运行烟雾测试 (limit_files = 1)。');
else
    append_gui_log(ui.LogTextArea, '正在运行完整批处理。');
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
    ui.StatusValueLabel.Text = '处理完成，但存在失败';
elseif smoke_test
    ui.StatusValueLabel.Text = '烟雾测试完成';
else
    ui.StatusValueLabel.Text = '处理完成';
end

ui.StatsValueLabel.Text = sprintf('已处理: %d | 已跳过: %d | 失败: %d', ...
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
