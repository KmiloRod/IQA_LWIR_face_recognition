function SegmentDatabase(directory,level)
%SEGMENTDATABASE segments face from background in all the LWIR facial
% images in DIRECTORY, using a predefinied LEVEL for umbralization, or the
% Otsu method (LEVEL = 0);
%
% (c) 2015 - 2017 Camilo Rodríguez
%=========================================================================

DirInfo = dir(directory);

n = size(DirInfo,1);
cd(directory);
h1 = waitbar(0,'Segmenting images. Please wait...');
for i = 3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        SegmentImage(name,level,0);
    end
    waitbar(i/n,h1);
end
close(h1);
cd ..