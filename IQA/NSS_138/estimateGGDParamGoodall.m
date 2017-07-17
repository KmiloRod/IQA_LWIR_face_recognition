function [shape, std] = estimateGGDParamGoodall(vec,nr_gam)

gam = 0.2:0.001:10;
%nr_gam = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);

variance = mean(vec.^2);
std = sqrt(variance);

rho = variance/(mean(abs(vec)))^2;
[~, array_position] = min((nr_gam - rho).^2);
shape  = gam(array_position);