# pupil_preprocessing

out_data = blink_detection_pupil_size(filename_path, method,type,pretime_1,posttime_1,seuil_1,pretime_2,posttime_2,seuil_2)
- effectue la detection des blinks sur les signaux soit monoculaire, soit binoculaire.
-crée un dossier dans lequel est sauvegardé les figures des données interpolées et les données ELAN

détection des blinks étapes 1 : 
	detect_blink_fromEL.m
détection des blinks étapes 2 : 
	detect_partial_blink_findpeak.m
	detect_partial_blink_smoothvel.m

vecvel.m : calcul de la smooth velocity (Andreas)
preproc_asc2elan.m 
utilisation : preproc_asc2elan(filename,m_data,type)

% filename : aci file
% data matrice : output of blink_detection_pupil_size.m
% type == 'mono' ou 'bino'

eyelink_extract_event.m : fait l’extraction des évènements sur les données d’origine pour l’écriture du fichier ELAN. 
mat2eeg.m : function appelée par preproc_asc2elan.m pour écrire le fichier ELAN


main.m : exemple d’utilisation des fonctions
