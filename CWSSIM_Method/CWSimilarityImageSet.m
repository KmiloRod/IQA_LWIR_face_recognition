%CWSIMILARITYIMAGESET Calculates similarity measures between a thermal
% face image and all the thermal images from an image set, using the
% CW-SSIM similarity index.
%
% [CWMEASURES] = CWSIMILARITYIMAGESET(IMAGENAME, IMAGESET)
% computes the CW-SSIM index from the matching  of the thermal face image
% IMAGENAME with all the thermal images in the set IMAGESET, which is a
% cell array containing the names strings of the images belonging to the
% set.
% The function returns a vector of similarity measures with length equal
% to the number of thermal images in the set.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
function [CWMeasures] = CWSimilarityImageSet(ImageName,ImageSet)

CWMeasures = zeros(1,size(ImageSet,2));

ImageTest = imread(ImageName);

k = 1;

for i=1:size(ImageSet, 2)
    name = ImageSet{i};
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        ImageGallery = imread(name);
        CWMeasures(k) = cwssim_index(ImageTest,ImageGallery,5,16,0,0);
        k = k + 1;
    else
        CWMeasures(k) = [];
    end
    %waitbar((i-2)/n,wait_h);
end
%close(wait_h)