function TotalRank = ParamRank(DirName,Database,param,parValues)
%PARAMRANK Tests the TST LWIR face recognition algorithm on several values
% of the parameters kappa and rho.
%
% [TOTALRANK] = PARAMRANK(DIRNAME, DATABASE, PARAM, PARVALUES) receives as
% inputs a name of the folder containing the test images (DIRNAME), a
% DATABASE to be used, a PARAM string specifying the parameter to be
% tested, and a vector of values of the parameters PARVALUES.
%
% The function returns in TOTALRANK a three-dimensional matrix of
% recognition accuracies. The first dimension corresponds to the values of
% the parameter kappa, the second dimension to the number of images in the
% DIRNAME directory, and the third dimension to the values of the parameter
% rho (se_size).
%
% DATABASE = String belonging to {UND, PUJ, FONE}
% PARAM = String belonging to {kappa, se_size, both}
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

tic

Threshold = 0;
DirInfo = dir(DirName);
n = size(DirInfo,1);
k = 0;

for i = 3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        k = k + 1;
    end
end

n = k;

if strcmp(param,'both')
    Kappa_values = parValues{1}; rho_values = parValues{2};
    numKappa = numel(Kappa_values); numRho = numel(rho_values);
    TotalRank = zeros(numKappa,n,numRho);
    for k = 1:numRho
        current_rho_value = rho_values(k);
        parfor i = 1:numKappa
            TotalRank(i,:,k) = ResultsParTS(DirName,Database,1,Threshold,param,[Kappa_values(i), current_rho_value]);
            i
        end
        k
    end
else
    numValues = size(parValues,2);
    TotalRank = zeros(numValues,n);
    parfor i = 1:numValues
        TotalRank(i,:) = ResultsParTS(DirName,Database,1,Threshold,param,parValues(i));
        i
    end    
end

load gong.mat
sound (y, Fs);
toc