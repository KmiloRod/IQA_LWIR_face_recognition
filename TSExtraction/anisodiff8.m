% ANISODIFF8 - Anisotropic diffusion.
%
% Usage:
%  diff = anisodiff8(im, niter, kappa, lambda, option)
%
% Arguments:
%         im     - input image
%         niter  - number of iterations.
%         kappa  - conduction coefficient 20-100 ?
%         lambda - max value of .25 for stability
%         option - 1 Perona Malik diffusion equation No 1
%                  2 Perona Malik diffusion equation No 2
%
% Returns:
%         diff   - diffused image.
%
% kappa controls conduction as a function of gradient.  If kappa is low
% small intensity gradients are able to block conduction and hence diffusion
% across step edges.  A large value reduces the influence of intensity
% gradients on conduction.
%
% lambda controls speed of diffusion (you usually want it at a maximum of
% 0.25)
%
% Diffusion equation 1 favours high contrast edges over low contrast ones.
% Diffusion equation 2 favours wide regions over smaller ones.

% Reference: 
% P. Perona and J. Malik. 
% Scale-space and edge detection using ansotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.
%
% Peter Kovesi  
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au
% http://www.csse.uwa.edu.au
%
% Camilo Rodríguez
% Pontificia Universidad Javeriana
% Cali, Colombia
%
% June 2000  original version.       
% March 2002 corrected diffusion eqn No 2.
% April 2016 (Camilo Rodríguez) added 4 diagonal directions for a total of
% 8 orientations
% 

function diff = anisodiff8(im, niter, kappa, lambda, option)

if ndims(im)==3
  error('Anisodiff only operates on 2D grey-scale images');
end

im = double(im);
[rows,cols] = size(im);
diff = im;
  
for i = 1:niter
%  fprintf('\rIteration %d',i);

  % Construct diffl which is the same as diff but
  % has an extra padding of zeros around it.
  diffl = zeros(rows+2, cols+2);
  diffl(2:rows+1, 2:cols+1) = diff;

  % North, South, East and West differences
  deltaN = diffl(1:rows,2:cols+1)   - diff;
  deltaS = diffl(3:rows+2,2:cols+1) - diff;
  deltaE = diffl(2:rows+1,3:cols+2) - diff;
  deltaW = diffl(2:rows+1,1:cols)   - diff;
  
  % NorthEast, NorthWest, SouthEast and SouthWest differences
  deltaNE = diffl(1:rows,3:cols+2)   - diff;
  deltaNW = diffl(1:rows,1:cols)   - diff;
  deltaSE = diffl(3:rows+2,3:cols+2) - diff;
  deltaSW = diffl(3:rows+2,1:cols) - diff;
    
  % Conduction

  if option == 1
    cN = exp(-(deltaN/kappa).^2);
    cS = exp(-(deltaS/kappa).^2);
    cE = exp(-(deltaE/kappa).^2);
    cW = exp(-(deltaW/kappa).^2);
    cNE = exp(-(deltaNE/kappa).^2);
    cNW = exp(-(deltaNW/kappa).^2);
    cSE = exp(-(deltaSE/kappa).^2);
    cSW = exp(-(deltaSW/kappa).^2);    
  elseif option == 2
    cN = 1./(1 + (deltaN/kappa).^2);
    cS = 1./(1 + (deltaS/kappa).^2);
    cE = 1./(1 + (deltaE/kappa).^2);
    cW = 1./(1 + (deltaW/kappa).^2);
    cNE = 1./(1 + (deltaNE/kappa).^2);
    cNW = 1./(1 + (deltaNW/kappa).^2);
    cSE = 1./(1 + (deltaSE/kappa).^2);
    cSW = 1./(1 + (deltaSW/kappa).^2);
  end

%  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW);
  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW + cNE.*deltaNE + cNW.*deltaNW + cSE.*deltaSE + cSW.*deltaSW);

%  Uncomment the following to see a progression of images
%   subplot(ceil(sqrt(niter)),ceil(sqrt(niter)), i)
%  imagesc(diff), colormap(gray), axis image

end
%fprintf('\n');

