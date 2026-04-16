function fig = launch_preprocess_gui()
%LAUNCH_PREPROCESS_GUI Launch the EEG batch preprocess GUI.

ensure_src_on_path();
cfg = load_preprocess_config();
ui = struct();

fig = uifigure('Name', 'EEG 预处理界面', 'Position', [100 100 1040 720]);
fig.UserData = struct();
mainGrid = uigridlayout(fig, [3 1]);
mainGrid.RowHeight = {210, '1x', 60};
mainGrid.Padding = [10 10 10 10];
mainGrid.RowSpacing = 10;

pathPanel = uipanel(mainGrid, 'Title', '路径设置');
pathGrid = uigridlayout(pathPanel, [4 3]);
pathGrid.RowHeight = {32, 32, 32, 32};
pathGrid.ColumnWidth = {90, '1x', 120};

sourceLabel = uilabel(pathGrid, 'Text', '源目录', 'HorizontalAlignment', 'right');
sourceLabel.Layout.Row = 1;
sourceLabel.Layout.Column = 1;

ui.SourceDirField = uieditfield(pathGrid, 'text');
ui.SourceDirField.Layout.Row = 1;
ui.SourceDirField.Layout.Column = 2;
ui.SourceDirField.ValueChangedFcn = @(~, ~) update_source_count();

ui.SourceBrowseButton = uibutton(pathGrid, 'push', 'Text', '选择源目录', ...
    'ButtonPushedFcn', @(~, ~) choose_source_directory());
ui.SourceBrowseButton.Layout.Row = 1;
ui.SourceBrowseButton.Layout.Column = 3;

outputLabel = uilabel(pathGrid, 'Text', '输出目录', 'HorizontalAlignment', 'right');
outputLabel.Layout.Row = 2;
outputLabel.Layout.Column = 1;

ui.OutputDirField = uieditfield(pathGrid, 'text');
ui.OutputDirField.Layout.Row = 2;
ui.OutputDirField.Layout.Column = 2;

ui.OutputBrowseButton = uibutton(pathGrid, 'push', 'Text', '选择输出目录', ...
    'ButtonPushedFcn', @(~, ~) choose_output_directory());
ui.OutputBrowseButton.Layout.Row = 2;
ui.OutputBrowseButton.Layout.Column = 3;

lookupLabel = uilabel(pathGrid, 'Text', '电极定位文件', 'HorizontalAlignment', 'right');
lookupLabel.Layout.Row = 3;
lookupLabel.Layout.Column = 1;

ui.LookupFileField = uieditfield(pathGrid, 'text');
ui.LookupFileField.Layout.Row = 3;
ui.LookupFileField.Layout.Column = 2;

ui.LookupBrowseButton = uibutton(pathGrid, 'push', 'Text', '选择文件', ...
    'ButtonPushedFcn', @(~, ~) choose_lookup_file());
ui.LookupBrowseButton.Layout.Row = 3;
ui.LookupBrowseButton.Layout.Column = 3;

scanLabel = uilabel(pathGrid, 'Text', '扫描结果', 'HorizontalAlignment', 'right');
scanLabel.Layout.Row = 4;
scanLabel.Layout.Column = 1;

ui.CntCountValueField = uieditfield(pathGrid, 'text', 'Editable', 'off');
ui.CntCountValueField.Layout.Row = 4;
ui.CntCountValueField.Layout.Column = [2 3];
ui.CntCountValueField.Value = 'CNT 文件数 -';

centerGrid = uigridlayout(mainGrid, [1 2]);
centerGrid.ColumnWidth = {280, '1x'};
centerGrid.ColumnSpacing = 10;

paramPanel = uipanel(centerGrid, 'Title', '参数设置');
paramGrid = uigridlayout(paramPanel, [7 2]);
paramGrid.RowHeight = {28, 28, 28, 28, 28, '1x', '1x'};
paramGrid.ColumnWidth = {120, '1x'};

sampleLabel = uilabel(paramGrid, 'Text', '采样率', 'HorizontalAlignment', 'right');
sampleLabel.Layout.Row = 1;
sampleLabel.Layout.Column = 1;
ui.SampleRateField = uieditfield(paramGrid, 'numeric');
ui.SampleRateField.Layout.Row = 1;
ui.SampleRateField.Layout.Column = 2;

highpassLabel = uilabel(paramGrid, 'Text', '高通 (Hz)', 'HorizontalAlignment', 'right');
highpassLabel.Layout.Row = 2;
highpassLabel.Layout.Column = 1;
ui.HighpassField = uieditfield(paramGrid, 'numeric');
ui.HighpassField.Layout.Row = 2;
ui.HighpassField.Layout.Column = 2;

