%TRAININPREPROCESSING Prepares the NSS features for training the SVM
% classifier of the desired database.
%
% The script labels the features according to each database, extract the
% 138 NSS features of the training set using the
% EXTRACTNSS_138FEATURESDATABASE function, normalize the features and
% format them for using them as inputs to the CLASSIFICATONLEARNER app.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

clear;

Database = 'FONE';  % Modify with the desired database string (UND, PUJ, FONE)
load(strcat(Database,'_ts_pos.mat'));

switch Database
    case 'UND'
        labels = [repelem(0,41),repelem(1,30),repelem(2,30),repelem(3,30),repelem(4,30)];
    case 'PUJ'
        labels = [repelem(1,20),repelem(2,20),repelem(3,20),repelem(4,20),repelem(0,25)];
    case 'FONE'
        labels = [repelem(1,20),repelem(2,20),repelem(3,20),repelem(4,20),repelem(0,25)];
end

DatabaseFeatures = ExtractNSS_138FeaturesDatabase('TrainingPyG', ts_pos, 36, 1, labels);
[scaledFeats, scaledLimits] = ScaleData(DatabaseFeatures,0);
save(strcat(Database,'scaleLimits'),'scaledLimits');

scaledFeats = scaledFeats(:,1:end-1);
traininglabels = DatabaseFeatures(:,end);
scaledTrainingData = [scaledFeats, traininglabels];
scaledTrainingData(isnan(scaledTrainingData)) = 0;

classificationLearner