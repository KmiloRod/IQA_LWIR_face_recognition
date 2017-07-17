function [ImageTopBW2] = vascularExtPar(ImageName,disp_option,Database,param,parValue)
%VASCULAREXTPAR Extract thermal signature from a segmented infrared face
% image
% [VascImage] = VASCULAREXTPAR(IMAGENAME, DISP_OPTION, DATABASE, PARAM,
% PARVALUE) receives as input a segmented facial IR image IMAGENAME from
% DATABASE, and extract the thermal signature using anisotropic diffusion
% and morphological functions using the value PARVALUE for the parameter
% PARAM. If DISP_OPTION == 1, a figure is shown with the steps of the TS
% generation.
% Returns a binary image in IMAGETOPBW2 with the skeletonized thermal
% signature.
%
% DATABASE = String belonging to {UND, PUJ, FONE}
% PARAM = String belonging to {kappa, se_size, both}
%
% (c) 2015 - 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

Image = imread(ImageName);

if strcmp(param, 'se_size')
    se = strel('diamond', parValue);
    kappa = 20;
elseif strcmp(param, 'kappa')
    if strcmp(Database,'IRIS')      % Structural element for vascular networks extraction
        se = strel('diamond', 15);   % diamond with radius 15 for IRIS database
    elseif strcmp(Database, 'UND')  
        se = strel('diamond', 7);    % diamond with radius 7 for UND database
    elseif strcmp(Database, 'PUJ')
        se = strel('diamond', 10);
    elseif strcmp(Database, 'FONE')    
        se = strel('diamond',5);        
    end
    kappa = parValue;
elseif strcmp(param,'both')
    kappa = parValue(1);
    se = strel('diamond', parValue(2));
end

% Anisotropic diffussion using standard method iter = 20, k = 20
ImageDiffused = anisodiff8(Image,10,kappa,0.25,1);

ImageOpened = imopen(ImageDiffused,se); % Morphological opening of diffused image
ImageTop = double(Image) - ImageOpened; % Subtraction of opened diffused image from original image
ImageTop = ImageTop.*~(~uint16(ImageOpened)); % Definition of ROI

level = graythresh(ImageTop);  % Thresholding level calculation using Otsu's method
ImageTopBW = im2bw(ImageTop,level); % Image thresholding using level calculated

se2 = strel('disk', 2); % Structural element for noise reduction and vascular networks enhacement
ImageTopBW1 = imerode(ImageTopBW,se2); % Image erotion for noise reduction
ImageTopBW2 = bwmorph(ImageTopBW1,'thin',Inf); % Image thinning for skeletonization of vascular networks

if disp_option
    scrsz = get(groot,'ScreenSize');
    figure('OuterPosition',[10 50 1300 800]);
    colormap('default');
    subplot(2,3,1); imagesc(Image); title('Original Image');
    subplot(2,3,2); imagesc(uint16(ImageDiffused)); title('Diffused Image');
    subplot(2,3,3); imagesc(uint16(ImageOpened)); title('Opened Image');
    %subplot(2,3,4); imagesc(uint16(imadjust(ImageTop))); title('Substracted Image');
    subplot(2,3,4); imagesc(ImageTopBW1); title('Substracted and denoised Image');
    subplot(2,3,5); imagesc(ImageTopBW2); title('White Top Hat segmented');
    if isa(Image,'uint8')
        subplot(2,3,6); imagesc(Image.*uint8(~(ImageTopBW2))); title('Superposed Image');
    else
        subplot(2,3,6); imagesc(Image.*uint16(~(ImageTopBW2))); title('Superposed Image');
    end
end