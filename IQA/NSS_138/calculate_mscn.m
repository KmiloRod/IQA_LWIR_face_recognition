% MSCN = calculate_mscn(IM)
% calculates the mean substracted contrast normalized coefficients (MSCN)
% of image IM
function mscn = calculate_mscn(im)
 if size(im,3) == 3
 im = rgb2gray(im);
 end
 im = im2double(im);
 window        = fspecial('gaussian',7,7/6);
 window        = window/sum(sum(window));
 mu            = imfilter(im,window,'replicate');
 mu_sq         = mu.*mu;
 sigma         = sqrt(abs(imfilter(im.*im,window,'replicate') - mu_sq));
 mscn          = (im-mu)./(sigma+1); %1/255
 end