lowpassLabel = uilabel(paramGrid, 'Text', '低通 (Hz)', 'HorizontalAlignment', 'right');
lowpassLabel.Layout.Row = 3;
lowpassLabel.Layout.Column = 1;
ui.LowpassField = uieditfield(paramGrid, 'numeric');
ui.LowpassField.Layout.Row = 3;
ui.LowpassField.Layout.Column = 2;

overwriteLabel = uilabel(paramGrid, 'Text', '覆盖已有结果', 'HorizontalAlignment', 'right');
overwriteLabel.Layout.Row = 4;
overwriteLabel.Layout.Column = 1;
ui.OverwriteCheckBox = uicheckbox(paramGrid, 'Text', '允许覆盖已有输出');
ui.OverwriteCheckBox.Layout.Row = 4;
ui.OverwriteCheckBox.Layout.Column = 2;

saveLogLabel = uilabel(paramGrid, 'Text', '保存日志', 'HorizontalAlignment', 'right');
saveLogLabel.Layout.Row = 5;
saveLogLabel.Layout.Column = 1;
ui.SaveLogCheckBox = uicheckbox(paramGrid, 'Text', '保存 CSV 日志');
ui.SaveLogCheckBox.Layout.Row = 5;
ui.SaveLogCheckBox.Layout.Column = 2;

statusPanel = uipanel(centerGrid, 'Title', '状态与日志');
statusGrid = uigridlayout(statusPanel, [4 2]);
statusGrid.RowHeight = {24, 24, 24, '1x'};
statusGrid.ColumnWidth = {120, '1x'};

statusLabel = uilabel(statusGrid, 'Text', '当前状态', 'HorizontalAlignment', 'right');
statusLabel.Layout.Row = 1;
statusLabel.Layout.Column = 1;
ui.StatusValueLabel = uilabel(statusGrid, 'Text', '空闲');
ui.StatusValueLabel.Layout.Row = 1;
ui.StatusValueLabel.Layout.Column = 2;

summaryLabel = uilabel(statusGrid, 'Text', '统计信息', 'HorizontalAlignment', 'right');
summaryLabel.Layout.Row = 2;
summaryLabel.Layout.Column = 1;
ui.StatsValueLabel = uilabel(statusGrid, 'Text', '已处理: 0 | 已跳过: 0 | 失败: 0');
ui.StatsValueLabel.Layout.Row = 2;
ui.StatsValueLabel.Layout.Column = 2;

lastLogLabel = uilabel(statusGrid, 'Text', '最近日志', 'HorizontalAlignment', 'right');
lastLogLabel.Layout.Row = 3;
lastLogLabel.Layout.Column = 1;
ui.LastLogField = uieditfield(statusGrid, 'text', 'Editable', 'off');
ui.LastLogField.Layout.Row = 3;
ui.LastLogField.Layout.Column = 2;

ui.LogTextArea = uitextarea(statusGrid, 'Editable', 'off');
ui.LogTextArea.Layout.Row = 4;
ui.LogTextArea.Layout.Column = [1 2];
ui.LogTextArea.Value = {'界面已启动。'};

buttonGrid = uigridlayout(mainGrid, [1 5]);
buttonGrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};

ui.LoadConfigButton = uibutton(buttonGrid, 'push', 'Text', '加载配置', ...
    'ButtonPushedFcn', @(~, ~) load_config_callback());
ui.SaveConfigButton = uibutton(buttonGrid, 'push', 'Text', '保存配置', ...
    'ButtonPushedFcn', @(~, ~) save_config_callback());
ui.RunButton = uibutton(buttonGrid, 'push', 'Text', '开始处理', ...
    'ButtonPushedFcn', @(~, ~) execute_run(false));
ui.SmokeButton = uibutton(buttonGrid, 'push', 'Text', '烟雾测试', ...
    'ButtonPushedFcn', @(~, ~) execute_run(true));
ui.ClearLogButton = uibutton(buttonGrid, 'push', 'Text', '清空日志', ...
    'ButtonPushedFcn', @(~, ~) clear_log_callback());

apply_config_to_gui(ui, cfg);
ui.SourceDirField.Value = '';
ui.LastLogField.Value = '';
ui.CntCountValueField.Value = 'CNT 文件数 -';
fig.UserData.ui = ui;

