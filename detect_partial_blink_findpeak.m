function  [blinks,detect] = detect_partial_blink_findpeak(data,hdr,time,pretime,posttime,seuil,figName)


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

% conversion des fenêtres temporelles en indices 
pre_time = round(pretime/1000*hdr.Fs); %nombre de point d'indices correspondant à 50 ms 
post_time = round(posttime/1000*hdr.Fs);


%filtrage du signal et recherche des pics
ps_filter = ft_preproc_bandpassfilter(data,hdr.Fs,[1 20],1,'but','twopass');
% [pks,loc] = findpeaks(-ps_filter,'MinPeakHeight',threshold_eyeblink_detect); 
detect=abs(ps_filter);
[pks,loc] = findpeaks(detect,'MinPeakHeight',seuil); %recherche des pics en valeur absolue

%% tableau des blinks (timetamps)
for i = 1:length(loc) 
    ind_start = loc(i) + pre_time;
    ind_end = loc(i) + post_time;
    blinks([ind_start:ind_end]) = zeros(1,ind_end-ind_start+1);
%     blinks(loc(i) ) = 0;
end


