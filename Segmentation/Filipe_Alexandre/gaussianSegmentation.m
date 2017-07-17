function imageOut = gaussianSegmentation(image, omega_i, miu_i, sigma_i)

image = double(image);
imageOut = zeros(size(image));

pi_i = ones(1, 2)/2.0;
for i = 1 : size(image, 1)
    for j = 1 : size(image, 2)
        valueClass1 = pi_i(1, 1) * f_xj_theta(image(i, j), 1, omega_i, miu_i, sigma_i);
        valueClass2 = pi_i(1, 2) * f_xj_theta(image(i, j), 2, omega_i, miu_i, sigma_i);
        
        belonceClass2 = valueClass2 / (valueClass2 + valueClass1);
        
        if(belonceClass2 < 0.5)
            pi_i(j, 1) = 1 - belonceClass2;
            imageOut(i, j) = 0;
        else
            pi_i(j, 2) = belonceClass2;
            imageOut(i, j) = 1;
        end
    end
end

imagePlot = uint8(image.*imageOut);
imageOut = imageOut*255;

end

function p = f_xj_theta(x, class, omega, miu, sigma)

    p = 0.0;
    for i = 1 : size(omega, 2)
        p = p + (omega(class, i)*normalDensity(x, miu(class, i), sigma(class, i)));
    end
end

function p = normalDensity(x, miu_i, sigma_i)
% Compute density of normal distribution function
% 
% Calculate normal density.
% 
% INPUTS:
%   x         = point at which to calculate the normal distribution
%   miu_i     = mean of the normal
%   sigma_i   = variance of the normal
%
%
    if(sigma_i == 0)
        p = 1;
    else
        p = (1.0/(sqrt(2.0*pi*sigma_i))) * exp(-((x-miu_i)^2)/(2.0*(sigma_i)));
    end
    if(p < 1e-4)
        p = 1e-4;
    elseif(p > 1e4)
        p = 1e4;
    end
    
end