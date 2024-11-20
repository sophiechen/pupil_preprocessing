function out_data = blink_detection_pupil_size(filename_path,method,type,pretime_1,posttime_1,pretime_2,posttime_2,seuil)



% blink détection on ascii files from eyelink asc files
% create a folder after the data file name and save in it the figures and
% the ELAN file

% inputs :

% filename : ascii file from eye link system
% method : 'FP' or 'SV' : findpeak or smoothvel
% type :  data monocular or binocular 'mono' 'bino'
% defintion des fenêtres de temps pour la méthode de détection des blinks
% de l'eye link
% pretime_1 : temps avant la détection du blink en ms
% posttime_1 : temps après la détection du blink en ms
% defintion des fenêtres de temps pour la 2eme méthode de détection des blinks
% (soit Findpeaks soit smooth velocity)
% pretime_2 : temps avant la détection du blink en ms
% posttime_2 : temps après la détection du blink en ms


%outputs :
% si binoculaire, ordre des voies par ligne :
% {'EYE_TIMESTAMP','EYE_DIAMETER_L','DATA_intp_L','DATA_nan_L','blinks_L','EYE_DIAMETER_R','DATA_intp_R','DATA_nan_R','blinks_R'};
% si monoculaire, ordre des voies par ligne :
% {'EYE_TIMESTAMP','EYE_DIAMETER','DATA_intp','DATA_nan','blinks'};


% Monocular:
% <time> <xp> <yp> <ps>
% Binocular
%  <time> <xpl> <ypl> <psl> <xpr> <ypr> <psr>



% lecture du fichier ascii

[filepath,name,ext] = fileparts(filename_path);
filename = [name ext];
cd(filepath);

hdr = ft_read_header(filename);

if type == 'mono'
    CHOI = 4;
end

if type == 'bino'
    CHOI = [4 7]; % left = 4 , right = 7;
end


cfg            = [];
cfg.dataset    = filename;
cfg.continuous = 'yes';
cfg.channel    = 'all';
data           = ft_preprocessing(cfg);

mkdir(name)
cd(name)


intpdata =  data.trial{1}(CHOI(:),:);
intpdata2 =  data.trial{1}(CHOI(:),:);

nandata =  data.trial{1}(CHOI(:),:);

% blinks = zeros(length(CHOI),data.sampleinfo(2));
blinks_glob_sv = ones(length(CHOI),data.sampleinfo(2));
blinks_glob_fp = ones(length(CHOI),data.sampleinfo(2));


detect_signal = zeros(length(CHOI),data.sampleinfo(2));


for  i=1:length(CHOI)

    [blinks(i,:),intpdata(i,:)] = detect_blink_fromEL(data.trial{1}(CHOI(i),:),data.time{:},hdr,pretime_1,posttime_1,'detect_EL');


    %% recherche des blinks finaux détectés condition fp
    if method == 'FP'
        [blinks_fp,detect_fp] = detect_partial_blink_findpeak(intpdata(i,:),hdr,data.time{:},pretime_2,posttime_2,seuil,['fp_result' num2str(i)]);
        detect_signal(i,:) = detect_fp;
        blinks_glob_fp(i,:) = blinks(i,:).*blinks_fp;
        [ind_blink_def] = detect_sig2mat(blinks_glob_fp(i,:),0,0);     

        for e =1:size(ind_blink_def,1)  % boucle sur la liste des blinks trouvés
            idx_s =ind_blink_def(e,1); %indice start
            idx_e = ind_blink_def(e,2);  %indice end
            if idx_s<idx_e
                if  idx_e > data.sampleinfo(2)
                    idx_e = data.sampleinfo(2);
                end
                intpdata2(i,[idx_s:idx_e]) = interp1([idx_s idx_e],[intpdata2(i,idx_s) intpdata2(i,idx_e)],[idx_s:idx_e]); % remplacement du blink par le signal interpolé
                nandata(i,[idx_s:idx_e]) = nan(1,(idx_e - idx_s)+1); % remplacement du blink par des nan
                blinks_glob_fp(i,[idx_s:idx_e]) = zeros(1,(idx_e - idx_s)+1);
            end
        end
    end

    %% recherche des blinks finaux détectés condition sv
    if method == 'SV'
        [blinks_sv,detect_sv] = detect_partial_blink_smoothvel(intpdata(i,:),hdr,data.time{:},pretime_2,posttime_2,seuil,['sv_result' num2str(i)]);
         detect_signal(i,:) = detect_sv;
        blinks_glob_sv(i,:) = blinks(i,:).*blinks_sv;
        [ind_blink_def] = detect_sig2mat(blinks_glob_sv(i,:),0,0);

        for e =1:size(ind_blink_def,1) % boucle sur la liste des blinks trouvés
            idx_s =ind_blink_def(e,1); %indice start
            idx_e = ind_blink_def(e,2);  %indice end
            if idx_s<idx_e
                if  idx_e > data.sampleinfo(2)
                    idx_e = data.sampleinfo(2);
                end
                intpdata2(i,[idx_s:idx_e]) = interp1([idx_s idx_e],[intpdata2(i,idx_s) intpdata2(i,idx_e)],[idx_s:idx_e]); % remplacement du blink par le signal interpolé
                nandata(i,[idx_s:idx_e]) = nan(1,(idx_e - idx_s)+1); % remplacement du blink par des nan
                blinks_glob_sv(i,[idx_s:idx_e]) = zeros(1,(idx_e - idx_s)+1);
            end
        end
    end
end

%% output :


if method == 'FP'
    blink_final = blinks_glob_fp;
else
    blink_final = blinks_glob_sv;
end


if type == 'mono'
    %     v_label = {'EYE_TIMESTAMP','EYE_DIAMETER','DATA_intp','DATA_nan','blinks','detect_signal'}; %
    out_data = [data.trial{1,1}(1,:);data.trial{1,1}(CHOI(1),:);intpdata2;nandata;blink_final;detect_signal];
end

if type == 'bino'
    %     v_label = {'EYE_TIMESTAMP','EYE_DIAMETER_L','DATA_intp_L','DATA_nan_L','blinks_L','detect_signal','EYE_DIAMETER_R','DATA_intp_R','DATA_nan_R','blinks_R','detect_signal'};

    out_data = [data.trial{1,1}(1,:);data.trial{1,1}(CHOI(1),:);intpdata2(1,:);nandata(1,:);blink_final(1,:);detect_signal(1,:);data.trial{1,1}(CHOI(2),:);intpdata2(2,:);nandata(2,:);blink_final(2,:);detect_signal(2,:)];
end



