%THERMALSIMILARITYDATABASECLASS138 Calculates similarity measures between a
% thermal signature extracted from an infrared face image and all the
% thermal signature templates from a gallery database. The extraction of
% thermal signatures from the test images is enhanced with 138 NSS image
% quality features.
% [Measures] = THERMALSIMILARITYDATABASECLASS138(ImageName, Database, mode)
% extracts the vascular network from thermal face image ImageName and
% compares it with all the thermal signatures stored in .mat files in the
% directory 'Signatures'. The parameters for the vascular network
% extraction are estimated using a SVM classifier trained previously.
% The function returns a vector of similiarity measures with length equal
% to the number of thermal signatures in the directory.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
function [Measures] = ThermalSimilarityDatabaseClass138(ImageName,Database,mode)

if mode == 0
    DirInfo = dir('../Signatures/aniso');
    olddir = cd ('../Signatures/aniso');
elseif mode == 1
    DirInfo = dir('../Signatures/skel');
    olddir = cd ('../Signatures/skel');
end

n = size(DirInfo,1);

Measures = zeros(1,n-2);

Image = imread(ImageName);

% Estimation of kappa and se_size parameters using a SVM classifier
[kappa, se_size] = VEParametersPredictor138(ImageName, Database);

% Thermal Signature extraction with estimated parameters
VascImage = vascularExtParVar(Image,0,[kappa, se_size]);
k = 1;

for i=3:n
    name = DirInfo(i).name;
    if strcmp(name(end-3:end),'.mat')
        Measures(k) = ThermalSimilarityR(name,VascImage);
        k = k + 1;
    else
        Measures(k) = [];
    end
end
cd(olddir)