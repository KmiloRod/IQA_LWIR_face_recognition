function [ThermalSignatureOutput] = SignatureExtraction(DirName,SubjectName,Database,mode,disp_option)
%SIGNATUREEXTRACTION Extract thermal signature template of thermal face 
% images of a subject in a given directory.
% [ThermalSignature] = SIGNATUREEXTRACTION(DirName, SubjectName, Database,
% mode, disp_option)
% Scan all images in directory DirName, extract vascular network from
% images which name contains the string SubjectName, sum the vascular
% networks and apply anisotropic diffusion to the sum. If the 'mode'
% parameter is set to 0, the function returns ThermalSignature as the
% diffused thermal signature; otherwise, it returns the skeletonized
% version of the diffused thermal signature. Argument 'Database' is a
% string specifying which database are the images from: 'IRIS', 'UND'
% or 'PUJ'.
% If 'disp_option' is 1, the function shows the stages of the thermal
% signature extraction in a windows.
% The function returns a binary image in ThermalSignature with the
% skeletonized combined thermal signature of all the images from the
% subject.
%
% (c) 2016, 2017 Camilo Rodr?guez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

DirInfo = dir(DirName);
n = size(DirInfo,1);
cd (DirName);

if strcmp(Database,'UND')
    ThermalSignature = zeros(239,310);
elseif (strcmp(Database, 'PUJ') || strcmp(Database,'FONE'))
    ThermalSignature = zeros(240,206);
end

for i = 3:n
    name = DirInfo(i).name;
    if (~isempty(strfind(name, SubjectName)))
        VascImage = vascularExt(name,0,Database);
        ThermalSignature = ThermalSignature + VascImage;
    end
end

ThermalSignatureDiff = anisodiff8(ThermalSignature,10,20,0.1,1);

if strcmp(Database, 'UND')
    level = 0.35;
elseif strcmp(Database, 'PUJ')
    level = 0.4;
elseif strcmp(Database, 'FONE')
    level = 0.35;
end

ThermalSignatureDiffBW = imbinarize(ThermalSignatureDiff,level);

ThermalSignatureSkel = bwmorph(ThermalSignatureDiffBW,'thin',Inf);

if mode==0  % anisotropic
    ThermalSignatureOutput = ThermalSignatureDiffBW;
elseif mode == 1  % Skeletonized
    ThermalSignatureOutput = ThermalSignatureSkel;
end

if disp_option
    figure;
    subplot(2,2,1); imagesc(ThermalSignature); title('Addition of vascular networks');
    subplot(2,2,2); imagesc(ThermalSignatureDiff); title('Anisotropic Diffusion applied');
    subplot(2,2,3); imagesc(ThermalSignatureDiffBW); title('Diffused thermal signature');
    subplot(2,2,4); imagesc(ThermalSignatureSkel); title('Skeletonized thermal signature');
end

cd ..;