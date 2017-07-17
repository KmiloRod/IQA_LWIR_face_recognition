%PUJ_DATABASETSSAVE saves the Thermal Signature Templates (TST) of the
% subjects of the database PUJ-T360 included in the folder
% 'GalleryPristine'. The TST are saved as MAT files in the folder
% 'Signatures'.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

tic

Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
    'S11';'S12';'S13';'S14';'S15';'S16';'S17';'S18';'S19';'S20';'S28';'S29';...
    'S30';'S32';'S33'};   % PUJ T360 Database

for i = 1:length(Subjects)
    TSsaveSubject('newGallery',Subjects{i},'PUJ',1,0);
end
toc