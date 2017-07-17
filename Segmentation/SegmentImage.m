function SegmentImage(s,level,disp_option)
%SEGMENTIMAGE segments face from background in a LWIR facial image, using
% the Otsu method for umbralization or a specified threshold LEVEL. For
% using the Otsu method, LEVEL must be set to 0.
%
% (c) 2015 - 2017 Camilo Rodríguez
%=========================================================================

n = size(s);
I = imread(s);
Ifn = segmentOtsu(I,level,disp_option);

if size(I,3)==3
    I = rgb2gray(I);
end

if isa(I,'uint8')
    If = I.*uint8(Ifn);
elseif isa(I,'uint16')
    If = I.*uint16(Ifn);
end

newname = strcat(s(1:n(2)-5),'sg.tiff');
imwrite(If,newname);
