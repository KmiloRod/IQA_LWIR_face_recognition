function [shape, meanparam, betal, betar, leftstd, rightstd] = estimateAGGDParamGoodall(vec,r_gam)

vec2 = vec.^2;
left_vec2 = vec2(vec<0);
right_vec2 = vec2(vec>0);

gam   = 0.2:0.001:10;
%r_gam = ((gamma(2./gam)).^2)./(gamma(1./gam).*gamma(3./gam));

leftvar            = mean(left_vec2);
leftstd            = sqrt(leftvar);
rightvar           = mean(right_vec2);
rightstd           = sqrt(rightvar);
variance           = mean(vec.^2);

gammahat           = leftstd/rightstd;
rhat               = (mean(abs(vec)))^2/variance;
rhatnorm           = (rhat*(gammahat^3 +1)*(gammahat+1))/((gammahat^2 +1)^2);
[~, array_position] = min((r_gam - rhatnorm).^2);
shape              = gam(array_position);

gam1 = gamma(1/shape); gam2 = gamma(2/shape); gam3 = gamma(3/shape);
aggdratio = sqrt(gam1/gam3);

betal              = leftstd*aggdratio;
betar              = rightstd*aggdratio;

meanparam          = (betar - betal)*(gam2/gam1);