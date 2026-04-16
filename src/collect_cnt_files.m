function files = collect_cnt_files(source_root)
%COLLECT_CNT_FILES Recursively collect .cnt files below a source root.

source_root = string(source_root);

if ~isfolder(source_root)
    error('EEGPreprocess:InvalidSourceRoot', ...
        '源目录不存在: %s', char(source_root));
end

listing = dir(fullfile(char(source_root), '**', '*.cnt'));
files = strings(numel(listing), 1);

for idx = 1:numel(listing)
    files(idx) = string(fullfile(listing(idx).folder, listing(idx).name));
end

files = sort(files);
end
