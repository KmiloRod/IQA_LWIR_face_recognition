function [feat] = NSSfeat(Image,patches,patchsize)

%im_orig          = imread(ImageName);
im               = mat2gray(double(Image));

[row,col]        = size(im);

block_rownum     = floor(row/patchsize);
block_colnum     = floor(col/patchsize);

im               = im(1:block_rownum*patchsize,1:block_colnum*patchsize);              
[row,col]        = size(im);
block_rownum     = floor(row/patchsize);
block_colnum     = floor(col/patchsize);

im               = im(1:block_rownum*patchsize, ...
                   1:block_colnum*patchsize);

%patches = PatchExt(im_orig,Database,patchsize,display_option);
%feat = hogFeat(im,patches,1,patchsize);
gam   = 0.2:0.001:10;
% Generalized gaussian ratio function
r_gam = ((gamma(2 ./ gam)) .^ 2)./(gamma(1 ./ gam) .* gamma(3 ./ gam));

feat = hogFeatBlock(im,patchsize,r_gam);
