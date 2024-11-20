function [blinks,intpdata] = detect_blink_fromEL(data,time,hdr,time_ms_blink_s,time_ms_blink_e,figName)

% Détection des blinks tel détectés par l'eye tracker 
% blink détection on ascii files from eyelink
%inputs:
% data : 1 channel x time (1xN)
% time : 1 channel x time (1xN) - vecteur de temps
% hdr: header file info
% method : 'peaks_detect' or 'smooth_vel'
% type :  data monocular or binocular 'mono' 'bino'
% time_ms_blink_s : temps avant la détection du blink (enter a negative 
% value) en ms
% time_ms_blink_e : temps après la détection du blink en ms
% figName : nom de la figure à sauvegarder

%outputs :
% nandata : données non interpolé avec NaN lorqu'il y a des blinks
% blinks : blink détectés : 0 = blink / 1 = no blink
% intpdata : données interpolées


%initialisation des variables
intpdata = data;
blinks = ones(length(data),1);
% conversion des fenêtres temporelles en indices 
pre_time = round(time_ms_blink_s/1000*hdr.Fs); %nombre de point d'indices correspondant à 50 ms 
post_time = round(time_ms_blink_e/1000*hdr.Fs);


[blink_mat] = detect_sig2mat(data,pre_time,post_time);
 
% %correction des indices des blinks détectés avec les pretemps et post-temps
% blink_mat(:,1) = blink_mat(:,1)+pre_time;
% blink_mat(:,2) = blink_mat(:,2)+post_time;
% 
% 
% %fusion des créneaux de blink qui se superposent: 
% for e =1:length(blink_mat)-1
%     idx_1 =blink_mat(e,2); %indice fin ligne i 
%     idx_2 = blink_mat(e+1,1);  %indice début ligne i+1
%     if idx_1>=idx_2        
%         blink_mat(e+1,1) = blink_mat(e,1);
%         blink_mat(e,:) = [0 0];
%     end
% end

%création de la voie blinks et du signal interpolé
for e =1:length(blink_mat) % boucle sur la liste des blinks trouvés
    idx_s =blink_mat(e,1); %indice start
    idx_e = blink_mat(e,2);  %indice end
    if idx_s<idx_e 
        if  idx_e > length(data)
            idx_e = length(data);
        end
        blinks([idx_s:idx_e]) = zeros(1,(idx_e - idx_s)+1); % voie avec 0 si blink et 1 no blink   
        intpdata([idx_s:idx_e]) = interp1([idx_s idx_e],[intpdata(idx_s) intpdata(idx_e)],[idx_s:idx_e]); % remplacement du blink par le signal interpolé
    end
end

% time = (time-time(1))/1000;
% %sauvegrade de la figure
% fig =  figure('Position', get(0, 'Screensize'));
% plot(time,data(:)-mean(data(:)),'b');
% hold on
% plot(time,blinks(:)*mean(data(:))-mean(data(:)),'r');
% hold on
% plot(time,intpdata(:)-mean(intpdata(:)),'k');
% legend('pupilData','blinks','intpData')
% saveas(fig,figName,'png')
% saveas(fig,figName)
% close
% 


