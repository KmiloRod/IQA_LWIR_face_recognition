%FONE_DATABASETSSAVE saves the Thermal Signature Templates (TST) of the
% subjects of the database UND included in the folder
% 'GalleryPristine'. The TST are saved as MAT files in the folder
% 'Signatures'.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

tic

Subjects = {'02463';'04200';'04202';'04203';'04204';'04206';'04207';...
    '04209';'04210';'04211';'04212';'04213';'04215';'04216';'04218';...
    '04219';'04220';'04222';'04226';'04228';'04230';'04234';'04235';...
    '04236';'04239';'04241';'04244';'04249';'04250';'04251';'04253';...
    '04254';'04255';'04257';'04260';'04262';'04263';'04266';'04270';...
    '04273';'04275'}; % UND Database (41 subjects)

for i = 1:length(Subjects)
    TSsaveSubject('GalleryPristine',Subjects{i},'UND',1,0);
end
toc