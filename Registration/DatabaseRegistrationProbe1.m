function DatabaseRegistrationProbe1(RefImage)

% DATABASEREGISTRATIONPROBE1 Manually register all images in current folder
% with a global reference image (REFIMAGE). Saves the registered images
% with the 'reg' suffix.

DirInfo = dir(cd);
n = size(DirInfo,1);

for i=3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp')
        ManualFeatureRegistration(RefImage,name,1,1);
    end
end