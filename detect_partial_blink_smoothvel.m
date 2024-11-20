function  [blinks,detect] = detect_partial_blink_smoothvel(data,hdr,time,pretime,posttime,seuil,figName)


% blink détection on ascii files from eyelink
%inputs:
% data : données channel x time
% hdr: header file info
% method : 'peaks_detect' or 'smooth_vel'
% type :  data monocular or binocular 'mono' 'bino'
% pretime : temps avant la détection du blink (en ms) valeur negative
% posttime : temps après la détection du blink (en ms) 
% seuil : seuil de détection 

%outputs :
% nandata : données non interpolé avec NaN lorqu'il y a des blinks
% blinks : blink détectés : 0 = blink / 1 = no blink
% intpdata : données interpolées
% detect : données utilisées pour la détection 

%initialisation des variables
blinks = ones(1,length(data));
detect = data;

% conversion des fenêtres temporelles en indices 
pre_time = round(pretime/1000*hdr.Fs); %nombre de point d'indices correspondant à 50 ms 
post_time = round(posttime/1000*hdr.Fs);

% filtrage et détection de pics non détectés par l'eye-tracker (methode Andreas)

detect = vecvel(data',hdr.Fs,2)'; % smooth velocity appliqué au signal interpolé

%détection des blinks , mise à zéros des valeurs si >seuil
for i=1:length(detect)
    if (abs(detect(i))>seuil)
        ind_s = i+pre_time;
        ind_e = i+post_time;
        if ind_s<0
            ind_s = 1;
        end
        if ind_e>length(detect)
            ind_e = length(detect)
        end        
        blinks([ind_s:ind_e]) = zeros(1,(ind_e - ind_s)+1); % voie avec 0 si blink et 1 no blink
    end
end

% for i=1:length(detect)
%     if (abs(detect(i))>= seuil)
%         blinks(i) = 0; % voie avec 0 si blink et 1 no blink
%     end
% end



