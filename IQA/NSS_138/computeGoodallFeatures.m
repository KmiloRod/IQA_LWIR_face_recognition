function feat = computeGoodallFeatures(im,r_gam,nr_gam,group)

% Input  - input image coefficients
% Output - Compute the 46 dimensional feature vector 

if nargin == 3
    group = 'f+pp+pd+sp';
end

if(size(im,3)~=1)
    im = rgb2gray(im);
end
im = im2double(im);
im = (im - min(im(:)));
im = im/max(im(:));

feat = [];
structdis = calculate_mscn(im);
vec = structdis(:);

%gam = 0.2:0.001:10;
%r_gam = ((gamma(2./gam)).^2)./(gamma(1./gam).*gamma(3./gam));
%nr_gam = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);

%f1 shape, f2 standard deviation,
[f1, f2] = estimateGGDParamGoodall(vec,nr_gam);

[leftshape, leftstd] = estimateGGDParamGoodall(vec(vec<0),nr_gam);
[rightshape, rightstd] = estimateGGDParamGoodall(vec(vec>0),nr_gam);
%f3 shape difference
f3 = rightshape - leftshape;
%f4 standard deviation difference
f4 = rightstd - leftstd;

if strfind(group,'f')>0
    feat = [feat; f1; f2; f3; f4];
end

shifts = [0 1; 1 0; 1 1; 1 -1];

if strfind(group,'pp')>0
    for itr_shift = 1:4
        % circular shift coefficients to calculate pair products
        shifted_structdis = circshift(structdis,shifts(itr_shift,:));
        % calculate pair products
        pair = structdis(:).*shifted_structdis(:);
        % calculate pair product features: 
        % pp1 shape, pp2 mean of distribution, pp3 leftstd, pp4 rightstd, 
        [pp1, pp2, ~, ~, pp3, pp4] = estimateAGGDParamGoodall(pair,r_gam);
        feat = [feat;pp1;pp2;pp3;pp4];
    end
end

if strfind(group,'pd')>0
    % calculate log coefficients
    logderdis = log(abs(structdis) + 0.1);
    
    for itr_shift = 1:4
        % circular shift to log coefficients to calculate first 4 log
        % derivative coefficients
        shifted_logderdis = circshift(logderdis,shifts(itr_shift,:));
        % calculate log derivative coefficients
        pair = shifted_logderdis(:) - logderdis(:);
        % calculate log der features
        %pd1 shape, pd2 standard deviation
        [pd1, pd2] = estimateGGDParamGoodall(pair,nr_gam);
        feat = [feat;pd1;pd2];
    end
    
    shift1 = [-1 0; 0 0; -1 -1];
    shift2 = [1 0; 1 1; 1 1];
    shift3 = [0 -1; 0 1; -1 1];
    shift4 = [0 1; 1 0; 1 -1];
    for itr_shift = 1:3
        % circular shift to log coefficients to calculate last 3 log
        % derivative coefficients
        shifted_logderdis1 = circshift(logderdis,shift1(itr_shift,:));
        shifted_logderdis2 = circshift(logderdis,shift2(itr_shift,:));
        shifted_logderdis3 = circshift(logderdis,shift3(itr_shift,:));
        shifted_logderdis4 = circshift(logderdis,shift4(itr_shift,:));
        % calculate log derivative coefficients
        pair = shifted_logderdis1(:) + shifted_logderdis2(:)...
            -shifted_logderdis3(:) -shifted_logderdis4(:);
        %pd1 shape, pd2 standard deviation
        [pd1, pd2] = estimateGGDParamGoodall(pair,nr_gam);
        feat = [feat;pd1;pd2];
    end
end

if strfind(group,'sp')>0
    %parameters of steerable pyramid features
    num_or = 6;
    num_scales = 1;
    %calculate seerable pyramid subbands
    [pyr, pind] = buildSFpyr(im,num_scales,num_or-1);
        
    [subband, ~] = norm_sender_normalized(pyr,pind,num_scales,num_or,1,1,3,3,50);
    
    for itr_shift = 1:num_or*num_scales
        %sp1 shape, sp2 standard deviation
        [sp1, sp2] = estimateGGDParamGoodall(subband{itr_shift},nr_gam);
        feat = [feat;sp1;sp2];
    end
end
    