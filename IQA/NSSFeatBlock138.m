function [featMat] = NSSFeatBlock138(block,patchsize,r_gam,nr_gam)
% NSSFEATBLOCK138 generates a matrix of 138 NSS features from an image
% patch of size PATCHSIZE. The patch itself is contained in BLOCK. R_GAM
% and NR_GAM are vectors with the estimation of the generalized gaussian
% ratio functions.
%
% The output FEATMAT is a 1 x 138 vector.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

xmin = 1; xmax = 1 + patchsize - 1;
ymin = 1; ymax = 1 + patchsize - 1;
im_scale2 = imresize(block(ymin:ymax,xmin:xmax),0.5);
im_scale3 = imresize(im_scale2,0.5);

if sum(sum(block))==0
    featMat = NaN(1,138);
    return
end

nssfeat = [computeGoodallFeatures(block(ymin:ymax,xmin:xmax),r_gam,nr_gam);...
            computeGoodallFeatures(im_scale2,r_gam,nr_gam);...
            computeGoodallFeatures(im_scale3,r_gam,nr_gam)];
featMat(1,:)  =  nssfeat';