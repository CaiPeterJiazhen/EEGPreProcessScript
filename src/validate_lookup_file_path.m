function lookup_file = validate_lookup_file_path(lookup_file)
%VALIDATE_LOOKUP_FILE_PATH Validate and normalize a GUI lookup-file path.

lookup_file = string(strtrim(string(lookup_file)));

if strlength(lookup_file) == 0
    error('EEGPreprocess:MissingLookupFile', ...
        '请选择电极定位文件。');
end

if ~isfile(lookup_file)
    error('EEGPreprocess:LookupFileNotFound', ...
        '电极定位文件不存在: %s', char(lookup_file));
end

[~, ~, ext] = fileparts(char(lookup_file));
if ~strcmpi(ext, '.ced')
    error('EEGPreprocess:InvalidLookupFile', ...
        '电极定位文件必须是 .ced 文件: %s', char(lookup_file));
end
end
