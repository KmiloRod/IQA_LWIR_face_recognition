%VEPARAMETERSPREDICTOR138 Estimates two parameters governing thermal
% signature extraction from a face LWIR image, using a previously trained
% SVM classifier
%
% [KAPPA, RHO] = VEPARAMETERSPREDICTOR138(IMNAME, DATABASE) estimates the
% optimal values for parameters KAPPA and RHO using a SVM with 138 NSS
% features as inputs, and the type of distortion that affects an image
% as output. After obtaining the distortion type, the function selects the
% values for KAPPA and SE_SIZE from a table.
% The function receives as inputs the image name IMNAME and a string
% DATABASE with the thermal face database used ('UND', 'PUJ', 'FONE').
% The function returns the optimal values of kappa and rho for the input
% image which can be used to extract its thermal signature.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function [kappa, rho] = VEParametersPredictor138(ImName, Database)

image = imread(ImName);
ClassifierName = strcat(Database,'Classifier');

load(strcat(Database,'_ts_pos.mat'));
load(strcat(Database,'scaleLimits.mat'));
load(strcat(ClassifierName,'.mat'));

% TS extraction parameters for each database and distortion
%                 kappa rho
TSParametersUND = [ 15  9;    % Pristine 0
                    50  15;   % AWGN 1
                    10  5;    % Blur 2
                    15  6;    % JPEG 3
                    30  10];  % NU 4

TSParametersPUJ = [ 20  10;    % Pristine 0
                    50  23;   % AWGN 1
                    10  7;    % Blur 2
                    20  11;    % JPEG 3
                    25  22];  % NU 4

TSParametersFONE = [ 15  11;    % Pristine 0
                     50  24;   % AWGN 1
                     10  5;    % Blur 2
                     15  12;    % JPEG 3
                     30  12];  % NU 4

ImageNames = ts_pos(:,1);
ImageIndex = [];

for j = 1:size(ImageNames,1)
    if strfind(ImName,ImageNames{j})
        ImageIndex = j;
        break;
    end
end

r_min = ts_pos{ImageIndex,2}(1); r_max = ts_pos{ImageIndex,2}(2);
c_min = ts_pos{ImageIndex,2}(3); c_max = ts_pos{ImageIndex,2}(4); 

NSSfeatures = ImQualityFeaturesBlock138(image, 36, [r_min r_max c_min c_max]);
[scaledImageFeats, ~] = ScaleData(NSSfeatures,scaledLimits);
scaledImageFeats(isnan(scaledImageFeats)) = 0;
distortionIndex = distortionClassifier.predictFcn(scaledImageFeats);
[~, distortionIndex] = max(sum(distortionIndex==[0 1 2 3 4]));

switch Database
    case 'UND'
        kappa = TSParametersUND(distortionIndex, 1);
        rho = TSParametersUND(distortionIndex, 2);
    case 'PUJ'
        kappa = TSParametersPUJ(distortionIndex, 1);
        rho = TSParametersPUJ(distortionIndex, 2);        
    case 'FONE'
        kappa = TSParametersFONE(distortionIndex, 1);
        rho = TSParametersFONE(distortionIndex, 2);        
end