function paths = build_output_paths(source_root, input_file, output_root)
%BUILD_OUTPUT_PATHS Mirror the source hierarchy below the output root.

source_root = strip_trailing_separator(string(source_root));
input_file = string(input_file);
output_root = strip_trailing_separator(string(output_root));

prefix = source_root + filesep;
if ~(strcmpi(input_file, source_root) || startsWith(input_file, prefix, 'IgnoreCase', true))
    error('EEGPreprocess:InputOutsideSourceRoot', ...
        'Input file is not under the source root: %s', input_file);
end

[~, source_name] = fileparts(char(source_root));
relative_file = extractAfter(input_file, strlength(prefix));
[relative_dir, base_name, ~] = fileparts(char(relative_file));

output_dir = fullfile(char(output_root), source_name, relative_dir);

paths = struct();
paths.output_dir = string(output_dir);
paths.set_path = string(fullfile(output_dir, [base_name '.set']));
paths.fdt_path = string(fullfile(output_dir, [base_name '.fdt']));
end

function path_value = strip_trailing_separator(path_value)
path_value = string(path_value);
while strlength(path_value) > 0 && ...
        (endsWith(path_value, "\") || endsWith(path_value, "/"))
    path_value = extractBefore(path_value, strlength(path_value));
end
end
