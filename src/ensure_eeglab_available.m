function ensure_eeglab_available(cfg)
%ENSURE_EEGLAB_AVAILABLE Add/check EEGLAB and required functions.

cfg = normalize_preprocess_config(cfg);
eeglab_root = resolve_eeglab_root(cfg.eeglab_path, which('eeglab'));

if strlength(eeglab_root) > 0
    addpath(genpath(char(eeglab_root)));
    rehash;
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
        ['MATLAB 路径中未找到 EEGLAB 所需函数: %s。' ...
         '请在配置中设置 eeglab_path 为 EEGLAB 根目录，' ...
         '或确保 eeglab.m 所在目录及其 plugins 已加入 MATLAB 路径。'], ...
        strjoin(missing_functions, ', '));
end
end
