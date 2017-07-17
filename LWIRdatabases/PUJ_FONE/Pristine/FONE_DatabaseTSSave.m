%FONE_DATABASETSSAVE saves the Thermal Signature Templates (TST) of the
% subjects of the database PUJ-FONE included in the folder
% 'GalleryPristine'. The TST are saved as MAT files in the folder
% 'Signatures'.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

tic

Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
    'S12';'S14';'S16';'S18';'S20';'S22';'S24';'S26';'S28';'S29';'S31';...
    'S33';'S35';'S37';'S39'};   % PUJ F-ONE Database

for i = 1:length(Subjects)
    TSsaveSubject('GalleryPristine',Subjects{i},'FONE',1,0);
end
toc