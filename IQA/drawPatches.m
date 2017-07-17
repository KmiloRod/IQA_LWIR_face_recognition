function I = drawPatches(I,patches,patch_size,color)
%DRAWPATCHES outputs an image with the patches used for calculation of the
% NSS features for visualization purposes.

I = uint8(I);
bboxColor = uint8(255);    

nPatch = size(patches,1);
for i = 1 : nPatch
    xmin = patches(i,1);
    xmax = xmin + patch_size - 1;
	ymin = patches(i,2);
    ymax = ymin + patch_size - 1;
    
    for c = 1 : 3
        if c == color
            I(ymin,xmin:xmax,c) = bboxColor;
            I(ymax,xmin:xmax,c) = bboxColor;
            I(ymin:ymax,xmin,c) = bboxColor;
            I(ymin:ymax,xmax,c) = bboxColor;
        else
            I(ymin,xmin:xmax,c) = uint8(0);
            I(ymax,xmin:xmax,c) = uint8(0);
            I(ymin:ymax,xmin,c) = uint8(0);
            I(ymin:ymax,xmax,c) = uint8(0);
        end
    end
    
end