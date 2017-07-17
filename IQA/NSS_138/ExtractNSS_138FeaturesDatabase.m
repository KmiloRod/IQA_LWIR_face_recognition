function DatabaseFeatures = ExtractNSS_138FeaturesDatabase(DirName, ts_pos, patchsize, include_labels, labels)
% The function EXTRACNSS_138FEATURESDATABASE extracts NSS features from
% square patches of size PATCHSIZE of each image within folder DIRNAME, and
% returns them in a matrix DATABASEFEATURES. It receives a cell matrix of
% bounding box coordinates of the pristine images from the dataset
% (TS_POS), the labels assigned for each image for training a classifier
% with the features as inputs (LABELS) and a flag INCLUDE_LABELS which
% specifies if the labels are included as the last column in the output
% matrix DATABASEFEATURES
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================


tic
ImageNames = ts_pos(:,1);

DirInfo = dir(DirName);
n = size(DirInfo,1);
oldFolder = cd(DirName);

DatabaseFeatures = [];

wait_h = waitbar(0,'Extracting features','OuterPosition',[100,100,350,80]);
formatSpec = 'Extracting features from image %d of %d';

k = 0;

for i = 3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        k = k + 1;
        waitbar(k/n, wait_h, sprintf(formatSpec, k, n-2));
        ImageIndex = [];
        for j = 1:size(ImageNames,1)
            if strfind(name,ImageNames{j})
                ImageIndex = j;
                break;
            end
        end
        image = imread(name);
        [NSSfeatures] = ImQualityFeaturesBlock138(image, patchsize, ts_pos{ImageIndex,2});
        if include_labels
            NSSfeatures = [NSSfeatures, repelem(labels(k),size(NSSfeatures,1))'];
        end
        DatabaseFeatures = [DatabaseFeatures; NSSfeatures];
    end
end
close(wait_h);
cd(oldFolder)
toc