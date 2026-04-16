function reference_targets = resolve_reference_targets(labels, reference_mode, reference_labels)
%RESOLVE_REFERENCE_TARGETS Resolve EEGLAB rereference targets by mode.

reference_mode = string(reference_mode);

switch reference_mode
    case "average"
        reference_targets = [];
    case "m1_m2"
        reference_targets = find_reference_channel_indices(labels, reference_labels);
    otherwise
        error('EEGPreprocess:InvalidReferenceMode', ...
            'reference_mode 必须是 average 或 m1_m2。');
end
end
