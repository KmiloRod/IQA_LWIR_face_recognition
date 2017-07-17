function showOverlappedTS(VascImage, ThermalSignature)
%SHOWOVERLAPPEDTS display in a figure the overlapped images of a thermal
% signature (VASCIMAGE) and a Thermal Signature Template (THERMALSIGNATURE)
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

overlapImage(:,:,1) = uint8(VascImage)*255;%zeros(size(VascImage));
overlapImage(:,:,2) = uint8(ThermalSignature)*255;
overlapImage(:,:,3) = uint8(VascImage)*255;

figure; imshow(overlapImage,'Border','tight');
