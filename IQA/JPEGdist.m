function JPEGdist(DatabaseDir,OutputDir,quality)
%JPEGDIST Applies JPEG compression to a set of images.
% JPEGDIST(DATABASEDIR, OUTPUTDIR, QUALITY) applies JPEG compression to
% images in folder DATABASEDIR with a quality factor QUALITY between 0-100,
% and saves the compressed images in folder OUTPUTDIR, adding a prefix to
% the image name and the extension '.jpg'.
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
        imwrite(I,strcat(OutputDir,'/','JPG',num2str(quality),'_',name(1:end-5),'.jpg'),'Quality',quality);
    end
end
toc