function append_gui_log(uiTextArea, message)
%APPEND_GUI_LOG Append one or more log lines to a GUI text area.

message = string(message);
new_lines = splitlines(message);
new_lines = new_lines(strlength(new_lines) > 0);

if iscell(uiTextArea.Value)
    current_lines = string(uiTextArea.Value);
else
    current_lines = string(uiTextArea.Value);
end

current_lines = current_lines(:);
updated_lines = [current_lines; new_lines(:)];
uiTextArea.Value = cellstr(updated_lines);
drawnow limitrate;
end
