% EEGLAB history file generated on the 16-Apr-2026
% ------------------------------------------------

EEG.etc.eeglabvers = '2021.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_loadcnt('F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG\基线\sub01穆祥贵\mxg1.cnt' , 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','F:\\CJZFile\\EEG_M1\\standard_1005.ced');
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'M1','M2','HEO','VEO','EKG','EMG'});
EEG = eeg_checkset( EEG );
EEG = pop_resample( EEG, 250);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'plotfreqz',1);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'hicutoff',45,'plotfreqz',1);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
EEG = eeg_checkset( EEG );
