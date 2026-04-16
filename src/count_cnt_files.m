function count = count_cnt_files(source_root)
%COUNT_CNT_FILES Count all CNT files below a source root.

files = collect_cnt_files(source_root);
count = numel(files);
end
