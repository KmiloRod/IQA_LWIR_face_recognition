function [Scores] = ThermalSimilaritySignatures(SignatureFileName1,mode)

Distance = @(Punto1, Punto2) abs(sqrt(((Punto2(:,1)-Punto1(:,1)).^2)+((Punto2(:,2)-Punto1(:,2)).^2)));

if mode == 0
    DirInfo = dir('Signatures/aniso');
    cd ('Signatures/aniso');
elseif mode == 1
    DirInfo = dir('Signatures/skel');
    cd ('Signatures/skel');
end

n = size(DirInfo,1);

load(SignatureFileName1);
ThermalSignature1 = ThermalSignature;

[FeaturesBr, FeaturesBc] = find(ThermalSignature1);
FeaturesB = [FeaturesBr FeaturesBc];
NB = length(FeaturesBr);

Scores = zeros(1,n-2);
j = 1;

wait_h = waitbar(0,'Calculating similarity scores','OuterPosition',[100,100,350,80]);

for i=3:n
    name = DirInfo(i).name;
    if strcmp(name(end-3:end),'.mat')
        load(name);
        ThermalSignature2 = ThermalSignature;

        [FeaturesAr, FeaturesAc] = find(ThermalSignature2);
        FeaturesA = [FeaturesAr FeaturesAc];
        NA = length(FeaturesAr);

        h = min(NA,NB);
        Measure = 0;
        D = [];

        parfor k=1:h
            CurrentFeature = FeaturesB(k,:);
            %FeaturesB(k,:) = NaN;
            dist = sort(Distance(CurrentFeature,FeaturesA(:,:)));
            D(k) = dist(1);
            Measure = Measure + 1/(h*(D(k)+1));
        end
        Scores(j) = Measure;
        j = j + 1;
    else
        Scores(j) = [];
    end
    waitbar((i-2)/n,wait_h);
end
close(wait_h)
cd ..
cd ..