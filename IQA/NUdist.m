function NUdist(DatabaseDir,OutputDir,sigma,index)
%NUDIST Applies Non-Uniformity distortion to a set of images.
% NUDIST(DATABASEDIR, OUTPUTDIR, SIGMA, QUALITY) applies simulated
% non-uniformity distortion to thermal images in folder DATABASEDIR with a
% mean 0 and standard deviation SIGMA, and saves the compressed images in
% folder OUTPUTDIR adding a prefix to the image name. INDEX is a natural
% number used to label the output images, indicating the level of
% distortion applied.
%
% This implementation of NU noise is an adaptation of the model developed
% by Pezoa and Medina. See the paper:
%
% J. E. Pezoa and O. J. Medina, Spectral model for fixed-pattern-noise in
% infrared focal-plane arrays. Berlin, Heidelberg: Springer Berlin
% Heidelberg, 2011, pp. 55?63.
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================
tic

close all;

Bu=5.2;
Bv=Bu;
sigma_u=2.5;
sigma_v=sigma_u;
u0=0;
v0=0;
K=0;

DirInfo = dir(DatabaseDir);
n = size(DirInfo,1);

if exist(OutputDir,'dir')~=7
    mkdir(OutputDir)
end


for i = 3:n
    name = DirInfo(i).name;
    if (strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp'))
        I = im2double(imread(name));
        [N,M] = size(I);
        [U,V] = meshgrid(-M/2:M/2,-N/2:N/2);
        Mag = Bu*exp((-(U-u0).^2)/(2*(sigma_u)^2)) + Bv*exp((-(V-v0).^2)/(2*(sigma_v)^2)); %Magnitude;
        Phase = 2*pi*rand(M+1,N+1)-pi; %Phase
        FPN = (ifft2(ifftshift(((Mag+K)).*exp(1i*(Phase))'))); %Fixed pattern noise
        FPN = abs(FPN(1:end-1,1:end-1));
        FPN_ad = mat2gray(FPN);
        I_NU = mat2gray((FPN_ad * sigma) + I);
        imwrite(I_NU,strcat(OutputDir,'/','NU',num2str(index),'_',name));
    end
end
toc