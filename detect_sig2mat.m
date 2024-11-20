function [detect_mat] = detect_sig2mat(signal,pre_time,post_time)

% signal : valeur 0 = détection de blink / 1 = no blink par ex (dim : 1xN)
% detect_mat : matrice de deux colonnes avec indice de début et fin de
% détection
blink_mat = [];

    %recherche des segments où pupil size = 0
    ind_zeros_L=find(signal(:)==0); %recherche des indices valeurs égales à zéros
    if length(ind_zeros_L)>1
    seg_blink = diff(ind_zeros_L); %différence un à un des indices des valeurs égales à zero
    ind_blink = find(seg_blink>1);% indices des segments = 0
    
    %construction de la matrice des indices des blinks détectés
    ind_blink_corr=[ind_zeros_L(1) ind_zeros_L(ind_blink(1))]; % 1ere lignes
    vect = [];
    for b=1:length(ind_blink)-1
        vect = [vect ;ind_zeros_L(ind_blink(b)+1) ind_zeros_L(ind_blink(b+1))]; % lignes intermediaire
    end
    L= [ind_zeros_L(ind_blink(end)+1) ind_zeros_L(end)]; % dernière ligne
    blink_mat= [ind_blink_corr;vect;L];
    else
        blink_mat(1,:) = [ind_zeros_L ind_zeros_L];
    end


if isempty(blink_mat) == 0
    %correction des indices des blinks détectés avec les pretemps et post-temps
    blink_mat(:,1) = blink_mat(:,1)+pre_time;
    blink_mat(:,2) = blink_mat(:,2)+post_time;
    
    if blink_mat(1,1) <= 0
        blink_mat(1,:) = [];
    end

    if size(blink_mat,1)>1
        %fusion des créneaux de blink qui se superposent:
        for e =1:length(blink_mat)-1
            idx_1 =blink_mat(e,2); %indice fin ligne i
            idx_2 = blink_mat(e+1,1);  %indice début ligne i+1
            if idx_1>=idx_2
                blink_mat(e+1,1) = blink_mat(e,1);
                blink_mat(e,:) = [0 0];
            end
        end
        detect_mat = blink_mat;
    else
        detect_mat = blink_mat;
    end

end
