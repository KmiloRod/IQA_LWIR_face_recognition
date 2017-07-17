function [ImageTopBW2] = vascularExtParVar(Image,disp_option,params)
%VASCULAREXTPARVAR Extract thermal signature from a segmented infrared face
% image
% [VascImage] = VASCULAREXTPARVAR(IMAGENAME, DISP_OPTION, PARAMS) receives
% as input a segmented facial IR image matrix in IMAGENAME, and extract the
% thermal signature using anisotropic diffusion and morphological functions
% using the values in the 1x2 vector PARAMS for the parameters kappa and
% rho. If DISP_OPTION == 1, a figure is shown with the steps of the TS
% generation.
% Returns a binary image in IMAGETOPBW2 with the skeletonized thermal
% signature.
%
% (c) 2015 - 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

kappa = params(1);
se = strel('diamond', params(2));

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
    subplot(2,3,4); imagesc(ImageTopBW1); title('Substracted and denoised Image');
    subplot(2,3,5); imagesc(ImageTopBW2); title('White Top Hat segmented');
    if isa(Image,'uint8')
        subplot(2,3,6); imagesc(Image.*uint8(~(ImageTopBW2))); title('Superposed Image');
    else
        subplot(2,3,6); imagesc(Image.*uint16(~(ImageTopBW2))); title('Superposed Image');
    end
end