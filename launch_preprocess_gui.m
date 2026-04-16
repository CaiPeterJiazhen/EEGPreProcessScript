function fig = launch_preprocess_gui()
%LAUNCH_PREPROCESS_GUI Launch the EEG batch preprocess GUI.

ensure_src_on_path();
cfg = load_preprocess_config();
ui = struct();

fig = uifigure('Name', 'EEG Preprocess GUI', 'Position', [100 100 1040 680]);
fig.UserData = struct();
mainGrid = uigridlayout(fig, [3 1]);
mainGrid.RowHeight = {130, '1x', 60};
mainGrid.Padding = [10 10 10 10];
mainGrid.RowSpacing = 10;

pathPanel = uipanel(mainGrid, 'Title', 'Directories');
pathGrid = uigridlayout(pathPanel, [3 3]);
pathGrid.RowHeight = {28, 28, 28};
pathGrid.ColumnWidth = {80, '1x', 120};

sourceLabel = uilabel(pathGrid, 'Text', 'Source', 'HorizontalAlignment', 'right');
sourceLabel.Layout.Row = 1;
sourceLabel.Layout.Column = 1;

ui.SourceDirField = uieditfield(pathGrid, 'text');
ui.SourceDirField.Layout.Row = 1;
ui.SourceDirField.Layout.Column = 2;
ui.SourceDirField.ValueChangedFcn = @(~, ~) update_source_count();

ui.SourceBrowseButton = uibutton(pathGrid, 'push', 'Text', 'Select Source', ...
    'ButtonPushedFcn', @(~, ~) choose_source_directory());
ui.SourceBrowseButton.Layout.Row = 1;
ui.SourceBrowseButton.Layout.Column = 3;

outputLabel = uilabel(pathGrid, 'Text', 'Output', 'HorizontalAlignment', 'right');
outputLabel.Layout.Row = 2;
outputLabel.Layout.Column = 1;

ui.OutputDirField = uieditfield(pathGrid, 'text');
ui.OutputDirField.Layout.Row = 2;
ui.OutputDirField.Layout.Column = 2;

ui.OutputBrowseButton = uibutton(pathGrid, 'push', 'Text', 'Select Output', ...
    'ButtonPushedFcn', @(~, ~) choose_output_directory());
ui.OutputBrowseButton.Layout.Row = 2;
ui.OutputBrowseButton.Layout.Column = 3;

scanLabel = uilabel(pathGrid, 'Text', 'Scan', 'HorizontalAlignment', 'right');
scanLabel.Layout.Row = 3;
scanLabel.Layout.Column = 1;

ui.CntCountValueLabel = uilabel(pathGrid, 'Text', 'CNT files: -');
ui.CntCountValueLabel.Layout.Row = 3;
ui.CntCountValueLabel.Layout.Column = [2 3];

centerGrid = uigridlayout(mainGrid, [1 2]);
centerGrid.ColumnWidth = {280, '1x'};
centerGrid.ColumnSpacing = 10;

paramPanel = uipanel(centerGrid, 'Title', 'Parameters');
paramGrid = uigridlayout(paramPanel, [7 2]);
paramGrid.RowHeight = {28, 28, 28, 28, 28, '1x', '1x'};
paramGrid.ColumnWidth = {120, '1x'};

sampleLabel = uilabel(paramGrid, 'Text', 'Sample Rate', 'HorizontalAlignment', 'right');
sampleLabel.Layout.Row = 1;
sampleLabel.Layout.Column = 1;
ui.SampleRateField = uieditfield(paramGrid, 'numeric');
ui.SampleRateField.Layout.Row = 1;
ui.SampleRateField.Layout.Column = 2;

highpassLabel = uilabel(paramGrid, 'Text', 'High-pass (Hz)', 'HorizontalAlignment', 'right');
highpassLabel.Layout.Row = 2;
highpassLabel.Layout.Column = 1;
ui.HighpassField = uieditfield(paramGrid, 'numeric');
ui.HighpassField.Layout.Row = 2;
ui.HighpassField.Layout.Column = 2;

