%THERMALREGISTRATION Register two thermal face images using intensity-based
% automatic methods.
% [RegisteredImage] = THERMALREGISTRATION(Image1name, Image2name, 
% disp_option)
% Register two thermal face images acquired with the same detector, using
% MATLAB function imregister with similarity mode (translation, rotation,
% scale). Image1name is the reference image file name and Image2name is
% the image to be registered. If disp_option is set to 1, the before and
% after registration images are shown.
% The function returns in RegisteredImage the modified image Image2name
% registered to image Image1name.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function [RegisteredImage] = ThermalRegistration(Image1name,Image2name,disp_option)
close all;
Image1 = imread(Image1name);
Image2 = imread(Image2name);

% Only for IRIS database cropped images
%Image1([206:end],:) = [];  
%Image2([206:end],:) = [];
if disp_option
    figure
    imshowpair(Image1,Image2,'falsecolor');
end
[optimizer,metric] = imregconfig('monomodal');

optimizer.MaximumIterations = 500;
optimizer.MaximumStepLength = 0.014;
optimizer.MinimumStepLength = 5e-4;

RegisteredImage = imregister(Image2,Image1,'similarity',optimizer,metric);
if disp_option
    figure
    imshowpair(RegisteredImage,Image1);
end

%cd 'Registered';
%imwrite(RegisteredImage,strcat(Image2name(1:end-5),'reg.tiff'));
%cd ..;


