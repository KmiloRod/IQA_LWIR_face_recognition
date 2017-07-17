%SEGMENTOTSU Segment face from an infrared image
% [IFN] = SEGMENTOTSU(IC,LEVEL,DISP_OPTION) receives a facial LWIR image IC
% and segment the face using Otsu thresholding method and morphological
% closing and opening functions. The method uses the value in LEVEL to
% binarize the image; if the value of LEVEL is zero, the function
% automatically calculates the threshold level using the GRAYTHRESH
% function. If DISP_OPTION is 1, the results of each segmentation stage are
% shown in a figure.
% Returns an image in IFN with the face segmented.
%
% (c) 2015 - 2017 Camilo Rodríguez
%=========================================================================

function [Ifn] = segmentOtsu(Ic,level,disp_option)
close all;
scrsz = get(groot,'ScreenSize');

if size(Ic,3)==3
    Ic = rgb2gray(Ic);
end

% Calculate the global threshold using Otsu method and uses it to generate
% a binary image (Is) by thresholding
if ~level
    level = graythresh(Ic)
end
Is = imbinarize(Ic,level);

% Crop the bottom 13% of image to remove shoulders information
cut_height = round(0.87*size(Is,1));
fe = Is(1:cut_height,:);

% Fill with zeros the cropped image´s bottom lines to match original size
fe = logical([fe; zeros(size(Is,1)-cut_height, size(Is,2))]);

% Apply morphological closing and opening using a circle structural element
% with area equal to 10% of the estimated face elipse area
area = bwarea(fe);
R = sqrt((0.04*area)/pi);
se = strel('disk',round(R));
Ifn = imclose(fe,se);
Ifn = imopen(Ifn,se);

if disp_option
    if isa(Ic,'uint8')
        Isup = Ic.*uint8(Ifn);
    elseif isa(Ic,'uint16')
        Isup = Ic.*uint16(Ifn);
    end

    % Display original image, raw segmentation, estimated face elipse,
    % morphological processing results and segmented image
    figure('Position',[scrsz(3)/2 1 scrsz(3)/2 scrsz(4)-100])
    subplot(3,2,[1,2]), imshow(Ic), title('Original image');
    subplot(3,2,3), imshow(Is), title('Initial threshold segmentation');
    subplot(3,2,4), imshow(fe), title('Face elipse estimation');
    subplot(3,2,5), imshow(Ifn), title('Morphological processing');
    subplot(3,2,6), imshow(Isup), title('Superposition');
end