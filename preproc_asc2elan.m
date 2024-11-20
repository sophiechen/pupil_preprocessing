function preproc_asc2elan(filename,m_data,type)

% filename : aci file
% data matrice : output of blink_detection_pupil_size.m
% type == 'mono' ou 'bino'
% addpath ../../fieldtrip-20210209
ft_defaults

% filename out
[filepath,name,ext] = fileparts(filename);
eegfileout          = [filepath '/' name '.pupilELAN.eeg'];
posfileout          = [filepath '/' name '.pupilELAN.pos'];

% Data import
cfg                  = [];
cfg.montage.tra      = eye(4);
cfg.montage.labelorg = {'1', '2', '3', '4'};
cfg.montage.labelnew = {'EYE_TIMESTAMP', 'EYE_HORIZONTAL', 'EYE_VERTICAL', 'EYE_DIAMETER'};
cfg.dataset          = filename;

data        = ft_preprocessing(cfg);
event       = eyelink_extract_event(filename);
event       = struct2table(event);

%%
if type == 'mono'
    v_label = {'EYE_TIMESTAMP','EYE_DIAMETER','DATA_intp','DATA_nan','blinks','detect_signal'}; % au hasard
    v_channel_type = v_label; 
    v_channel_unit = {'AU','AU','AU','AU','AU','AU'};

end

if type == 'bino'
    v_label = {'EYE_TIMESTAMP','EYE_DIAMETER_L','DATA_intp_L','DATA_nan_L','blinks_L','detect_signal_L','EYE_DIAMETER_R','DATA_intp_R','DATA_nan_R','blinks_R','detect_signal_R'}; % au hasard
    v_channel_type = v_label; 
    v_channel_unit = {'AU','AU','AU','AU','AU','AU','AU','AU','AU','AU','AU'};

end




%%

% Pos creation
pos(:,1)    = event.sample;
pos(:,2)    = event.value;
pos(:,3)    = 0;

dlmwrite(posfileout,pos,'delimiter','\t','precision',10);

% ELAN file creation
% addpath /usr/local/Elan/misc/matlab/

% m_data = data.trial{1}(4,:);   
filenameout = eegfileout;
m_events  = pos(:,1:2);
str_ori_file1 = 'Eyelink 1000';
str_ori_file2 = 'Box PAM';
s_fs   = data.hdr.Fs;
% v_channel_type = {'EYE_DIAMETER'}; 
% v_channel_unit = {'AU'};

mat2eeg(m_data, filenameout, m_events, str_ori_file1, str_ori_file2, s_fs, v_label, v_channel_type,v_channel_unit)
