%MANUALFEATUREREGISTRATION Manual registration of two images.
% [registered] = MANUALFEATUREREGISTRATION(fixedName, unregisteredName,
% file_write, display_option)
%
% Allows to register two images using manually selected matching feature
% points from two images. 'fixedName' is the file name of the reference
% image. 'unregisteredName' is the file name of the image to be registered.
% If 'fileWrite' is 1, the registered image is saved in a new file with the
% suffix 'reg'. If 'display_option' is 1, a before-and-after display of the
% two images is shown. The registered image is saved in the 'Registered1'
% folder.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%==========================================================================

function [registered] = ManualFeatureRegistration(fixedName, unregisteredName, file_write, display_option)

if file_write
    if exist(strcat('./Registered1/',unregisteredName(1:end-5),'reg.tiff'),'file')
        return
    end
end

unregistered = imread(unregisteredName);
fixed = imread(fixedName);

[movingPoints, fixedPoints] = cpselect(unregistered, fixed, 'Wait', true);

RefObject = imref2d(size(fixed));

myTransform = fitgeotrans(movingPoints, fixedPoints, 'similarity');
registered = imwarp(unregistered, myTransform, 'OutputView', RefObject,'Interp','nearest');

if display_option
    subplot(2,2,1)
    imshow(fixed);
    subplot(2,2,2)
    imshow(registered);
    subplot(2,2,3:4);
    imshowpair(fixed, registered, 'falsecolor');
end

if file_write
    %cd 'Registered1';
    imwrite(registered,strcat('./Registered1/',unregisteredName(1:end-5),'reg.tiff'));
    %cd ..;
end