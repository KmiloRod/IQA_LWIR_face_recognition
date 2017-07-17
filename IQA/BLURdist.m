function BLURdist(DatabaseDir,OutputDir,sigma)
%BLURDIST Applies gaussian blur distortion to a set of images.
%
% BLURDIST(DATABASEDIR, OUTPUTDIR, SIGMA) applies blur distortion using a
% gaussian kernel to images in folder DATABASEDIR. SIGMA specifies the
% standard deviation of the kernel. The distorted images are saved in the
% folder OUTPUTDIR, adding a prefix to the image name.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
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
        I_Blur = imgaussfilt(I,sigma);
        imwrite(I_Blur,strcat(OutputDir,'/','BLUR',num2str(sigma),'_',name));
    end
end
toc