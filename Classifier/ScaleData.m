function [scaledData, scaledLimits] = ScaleData(InputData, InputLimits)
%SCALEDATA Normalize the input features between 0 and 1
% [SCALEDDATA, SCALEDLIMITS] = SCALEDATA(INPUTDATA, INPUTLIMITS)
% receives a matrix of features INPUTDATA and a 1xN vector INPUTLIMITS with
% minimum and maximum limit values for normalization of the N columns of
% the INPUTDATA features matrix.
% If INPUTLIMITS is an scalar, the function normalize INPUTDATA using its
% own minimum and maximum values of each column as limits.
%
% The function returns as output in SCALEDDATA the normalized matrix of
% features, and the minimum and maximum limits used for each column in
% SCALEDLIMITS.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

scaledData = zeros(size(InputData));

if numel(InputLimits) == 1
    maxData = max(InputData);
    minData = min(InputData);
else
    maxData = InputLimits(:,1)';
    minData = InputLimits(:,2)';
end

for i = 1:size(InputData,2)
    scaledData(:,i) = (InputData(:,i) - minData(:,i))/(maxData(:,i)-minData(:,i));
end

scaledLimits = [maxData', minData'];