controls_to_disable = {
    ui.SourceDirField, ui.SourceBrowseButton, ...
    ui.OutputDirField, ui.OutputBrowseButton, ...
    ui.LookupFileField, ui.LookupBrowseButton, ...
    ui.SampleRateField, ui.HighpassField, ui.LowpassField, ...
    ui.OverwriteCheckBox, ui.SaveLogCheckBox, ...
    ui.LoadConfigButton, ui.SaveConfigButton, ...
    ui.RunButton, ui.SmokeButton
    };

    function choose_source_directory()
        start_dir = choose_start_directory(ui.SourceDirField.Value);
        selected_dir = uigetdir(start_dir, '选择源目录');
        if isequal(selected_dir, 0)
            return;
        end
        ui.SourceDirField.Value = selected_dir;
        update_source_count();
        append_gui_log(ui.LogTextArea, sprintf('已选择源目录: %s', selected_dir));
    end

    function choose_output_directory()
        start_dir = choose_start_directory(ui.OutputDirField.Value);
        selected_dir = uigetdir(start_dir, '选择输出目录');
        if isequal(selected_dir, 0)
            return;
        end
        ui.OutputDirField.Value = selected_dir;
        append_gui_log(ui.LogTextArea, sprintf('已选择输出目录: %s', selected_dir));
    end

    function choose_lookup_file()
        [selected_file, selected_path] = uigetfile({'*.ced', 'CED 文件 (*.ced)'}, ...
            '选择电极定位文件', choose_start_file(ui.LookupFileField.Value));
        if isequal(selected_file, 0)
            return;
        end
        lookup_path = fullfile(selected_path, selected_file);
        ui.LookupFileField.Value = lookup_path;
        append_gui_log(ui.LogTextArea, sprintf('已选择电极定位文件: %s', lookup_path));
    end

    function update_source_count()
        source_dir = string(strtrim(string(ui.SourceDirField.Value)));
        if strlength(source_dir) == 0 || ~isfolder(source_dir)
            ui.CntCountValueField.Value = 'CNT 文件数 -';
            return;
        end

        try
            count = count_cnt_files(source_dir);
            ui.CntCountValueField.Value = sprintf('CNT 文件数 %d', count);
        catch err
            ui.CntCountValueField.Value = 'CNT 文件数读取错误';
            append_gui_log(ui.LogTextArea, string(err.message));
        end
    end

    function load_config_callback()
        try
            loaded_cfg = load_preprocess_config();
            apply_config_to_gui(ui, loaded_cfg);
            append_gui_log(ui.LogTextArea, '已从 preprocess_config.json 加载配置。');
        catch err
            handle_gui_error(err, '加载配置失败');
        end
    end

    function save_config_callback()
        try
            cfg_to_save = collect_gui_config(ui);
            cfg_to_save.lookup_file = validate_lookup_file_path(cfg_to_save.lookup_file);
            save_preprocess_config(cfg_to_save);
            ui.LookupFileField.Value = char(cfg_to_save.lookup_file);
            append_gui_log(ui.LogTextArea, '已将配置保存到 preprocess_config.json。');
            ui.StatusValueLabel.Text = '配置已保存';
        catch err
            handle_gui_error(err, '保存配置失败');
        end
    end

    function execute_run(smoke_test)
        set_controls_enabled(false);
        ui.StatusValueLabel.Text = '处理中';
        ui.StatsValueLabel.Text = '已处理: 0 | 已跳过: 0 | 失败: 0';
        ui.LastLogField.Value = '';

        try
            report = run_preprocess_from_gui(ui, smoke_test);
            fig.UserData.last_report = report;
        catch err
            ui.StatusValueLabel.Text = '失败';
            append_gui_log(ui.LogTextArea, string(getReport(err, 'basic', 'hyperlinks', 'off')));
            uialert(fig, err.message, '处理失败');
        end

        set_controls_enabled(true);
    end

    function clear_log_callback()
        ui.LogTextArea.Value = {'日志已清空。'};
    end

    function set_controls_enabled(enabled)
        state = 'off';
        if enabled
            state = 'on';
        end

        for idx = 1:numel(controls_to_disable)
            controls_to_disable{idx}.Enable = state;
        end
        drawnow limitrate;
    end

    function handle_gui_error(err, title_text)
        append_gui_log(ui.LogTextArea, string(getReport(err, 'basic', 'hyperlinks', 'off')));
        uialert(fig, err.message, title_text);
    end
end

function start_dir = choose_start_directory(current_value)
start_dir = char(string(current_value));
if isempty(start_dir) || ~isfolder(start_dir)
    start_dir = pwd;
end
end

function start_dir = choose_start_file(current_value)
current_value = string(strtrim(string(current_value)));
if strlength(current_value) > 0 && isfile(current_value)
    start_dir = fileparts(char(current_value));
else
    start_dir = choose_start_directory(current_value);
end
end

function ensure_src_on_path()
script_dir = fileparts(mfilename('fullpath'));
src_dir = fullfile(script_dir, 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end
end
