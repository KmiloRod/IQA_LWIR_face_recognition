%THERMALSIMILARITYR Calculates a similarity measure between a thermal face
% image and a thermal signature file from a database.
% [MEASURE] = THERMALSIMILARITYR(SIGNATUREFILENAME, IMAGENAME)
% Extracts the vascular network from thermal face image IMAGENAME and
% compares it with a thermal signature in the .mat file SIGNATUREFILENAME,
% calculating a similarity measure in the range 0-1 and returning it in
% MEASURE.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
function [Measure] = ThermalSimilarityR(SignatureFileName,VascImage)

Distance = @(Punto1, Punto2) abs(sqrt(((Punto2(:,1)-Punto1(:,1)).^2)+((Punto2(:,2)-Punto1(:,2)).^2)));

load(SignatureFileName);

[FeaturesBr, FeaturesBc] = find(ThermalSignature);
FeaturesB = [FeaturesBr FeaturesBc];
NB = length(FeaturesBr);

[FeaturesAr, FeaturesAc] = find(VascImage);
FeaturesA = [FeaturesAr FeaturesAc];
NA = length(FeaturesAr);

[h, minAB] = min([NA NB]);
Measure = 0;

for i=1:h
    if minAB == 2
        CurrentFeature = FeaturesB(i,:);
        dist = sort(Distance(CurrentFeature,FeaturesA(:,:)));
    elseif minAB == 1
        CurrentFeature = FeaturesA(i,:);
        dist = sort(Distance(CurrentFeature,FeaturesB(:,:)));
    end        
    D = dist(1);
    Measure = Measure + 1/(h*(D+1));
end



