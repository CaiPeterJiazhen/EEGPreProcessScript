function lookup_file = validate_lookup_file_path(lookup_file)
%VALIDATE_LOOKUP_FILE_PATH Validate and normalize a GUI lookup-file path.

lookup_file = string(strtrim(string(lookup_file)));

if strlength(lookup_file) == 0
    error('EEGPreprocess:MissingLookupFile', ...
        'Please select an electrode lookup file.');
end

if ~isfile(lookup_file)
    error('EEGPreprocess:LookupFileNotFound', ...
        'Lookup file does not exist: %s', char(lookup_file));
end

[~, ~, ext] = fileparts(char(lookup_file));
if ~strcmpi(ext, '.ced')
    error('EEGPreprocess:InvalidLookupFile', ...
        'Lookup file must be a .ced file: %s', char(lookup_file));
end
end
