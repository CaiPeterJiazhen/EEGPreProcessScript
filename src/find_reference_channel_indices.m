function indices = find_reference_channel_indices(labels, reference_labels)
%FIND_REFERENCE_CHANNEL_INDICES Resolve exact reference labels to indices.

if isstruct(labels)
    labels = string({labels.labels});
else
    labels = string(labels);
end

labels = strip(labels);
reference_labels = strip(string(reference_labels));

indices = zeros(1, numel(reference_labels));

for idx = 1:numel(reference_labels)
    match_index = find(strcmpi(labels, reference_labels(idx)), 1, 'first');
    if isempty(match_index)
        error('EEGPreprocess:MissingReferenceChannel', ...
            '未找到参考电极通道 %s。', reference_labels(idx));
    end
    indices(idx) = match_index;
end
end
