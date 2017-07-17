%THERMALSIMILARITYDATABASEPAR Calculates similarity measures between a thermal
% face image and all the thermal signatures from a database.
% [Measures] = THERMALSIMILARITYDATABASEPAR(ImageName, Database, mode,
% param, parValue) extracts the vascular network from thermal face image
% ImageName and compares it with all the thermal signatures stored in .mat
% files in the directory 'Signatures'. The parameters for the vascular
% network extractionc can be specified with the param and parValue
% arguments.
% The function returns a vector of similiarity measures with length equal
% to the number of thermal signatures in the directory.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
function [Measures] = ThermalSimilarityDatabasePar(ImageName,Database,mode,param,parValue)

if mode == 0
    DirInfo = dir('../../Signatures/aniso');
    olddir = cd ('../Signatures/aniso');
elseif mode == 1
    DirInfo = dir('../../Signatures/skel');
    olddir = cd ('../../Signatures/skel');
end

n = size(DirInfo,1);

Measures = zeros(1,n-2);
VascImage = vascularExtPar(ImageName,0,Database,param,parValue);
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