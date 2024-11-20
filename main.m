
clear all
close all
cd C:\Users\sophie\Documents\DCP\eye_tracking\pupillometry\code_preprocessing_sophie\toolbox2

ft_defaults % C:\Users\sophie\Documents\software\fieldtrip-20210623
addpath('C:\Users\sophie\Documents\DCP\eye_tracking\pupillometry\code_preprocessing_sophie\toolbox2')


filename_path = 'C:\Users\sophie\Nextcloud\Shared\Pupillo\data2start\data\28_06_21_1-1.asc';

type = 'bino';
method = 'SV';%'FP'; % ou 

pretime_1 = -50;
posttime_1 = 100;
pretime_2 = -50; %-150;
posttime_2 = 100; %250;
% seuil = 100; %fp
seuil = 10000; %sv

out_data = blink_detection_pupil_size(filename_path,method,type,pretime_1,posttime_1,pretime_2,posttime_2,seuil);
% save -7.3 out_data out_data  
  preproc_asc2elan(filename_path,out_data,type)

%     v_label = {'EYE_TIMESTAMP','EYE_DIAMETER_L','DATA_intp_L','DATA_nan_L','blinks_L','detect_signal','EYE_DIAMETER_R','DATA_intp_R','DATA_nan_R','blinks_R','detect_signal'}; 

figure
plot((out_data(1,:)-out_data(1,1))./1000,out_data(2,:))
hold on
plot((out_data(1,:)-out_data(1,1))./1000,out_data(5,:)*1000,"r")
hold on
plot((out_data(1,:)-out_data(1,1))./1000,abs(out_data(6,:)),"k")

cd C:\Users\sophie\Documents\DCP\eye_tracking\pupillometry\code_preprocessing_sophie\toolbox2



