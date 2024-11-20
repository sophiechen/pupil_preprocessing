# references
[1] Widmann A, Schröger E, Wetzel N. Emotion lies in the eye of the listener: Emotional arousal to novel sounds is reflected in the sympathetic contribution to the pupil dilation response and the P3. Biol Psychol. 2018 Mar;133:10-17. doi: 10.1016/j.biopsycho.2018.01.010. Epub 2018 Feb 4. PMID: 29378283.
[2] Mathôt S, Vilotijević A. Methods in cognitive pupillometry: Design, preprocessing, and statistical analysis. Behav Res Methods. 2023 Sep;55(6):3055-3077. doi: 10.3758/s13428-022-01957-7. Epub 2022 Aug 26. PMID: 36028608; PMCID: PMC10556184.


# pupil_preprocessing

out_data = blink_detection_pupil_size(filename_path, method,type,pretime_1,posttime_1,seuil_1,pretime_2,posttime_2,seuil_2)
- effectue la detection des blinks sur les signaux soit monoculaire, soit binoculaire.
- crée un dossier dans lequel sont sauvegardés les figures des données interpolées et les données ELAN

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
