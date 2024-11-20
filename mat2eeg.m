function mat2eeg(m_data, filename, m_events, str_ori_file1, str_ori_file2, s_fs, v_label, v_channel_type,v_channel_unit,varargin)
%% function
% mat2eeg(m_data, filename, m_events, str_ori_file1, str_ori_file2, s_fs, v_label, v_channel_type,v_channel_unit,varargin)
%
% Write *.eeg Elan file (V3) from Matlab matrix
%
% m_data         :  data matrix (1 channel per line, 1 sample per column)
% filename       :  output filename '.eeg' with the complete path
% m_events       :  Table with the events (samples and event codes)
% str_ori_file1  :  Acquisition system
% str_ori_file2  :  Acquisition place
% s_fs           :  Sampling frequency (Hz)
% v_label        :  Name of the channels (with numbers in elec.dat) Ex: For ActiCAp load '/matlab_prog/util_ELAN/conversion_generique/ActiCap_Elec.mat'
% v_channel_type :  Sensor types
% v_channel_unit :  Sensor units
%
% OPTIONAL :
%          *  'Channel_Filter',v_channel_filter  : Filter description for
%          each channel
%
% V01 Emmanuel Maby, le 23/10/2009
% V02 Anne Caclin, le 20/11/2009
% V03 Emmanuel Maby, le 27/01/2010
% v1.04 (09-08-2010) PEA
% Minor change : version number to follow Elan rules.
% v1.05 (20-04-2011) PEA
% Sets Terminator value to 10 to have the Linux line return (when running
% in Windows) and fixes digital channels definition in header file.
% v1.06 (31-05-2011) PEA
% Fixes initialization of data_out to add the 2 digital channels (didn't
% work with only one channel).
% v1.07 (10-02-2012) PEA
% Fixes error printing message (with printf instead of disp).
%%

if ~isempty(varargin)
    for i_arg=1:length(varargin)
        if strcmpi(varargin{i_arg},'Channel_Filter');
            v_channel_filter = varargin{i_arg+1};
        end
    end
else
    v_channel_filter=[];
end

Terminator = 10; % Linux LF line terminator

filename_ent=strcat(filename, '.ent');
s_Te = 1/s_fs;
s_nb_channel_all = size(m_data,1) + 2;

%--------------------------------------------------------
%             Write EEG.ENT file
%--------------------------------------------------------

% fic_eeg_ent = fopen(filename_ent, 'wt'); %sous linux
fic_eeg_ent = fopen(filename_ent, 'w'); %sous windows

if (fic_eeg_ent==-1)
    disp(['Error reading file ' filename_ent '.']);
    return;
end
fprintf(fic_eeg_ent, 'V3\n');
fprintf(fic_eeg_ent, '%s\n',str_ori_file1);
fprintf(fic_eeg_ent, '%s\n',str_ori_file2);

time=fix(clock);
fprintf(fic_eeg_ent, '%d-%d-%d %d:%d:%d\n', time(3),time(2),time(1),time(4),time(5),time(6));
fprintf(fic_eeg_ent, '%d-%d-%d %d:%d:%d\n', time(3),time(2),time(1),time(4),time(5),time(6));

fprintf(fic_eeg_ent, '-1\n');
fprintf(fic_eeg_ent, 'reserved\n');
fprintf(fic_eeg_ent, '-1\n');

fprintf(fic_eeg_ent, '%f\n', s_Te);
fprintf(fic_eeg_ent, '%d\n', s_nb_channel_all);

for i=1:s_nb_channel_all-2
    if (iscell(v_label(i)))
        fprintf(fic_eeg_ent, '%s\n', char(cell2mat(v_label(i))));
    else
        fprintf(fic_eeg_ent, '%s\n', char((v_label(i))));
    end
end
fprintf(fic_eeg_ent, 'dig1.-1\n');
fprintf(fic_eeg_ent, 'dig2.-1\n');

for i=1:s_nb_channel_all-2
    if (iscell(v_channel_type(i)))
        fprintf(fic_eeg_ent, '%s\n', char(cell2mat(v_channel_type(i))));
    else
        fprintf(fic_eeg_ent, '%s\n', char((v_channel_type(i))));
    end
end
fprintf(fic_eeg_ent, 'counter\n');
fprintf(fic_eeg_ent, 'event\n');

for i=1:s_nb_channel_all-2
    if (iscell(v_channel_unit(i)))
        fprintf(fic_eeg_ent, '%s\n', char(cell2mat(v_channel_unit(i))));
    else
        fprintf(fic_eeg_ent, '%s\n', (char(v_channel_unit(i))));
    end
end
fprintf(fic_eeg_ent, 'none\n');
fprintf(fic_eeg_ent, 'none\n');

% Search physical min/max  values
valmin=min(m_data,[],2);
valmax=max(m_data,[],2);
max_minmax = max(abs(valmin), abs(valmax));

for i=1:s_nb_channel_all-2
    fprintf(fic_eeg_ent, '-%f\n', max_minmax(i));
end
fprintf(fic_eeg_ent, '-32767\n');
fprintf(fic_eeg_ent, '-32767\n');

for i=1:s_nb_channel_all-2
    fprintf(fic_eeg_ent, '+%f\n', max_minmax(i));
end
fprintf(fic_eeg_ent, '+32767\n');
fprintf(fic_eeg_ent, '+32767\n');

for i=1:s_nb_channel_all
    fprintf(fic_eeg_ent, '%d\n', intmin('int32'));
end

for i=1:s_nb_channel_all
    fprintf(fic_eeg_ent, '%d\n', intmax('int32'));
end


if isempty(v_channel_filter)
    for i=1:s_nb_channel_all-2
        fprintf(fic_eeg_ent, 'unknown filter parameters\n');
    end
else
    for i=1:s_nb_channel_all-2
        fprintf(fic_eeg_ent, '%s\n', char(cell2mat(v_channel_filter(i))));
    end
end
fprintf(fic_eeg_ent, 'none\n');
fprintf(fic_eeg_ent, 'none\n');

for i=1:s_nb_channel_all
    fprintf(fic_eeg_ent, '1\n');
end

for i=1:s_nb_channel_all
    fprintf(fic_eeg_ent, 'reserved\n');
end

fclose(fic_eeg_ent);
%--------------------------------------------------------

%--------------------------------------------------------
%             Write EEG file
%--------------------------------------------------------
% Convert analogic values in int 32 bits (DAC values)
max_ANA=[max_minmax;1;1];
for i=1:s_nb_channel_all-2
    if (max_ANA(i)==0)
        max_ANA(i)=1;
    end
end

data_out = [m_data ; zeros(2, size(m_data, 2))];

data_out=data_out*(2147483648+2147483647);
data_out(s_nb_channel_all-1:s_nb_channel_all,:)=0;
numevent=1;
cpt=0;
for i=1:size(m_data,2)
    data_out(:,i)=data_out(:,i)./(2*max_ANA);

    % Digital channels
    event = 0;
    if (numevent<size(m_events,1)+1)
        if (i>=m_events(numevent,1))
            cpt=0;
            event=m_events(numevent,2);
            numevent=numevent+1;
        end
    end

    if (cpt > 65535)
        cpt=0;
    end
    data_out(s_nb_channel_all-1,i)=cpt;
    data_out(s_nb_channel_all,i)=event;
    cpt=cpt+1;
end

data_out=fix(data_out);

fid_eeg=fopen(filename, 'wb','b');
if (fid_eeg==-1)
    disp(['Error opening file ' filename ' .']);
    return
end
fwrite(fid_eeg, data_out, 'int32');
fclose(fid_eeg);
