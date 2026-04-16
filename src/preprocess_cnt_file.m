function result = preprocess_cnt_file(input_file, source_root, cfg)
%PREPROCESS_CNT_FILE Apply EEGLAB preprocessing steps 1-6 to one CNT file.

cfg = normalize_preprocess_config(cfg);
input_file = string(input_file);
source_root = string(source_root);
paths = build_output_paths(source_root, input_file, cfg.output_root);

result = empty_result();
result.input_file = input_file;
result.output_dir = paths.output_dir;
result.set_path = paths.set_path;
result.fdt_path = paths.fdt_path;

if isfile(paths.set_path) && ~cfg.overwrite_existing
    result.status = "skipped_existing";
    result.message = "输出已存在，且 overwrite_existing 为 false。";
    return;
end

if ~isfolder(paths.output_dir)
    mkdir(char(paths.output_dir));
end

EEG = pop_loadcnt(char(input_file), 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset(EEG);
EEG = pop_chanedit(EEG, 'lookup', char(cfg.lookup_file));
EEG = eeg_checkset(EEG);

remove_requests = get_remove_channels_for_reference_mode( ...
    cfg.remove_channels, cfg.reference_mode, cfg.reference_labels);
remove_labels = existing_labels(EEG, remove_requests);
if ~isempty(remove_labels)
    EEG = pop_select(EEG, 'nochannel', cellstr(remove_labels));
    EEG = eeg_checkset(EEG);
end

if cfg.target_sample_rate > 0 && EEG.srate ~= cfg.target_sample_rate
    EEG = pop_resample(EEG, cfg.target_sample_rate);
    EEG = eeg_checkset(EEG);
end

if cfg.highpass_hz > 0
    EEG = pop_eegfiltnew(EEG, 'locutoff', cfg.highpass_hz, 'plotfreqz', 0);
    EEG = eeg_checkset(EEG);
end

if cfg.lowpass_hz > 0
    EEG = pop_eegfiltnew(EEG, 'hicutoff', cfg.lowpass_hz, 'plotfreqz', 0);
    EEG = eeg_checkset(EEG);
end

EEG = pop_eegfiltnew(EEG, ...
    'locutoff', cfg.notch_band_hz(1), ...
    'hicutoff', cfg.notch_band_hz(2), ...
    'revfilt', 1, ...
    'plotfreqz', 0);
EEG = eeg_checkset(EEG);

reference_targets = resolve_reference_targets( ...
    EEG.chanlocs, cfg.reference_mode, cfg.reference_labels);
EEG = pop_reref(EEG, reference_targets);
EEG = eeg_checkset(EEG);

[~, set_name, ~] = fileparts(char(paths.set_path));
EEG = pop_saveset(EEG, ...
    'filename', [set_name '.set'], ...
    'filepath', char(paths.output_dir), ...
    'savemode', 'twofiles');

result.status = "processed";
result.message = "";
result.output_dir = paths.output_dir;
result.channel_count = double(EEG.nbchan);
result.sample_rate = double(EEG.srate);
end

function result = empty_result()
result = struct( ...
    'input_file', "", ...
    'output_dir', "", ...
    'set_path', "", ...
    'fdt_path', "", ...
    'status', "", ...
    'message', "", ...
    'channel_count', NaN, ...
    'sample_rate', NaN, ...
    'elapsed_seconds', NaN);
end

function labels = existing_labels(EEG, requested_labels)
channel_labels = strip(string({EEG.chanlocs.labels}));
requested_labels = strip(string(requested_labels));
labels = strings(0, 1);

for idx = 1:numel(requested_labels)
    match_index = find(strcmpi(channel_labels, requested_labels(idx)), 1, 'first');
    if ~isempty(match_index)
        labels(end + 1, 1) = channel_labels(match_index); %#ok<AGROW>
    end
end

labels = reshape(labels, 1, []);
end
