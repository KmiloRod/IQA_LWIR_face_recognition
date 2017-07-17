%CWSIMILARITYDATABASE Calculates similarity measures between a thermal
% face image and all the thermal images from a database, using the CW-SSIM
% similarity index.
% [CWMEASURES] = THERMALSIMILARITYDATABASECLASS(IMAGENAME, DIRNAME)
% computes the CW-SSIM indexes from the matching of the thermal face image
% IMAGENAME with all the thermal images in the directory DIRNAME.
% The function returns a vector of similiarity measures with length equal
% to the number of thermal images in the directory.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function [CWMeasures] = CWSimilarityDatabase(ImageName,DirName,Database,mode)

if strcmp(mode,'TS')
    ImageTest = vascularExt(ImageName,0,Database);
else
    ImageTest = imread(ImageName);
end

DirInfo = dir(DirName);
olddir = cd (DirName);

n = size(DirInfo,1);

CWMeasures = zeros(1,n-2);

k = 1;

for i=3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        if strcmp(mode,'TS')
            ImageGallery = vascularExt(name,0,Database);
        else
            ImageGallery = imread(name);
        end
        CWMeasures(k) = cwssim_index(ImageTest,ImageGallery,3,16,0,0);
        k = k + 1;
    else
        CWMeasures(k) = [];
    end
end
cd(olddir)