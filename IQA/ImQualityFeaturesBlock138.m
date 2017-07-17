function [NSSfeatures] = ImQualityFeaturesBlock138(image, patchsize, ts_pos)
% IMQUALITYFEATURESBLOCK138 generates a matrix of 138 NSS features from a
% thermal IMAGE, from square blocks of size PATCHSIZE. TS_POS is a cell
% matrix contatining the bounding boxes of the thermal signatures of the
% pristine images, the image names and the thermal signatures as vectors.
%
% The output NSSFEATURES is a N x 138 matrix, where N is the number of
% patches extracted from the image.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

r_min = ts_pos(1); r_max = ts_pos(2);
c_min = ts_pos(3); c_max = ts_pos(4);

im = image(r_min:r_max, c_min:c_max);

% Image padding
[ma,na] = size(im);
mpad = rem(ma, patchsize); if mpad>0, mpad = patchsize - mpad; end
npad = rem(na, patchsize); if npad>0, npad = patchsize - npad; end
if (isa(im, 'uint8'))
    aa = repmat(uint8(0), ma + mpad, na + npad);
elseif isa(im, 'uint16')
    aa = repmat(uint16(0), ma + mpad, na + npad);
else
    aa = zeros(ma + mpad, na + npad);
end
start_row = fix(mpad/2);
start_column = fix(npad/2);
aa(start_row + 1:ma + start_row, start_column + 1:na + start_column) = im;

% Generalized gaussian ratio function
gam = 0.2:0.001:10;
r_gam = ((gamma(2./gam)).^2)./(gamma(1./gam).*gamma(3./gam));
nr_gam = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);

Features = @(block) NSSFeatBlock138(block, patchsize, r_gam, nr_gam);

NSSfeatures = blkproc(aa, [patchsize patchsize], Features);
%NSSfeatures = blockproc(aa, [patchsize patchsize], Features);

NSSfeatures = reshape(NSSfeatures', [138, numel(NSSfeatures)/138])';

% Remove blocks which have all their NSS features as NaN
NSSfeatures(sum(isnan(NSSfeatures), 2)==size(NSSfeatures, 2), :) = [];

% Remove isolated NaN values of NSS features
NSSfeatures(isnan(NSSfeatures)) = 0;
