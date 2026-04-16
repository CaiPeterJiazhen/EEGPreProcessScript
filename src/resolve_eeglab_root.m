function eeglab_root = resolve_eeglab_root(configured_path, eeglab_file)
%RESOLVE_EEGLAB_ROOT Resolve the EEGLAB root folder from config or path.

configured_path = string(configured_path);
eeglab_file = string(eeglab_file);
eeglab_root = "";

if strlength(configured_path) > 0
    candidate = configured_path;
    if isfile(candidate)
        candidate = string(fileparts(char(candidate)));
    end
    if isfolder(candidate)
        eeglab_root = candidate;
        return;
    end
end

if strlength(eeglab_file) > 0
    eeglab_root = string(fileparts(char(eeglab_file)));
end
end
