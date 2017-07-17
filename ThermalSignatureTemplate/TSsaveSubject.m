%TSSAVESUBJECT Extract thermal signatures templates from segmented infrared
% face images of a subject
% TSSAVESUBJECT(DirName, SubjectName, disp_option) extract the Thermal
% Signature Template from all images with SubjectName within the name file
% in directory DirName and saves them in a .mat file.
%
% (c) 2015 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function TSsaveSubject(DirName,SubjectName,Database,mode,disp_option)

ThermalSignature = SignatureExtraction(DirName,SubjectName,Database,mode,disp_option);

olddir = cd('../Signatures');

%csvwrite(strcat(SubjectName,'.dat'), TMPFeatures);
if mode == 0
    cd('aniso')
    save(strcat(SubjectName,'_ad.mat'), 'ThermalSignature');
    cd ..
elseif mode == 1
    cd('skel')
    save(strcat(SubjectName,'_skel.mat'), 'ThermalSignature');
    cd ..
end

cd(olddir)
