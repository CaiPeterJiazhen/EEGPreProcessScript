function remove_labels = get_remove_channels_for_reference_mode(base_remove_channels, reference_mode, reference_labels)
%GET_REMOVE_CHANNELS_FOR_REFERENCE_MODE Return channels to remove by mode.

base_remove_channels = reshape(string(base_remove_channels), 1, []);
reference_mode = string(reference_mode);
reference_labels = reshape(string(reference_labels), 1, []);

switch reference_mode
    case "average"
        remove_labels = [base_remove_channels reference_labels];
    case "m1_m2"
        remove_labels = base_remove_channels;
    otherwise
        error('EEGPreprocess:InvalidReferenceMode', ...
            'reference_mode 必须是 average 或 m1_m2。');
end

remove_labels = unique(remove_labels, 'stable');
end