lowpassLabel = uilabel(paramGrid, 'Text', 'Low-pass (Hz)', 'HorizontalAlignment', 'right');
lowpassLabel.Layout.Row = 3;
lowpassLabel.Layout.Column = 1;
ui.LowpassField = uieditfield(paramGrid, 'numeric');
ui.LowpassField.Layout.Row = 3;
ui.LowpassField.Layout.Column = 2;

overwriteLabel = uilabel(paramGrid, 'Text', 'Overwrite', 'HorizontalAlignment', 'right');
overwriteLabel.Layout.Row = 4;
overwriteLabel.Layout.Column = 1;
ui.OverwriteCheckBox = uicheckbox(paramGrid, 'Text', 'Overwrite existing outputs');
ui.OverwriteCheckBox.Layout.Row = 4;
ui.OverwriteCheckBox.Layout.Column = 2;

saveLogLabel = uilabel(paramGrid, 'Text', 'Save Log', 'HorizontalAlignment', 'right');
saveLogLabel.Layout.Row = 5;
saveLogLabel.Layout.Column = 1;
ui.SaveLogCheckBox = uicheckbox(paramGrid, 'Text', 'Save CSV log');
ui.SaveLogCheckBox.Layout.Row = 5;
ui.SaveLogCheckBox.Layout.Column = 2;

statusPanel = uipanel(centerGrid, 'Title', 'Status and Logs');
statusGrid = uigridlayout(statusPanel, [4 2]);
statusGrid.RowHeight = {24, 24, 24, '1x'};
statusGrid.ColumnWidth = {120, '1x'};

statusLabel = uilabel(statusGrid, 'Text', 'Status', 'HorizontalAlignment', 'right');
statusLabel.Layout.Row = 1;
statusLabel.Layout.Column = 1;
ui.StatusValueLabel = uilabel(statusGrid, 'Text', 'Idle');
ui.StatusValueLabel.Layout.Row = 1;
ui.StatusValueLabel.Layout.Column = 2;

summaryLabel = uilabel(statusGrid, 'Text', 'Summary', 'HorizontalAlignment', 'right');
summaryLabel.Layout.Row = 2;
summaryLabel.Layout.Column = 1;
ui.StatsValueLabel = uilabel(statusGrid, 'Text', 'Processed: 0 | Skipped: 0 | Failed: 0');
ui.StatsValueLabel.Layout.Row = 2;
ui.StatsValueLabel.Layout.Column = 2;

lastLogLabel = uilabel(statusGrid, 'Text', 'Last Log', 'HorizontalAlignment', 'right');
lastLogLabel.Layout.Row = 3;
lastLogLabel.Layout.Column = 1;
ui.LastLogField = uieditfield(statusGrid, 'text', 'Editable', 'off');
ui.LastLogField.Layout.Row = 3;
ui.LastLogField.Layout.Column = 2;

ui.LogTextArea = uitextarea(statusGrid, 'Editable', 'off');
ui.LogTextArea.Layout.Row = 4;
ui.LogTextArea.Layout.Column = [1 2];
ui.LogTextArea.Value = {'GUI started.'};

buttonGrid = uigridlayout(mainGrid, [1 5]);
buttonGrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};

ui.LoadConfigButton = uibutton(buttonGrid, 'push', 'Text', 'Load Config', ...
    'ButtonPushedFcn', @(~, ~) load_config_callback());
ui.SaveConfigButton = uibutton(buttonGrid, 'push', 'Text', 'Save Config', ...
    'ButtonPushedFcn', @(~, ~) save_config_callback());
ui.RunButton = uibutton(buttonGrid, 'push', 'Text', 'Start Processing', ...
    'ButtonPushedFcn', @(~, ~) execute_run(false));
