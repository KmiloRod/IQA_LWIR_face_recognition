%VASCULAREXT Extract the thermal signature from a segmented LWIR face image
% [VascImage] = VASCULAREXT(ImageName, disp_option, Database) receives a
% segmented thermal facial image ImageName from Database, and extract the
% thermal signature or vascular network using anisotropic diffusion and
% morphological functions. Returns a binary image in VascImage with the
% skeletonized vascular network. If disp_option is set to to a value
% different than 0, it shows a figure with the steps of the process.
%
% Database = String belonging to {UND, PUJ, FONE}
%
% (c) 2015 - 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%===============================================vasc==========================

function [ImageTopBW2] = vascularExt(ImageName,disp_option,Database)

Image = imread(ImageName);

% Anisotropic diffussion using standard method iter = 10, k = 20
ImageDiffused = anisodiff8(Image,10,20,0.25,1); % Paper version

if strcmp(Database,'IRIS')      % Structural element for vascular networks extraction
    se = strel('diamond',15);   % diamond with radius 15 for IRIS database
elseif strcmp(Database, 'UND')  
    se = strel('diamond',7);    % diamond with radius 7 for UND database
elseif strcmp(Database, 'PUJ')
    se = strel('diamond',11);
elseif strcmp(Database, 'FONE')    
    se = strel('diamond',5);
end

ImageOpened = imopen(ImageDiffused,se); % Morphological opening of diffused image
ImageTop = double(Image) - ImageOpened; % Subtraction of opened diffused image from original image
ImageTop = ImageTop.*~(~uint16(ImageOpened)); % Definition of ROI

level = graythresh(ImageTop);  % Thresholding level calculation using Otsu's method
ImageTopBW = im2bw(ImageTop,level); % Image thresholding using level calculated

se2 = strel('disk', 2); % Structural element for noise reduction and vascular networks enhacement
ImageTopBW1 = imerode(ImageTopBW,se2); % Image erotion for noise reduction
ImageTopBW2 = bwmorph(ImageTopBW1,'thin',Inf); % Image thinning for skeletonization of vascular networks

if disp_option
    figure;
    colormap('default');
    subplot(2,3,1); imagesc(Image); title('Original Image');
    subplot(2,3,2); imagesc(uint16(ImageDiffused)); title('Diffused Image');
    subplot(2,3,3); imagesc(uint16(ImageOpened)); title('Opened Image');
    subplot(2,3,4); imagesc(ImageTopBW1); title('Subtracted and denoised Image');
    subplot(2,3,5); imagesc(ImageTopBW2); title('White Top Hat segmented');
    if isa(Image,'uint8')
        subplot(2,3,6); imagesc(Image.*uint8(~(ImageTopBW2))); title('Superposed Image');
    else
        subplot(2,3,6); imagesc(Image.*uint16(~(ImageTopBW2))); title('Superposed Image');
    end
end