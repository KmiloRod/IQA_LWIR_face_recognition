function AWNdist(DatabaseDir,OutputDir,sigma,index)
%AWNDIST Applies Additive White Gaussian Noise to a set of images.
%
% AWNDIST(DATABASEDIR, OUTPUTDIR, SIGMA, INDEX) applies AWGN noise to
% images in folder DATABASEDIR with mean 0 and variance SIGMA,
% and saves the compressed images in folder OUTPUTDIR, adding a prefix to
% the image name. INDEX is a natural number used to label the output
% images, indicating the level of distortion applied.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
tic

DirInfo = dir(DatabaseDir);
n = size(DirInfo,1);

if exist(OutputDir,'dir')~=7
    mkdir(OutputDir)
end

for i = 3:n
    name = DirInfo(i).name;
    if (strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp'))
        I = im2double(imread(name));
        I_AWN = imnoise(I,'gaussian',0,sigma);
        imwrite(I_AWN,strcat(OutputDir,'/','AWN',num2str(index),'_',name));
    end
end
toc