ui.SmokeButton = uibutton(buttonGrid, 'push', 'Text', 'Smoke Test', ...
    'ButtonPushedFcn', @(~, ~) execute_run(true));
ui.ClearLogButton = uibutton(buttonGrid, 'push', 'Text', 'Clear Log', ...
    'ButtonPushedFcn', @(~, ~) clear_log_callback());

apply_config_to_gui(ui, cfg);
ui.SourceDirField.Value = '';
ui.LastLogField.Value = '';
ui.CntCountValueLabel.Text = 'CNT files: -';
fig.UserData.ui = ui;

controls_to_disable = {
    ui.SourceDirField, ui.SourceBrowseButton, ...
    ui.OutputDirField, ui.OutputBrowseButton, ...
    ui.SampleRateField, ui.HighpassField, ui.LowpassField, ...
    ui.OverwriteCheckBox, ui.SaveLogCheckBox, ...
    ui.LoadConfigButton, ui.SaveConfigButton, ...
    ui.RunButton, ui.SmokeButton
    };

    function choose_source_directory()
        start_dir = choose_start_directory(ui.SourceDirField.Value);
        selected_dir = uigetdir(start_dir, 'Select source directory');
        if isequal(selected_dir, 0)
            return;
        end
        ui.SourceDirField.Value = selected_dir;
        update_source_count();
        append_gui_log(ui.LogTextArea, sprintf('Selected source directory: %s', selected_dir));
    end

    function choose_output_directory()
        start_dir = choose_start_directory(ui.OutputDirField.Value);
        selected_dir = uigetdir(start_dir, 'Select output directory');
        if isequal(selected_dir, 0)
            return;
        end
        ui.OutputDirField.Value = selected_dir;
        append_gui_log(ui.LogTextArea, sprintf('Selected output directory: %s', selected_dir));
    end

    function update_source_count()
        source_dir = string(strtrim(string(ui.SourceDirField.Value)));
        if strlength(source_dir) == 0 || ~isfolder(source_dir)
            ui.CntCountValueLabel.Text = 'CNT files: -';
            return;
        end

        try
            count = count_cnt_files(source_dir);
            ui.CntCountValueLabel.Text = sprintf('CNT files: %d', count);
        catch err
            ui.CntCountValueLabel.Text = 'CNT files: error';
            append_gui_log(ui.LogTextArea, string(err.message));
        end
    end

    function load_config_callback()
        try
            loaded_cfg = load_preprocess_config();
            apply_config_to_gui(ui, loaded_cfg);
            append_gui_log(ui.LogTextArea, 'Loaded config from preprocess_config.json');
        catch err
            handle_gui_error(err, 'Load Config Failed');
        end
    end

    function save_config_callback()
        try
            cfg_to_save = collect_gui_config(ui);
            save_preprocess_config(cfg_to_save);
            append_gui_log(ui.LogTextArea, 'Saved config to preprocess_config.json');
            ui.StatusValueLabel.Text = 'Config saved';
        catch err
            handle_gui_error(err, 'Save Config Failed');
        end
    end

    function execute_run(smoke_test)
        set_controls_enabled(false);
        ui.StatusValueLabel.Text = 'Running';
        ui.StatsValueLabel.Text = 'Processed: 0 | Skipped: 0 | Failed: 0';
        ui.LastLogField.Value = '';

        try
            report = run_preprocess_from_gui(ui, smoke_test);
            fig.UserData.last_report = report;
        catch err
            ui.StatusValueLabel.Text = 'Failed';
            append_gui_log(ui.LogTextArea, string(getReport(err, 'basic', 'hyperlinks', 'off')));
            uialert(fig, err.message, 'Processing Failed');
        end

        set_controls_enabled(true);
    end

    function clear_log_callback()
        ui.LogTextArea.Value = {'Log cleared.'};
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

function ensure_src_on_path()
script_dir = fileparts(mfilename('fullpath'));
src_dir = fullfile(script_dir, 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end
end


