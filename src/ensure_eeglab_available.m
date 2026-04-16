function ensure_eeglab_available(cfg)
%ENSURE_EEGLAB_AVAILABLE Add/check EEGLAB and required functions.

cfg = normalize_preprocess_config(cfg);

if strlength(cfg.eeglab_path) > 0
    addpath(genpath(char(cfg.eeglab_path)));
end

required_functions = {
    'eeg_checkset'
    'pop_loadcnt'
    'pop_chanedit'
    'pop_select'
    'pop_resample'
    'pop_eegfiltnew'
    'pop_reref'
    'pop_saveset'
    };

missing_functions = strings(0, 1);

for idx = 1:numel(required_functions)
    if exist(required_functions{idx}, 'file') ~= 2
        missing_functions(end + 1, 1) = string(required_functions{idx}); %#ok<AGROW>
    end
end

if ~isempty(missing_functions)
    error('EEGPreprocess:MissingEEGLAB', ...
        'EEGLAB functions not found on the MATLAB path: %s', ...
        strjoin(missing_functions, ', '));
end
end
