function SegmentationSilvio(inputImageName, outputImageName, omega_i, miu_i, sigma_i, debug)


image = imread(inputImageName);
imageXX = image;
% Signature of the Original image
imHistLine = sum(image);
imHistColumn = sum(image');

% filter2 = zeros(size(imHistLine));
% tam = uint32(0.15*size(imHistLine, 2)/2);
% for i = uint32(size(imHistLine, 2)/2) - tam : uint32(size(imHistLine, 2)/2) + tam -1
%     filter2(1, i) = 1.0 / (0.15*size(imHistLine, 2));
% end

filter2 = fspecial('gaussian', size(imHistLine), 0.05*size(imHistLine, 2));

fftFilter = fft(filter2);
fftimHistLine = fft(imHistLine);
z = fftimHistLine.*fftFilter;
imHistLineSignal = ifft(z);
imHistLineSignal = ifftshift(imHistLineSignal);

imHistLineDiff = zeros(1, size(imHistLine, 2));
for i = 1 : size(imHistLineDiff, 2)-1
    imHistLineDiff(1, i) = (imHistLineSignal(1, i+1) - imHistLineSignal(1, i));
end
imHistLineDiff(1, size(imHistLineDiff, 2)) = imHistLineDiff(1, size(imHistLineDiff, 2)-1);

[value colRight] = min(imHistLineDiff);
[value colLeft] = max(imHistLineDiff(1:colRight));

if(colLeft > colRight)
    aux = colLeft;
    colLeft = colRight;
    colRight = aux;
end

% fprintf('Teste1 %d %d %f\n', colLeft, colRight, 100 - abs(colLeft - colRight))
if(90 - abs(colLeft - colRight) >= 0) 
    meanAbs = double(uint32((90 - abs(colLeft - colRight)) / 2.0));
    colLeft = colLeft - meanAbs;
    colRight = colRight + meanAbs;
end

% fprintf('Teste2 %d %d %f\n', colLeft, colRight, abs(colLeft - colRight))
if(colLeft < 1)
    colRight = colRight + abs(colLeft);
    colLeft = 1;
end

% fprintf('Teste3 %d %d %f\n', colLeft, colRight, abs(colLeft - colRight))
if(colRight > size(imHistLineDiff, 2))
    colLeft = colLeft - abs(colRight - size(imHistLineDiff, 2));
    colRight = size(imHistLineDiff, 2);
end

colRight = mean(colRight);
colLeft = mean(colLeft);
% fprintf('Teste Final %d %d %f\n', colLeft, colRight, abs(colLeft - colRight))
image2 = image;
image2(:, 1:colLeft) = 0;
image2(:, colRight:size(image2, 2)) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Columns
imHistColumn = sum(image2');

filter = fspecial('gaussian', size(imHistColumn), 3);
fftFilter = fft(filter);

filter = zeros(size(imHistColumn));
tam = uint32(0.15*size(imHistColumn, 2)/2);
for i = uint32(size(imHistColumn, 2)/2) - tam : uint32(size(imHistColumn, 2)/2) + tam -1
    filter(1, i) = 1.0 / (0.15*size(imHistColumn, 2));
end
fftFilter = fft(filter);

fftimHistColumn = fft(imHistColumn);
z = fftimHistColumn.*fftFilter;
imHistColumnSignal = ifft(z);
imHistColumnSignal = ifftshift(imHistColumnSignal);

imHistColumnDiff = zeros(1, size(imHistColumn, 2));
for i = 1 : size(imHistColumnDiff, 2)-1
    imHistColumnDiff(1, i) = (imHistColumnSignal(1, i+1) - imHistColumnSignal(1, i));
end
imHistColumnDiff(1, size(imHistColumnDiff, 2)) = imHistColumnDiff(1, size(imHistColumnDiff, 2)-1);

[value rowUp] = max(imHistColumnDiff);
rowUp = mean(rowUp);

% rowUp = 0;
% value = 0;
% if(sum(imHistColumn(1, 1:rowDown)) > sum(imHistColumn(1, rowDown:size(imHistColumnDiff, 2))))
%     [value rowUp] = min(imHistColumnDiff(1, 1:rowDown));
% else
%     [value rowUp] = min(imHistColumnDiff(1, rowDown:size(imHistColumnDiff, 2)));
%     rowUp = rowUp + rowDown;
% end
% rowUp = mean(rowUp);

[rowDown, imageSemiSeg] = getParabole(imageXX, colLeft, colRight, false);

rowDown = double(uint32(rowDown));
if(rowDown > size(image, 1))
    rowDown = size(image, 1);
end

disp(rowDown)

if(rowUp > rowDown)
    aux = rowDown;
    rowDown = rowUp;
    rowUp = aux;
end

while(abs(rowUp - rowDown) < 135 & rowDown < size(imHistColumnDiff, 2))
    aux = rowDown;
    [value rowDown] = min(imHistColumnDiff(1, aux+1:size(imHistColumnDiff, 2)));
    rowDown = rowDown + aux;
end
while(abs(rowUp - rowDown) < 135 & rowUp > 1)
    [value rowUp] = max(imHistColumnDiff(1, 1:rowUp-1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Teste Professor Luis
% imageLeft = image(:, 1:colLeft);
% imageRight = image(:, colRight:size(image, 2));
% 
% sumLeft = sum(imageLeft');
% sumRight = sum(imageRight');
% 
% fftSumLeft = fft(sumLeft);
% z = fftSumLeft.*fftFilter;
% sumLeftSignal = ifft(z);
% sumLeftSignal = ifftshift(sumLeftSignal);
% 
% fftSumRight = fft(sumRight);
% z = fftSumRight.*fftFilter;
% sumRightSignal = ifft(z);
% sumRightSignal = ifftshift(sumRightSignal);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

faceCenterCol = double(colRight + colLeft)/2.0;
faceCenterCol = uint32(faceCenterCol);
faceCenterCol = double(faceCenterCol);

faceCenterRow = double(rowDown + rowUp)/2.0;
faceCenterRow = uint32(faceCenterRow);
faceCenterRow = double(faceCenterRow);

%image(:, 1:colLeft) = 0;
%image(:, colRight:size(image, 2)) = 0;

%image(1:rowUp, :) = 0;
%image(rowDown:size(image, 1), :) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Draw ellipse
beta = 2.0*pi;
sinbeta = sin(beta);
cosbeta = cos(beta);

a = abs(colLeft - faceCenterCol); 
b  = abs(rowUp - faceCenterRow);

x = faceCenterCol;
y = faceCenterRow;

imEllipse = ones(size(image));
for i = 0 :0.1: 360
    alpha = i * (pi / 180) ;
    sinalpha = sin(alpha);
    cosalpha = cos(alpha);
 
    X = x + (a * cosalpha * cosbeta - b * sinalpha * sinbeta);
    Y = y + (a * cosalpha * sinbeta + b * sinalpha * cosbeta);

    X = uint32(X);
    X = double(X);
    Y = uint32(Y);
    Y = double(Y);
    
    if(X < 1)
        X = 1;
    end
    
    if(X > x & Y > y)
        imEllipse(Y:size(image, 1), X) = 0;
        imEllipse(Y, X:size(image, 2)) = 0;
    elseif(X < x & Y > y)
        imEllipse(Y:size(image, 1), X) = 0;
        imEllipse(Y, 1:X) = 0;
    elseif(X > x & Y < y)
        imEllipse(1:Y, X) = 0;
        imEllipse(Y, X:size(image, 2)) = 0;
    elseif(X < x & Y < y)
        imEllipse(1:Y, X) = 0;
        imEllipse(Y, 1:X) = 0;
    elseif(X > x & Y == y)
        imEllipse(:, X:size(image, 2)) = 0;
    elseif(X < x & Y == y)
        imEllipse(:, 1:X) = 0;
    elseif(X == x & Y > y)
        imEllipse(Y:size(image, 1), :) = 0;
    elseif(X == x & Y < y)
        imEllipse(1:Y, :) = 0;
    end
end

imageSemiSeg2 = imageSemiSeg;
imageSemiSeg2(1:2, :) = 0;
imageSemiSeg2(size(image, 1)-2:size(image, 1), :) = 0;
imageSemiSeg2(:, 1:2) = 0;
imageSemiSeg2(:, size(image, 2)-2:size(image, 2)) = 0;

imageMaskGauss = chenvese(imageSemiSeg2, imresize(imEllipse, size(imageSemiSeg2)), 200, 1.5, 'chan');
imageMaskGauss = imresize(imageMaskGauss, size(imageSemiSeg2));
imageMaskGauss = imageMaskGauss * 255;
imageMaskGauss2 = imageMaskGauss;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Imagens para o artigo


elipseChanVese = imresize(imEllipse, size(imageSemiSeg2));
inputChanVese = imageSemiSeg2;
outputChanVese = imageMaskGauss2;
save('dados.mat', 'elipseChanVese', 'inputChanVese', 'outputChanVese');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Aplie the Canny edge detector
% imageMaskGauss = imdilate(imageMaskGauss, ones(3)); 
imEdge2 = imerode(imageMaskGauss, ones(4));                          %ERA 4
imEdge2 = imdilate(imEdge2, ones(2));                       % ESTAVA DESCOMENTADO
imEdge2 = edge(imEdge2, 'canny');
imEdge = imdilate(imEdge2, ones(3));                                   
[L, num] = bwlabel(imEdge, 8);



distMin = 10000;
distPos = 10000;
distMax = 0;
for i = 1 : num
    [row col] = find(L == i);
    if(distMax < size(col, 1))
        distMax = size(col, 1);
    end
end

for i = 1 : num
    [row col] = find(L == i);
    
    if(size(col, 1) >= 0.5*distMax)
        a = mean(col);
        b = mean(row);

        c = sqrt((a - faceCenterCol)^2) + sqrt((b - faceCenterRow)^2);
        if(distMin > c)
            distMin = c;
            distPos = i;
        end
    end
end
for i = 1 : size(L, 1)
    for j = 1 : size(L, 2)
        if(L(i, j) ~= distPos)
            L(i, j) = 0;
        else
            L(i, j) = 1;
        end
    end
end
imEdge = imEdge .* L;


imEdge = imfill(imEdge);
imEdge = imerode(imEdge, ones(4));
imageSeg = imEdge * 255;
imageSeg3 = imageSeg;

imageMaskGauss = double(imageMaskGauss);
imageSeg = double(imageSeg);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Método com o fecho

imageSeg2 = abs(imageSeg - imageMaskGauss);
se = strel('disk', 10);
imageSeg2 = imopen(imageSeg2, se);
% imageSeg2 = uint8(imageSeg2);
imageSeg = (imageSeg + imageSeg2);
imageSeg(imageSeg < 0) = 0;
imageSeg(imageSeg > 255) = 0;

    imageSeg = uint8(im2bw(imageSeg)) .*  image;

% imageSeg = bwareaopen(imageSeg, 100);

% se = strel('disk', 7);
% imageSeg = imerode(imageSeg, se);
% se = strel('disk', 15);
% imageSeg = imclose(imageSeg, se);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Método com a convolução

% imageSeg2 = imageSeg - imageMaskGauss;
% imageSeg2(imageSeg2 < 0) = 0;
% se = ones(30,25);
% imageSeg2 = conv2(imageSeg2, se, 'same');
% imageSeg2(imageSeg2 < 0.7 * 10^5) = 0;
% imageSeg2(imageSeg2 >= 0.7 * 10^5) = 255;
% 
% imageSeg = (imageSeg + imageSeg2);
% 
% imageSeg(imageSeg < 0) = 0;
% imageSeg(imageSeg > 255) = 0;
% 
% imageSeg = imopen(imageSeg, ones(2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG
if(debug)
    figure(2), imshow(image);
    figure(3), imshow(imageSemiSeg);
    figure(4), imshow(imEllipse);
    figure(5), imshow(imageMaskGauss2);
    figure(6), imshow(imageSeg);
    
%     figure(2), subplot(3, 6, 1), imshow(image), title('Original');
%     hold on
%         
%         plot(1:size(image, 2), rowUp(1, 1), '-r');
%         plot(1:size(image, 2), rowDown, '-g');
% 
%         plot(colLeft, 1:size(image, 1), '-r');
%         plot(colRight, 1:size(image, 1), '-g');
%         
%         plot(size(image, 2)/2, size(image, 1)/2, 'or');
%         
%         plot(faceCenterCol, faceCenterRow, 'xg');
%     hold off
    
%     figure(2), subplot(3, 6, 4), plot(imHistColumn, size(imHistColumn, 2):-1:1),  title('Signature Column'), axis([0 max(imHistColumn) 0 size(image, 1)]);
%     figure(2), subplot(3, 6, 3), plot(imHistColumnSignal, size(imHistColumnSignal, 2):-1:1),  title('Signature Column'), axis([min(imHistColumnSignal) max(imHistColumnSignal) 0 size(image, 1)]);   
%     figure(2), subplot(3, 6, 2), plot(imHistColumnDiff, size(imHistColumnDiff, 2):-1:1),  title('Signature Column'), axis([min(imHistColumnDiff) max(imHistColumnDiff) 0 size(image, 1)]);
%     hold on
%         col = min(imHistColumnDiff):max(imHistColumnDiff);
%     
%         plot(col, size(image, 1)-rowUp, '-r');
%         plot(col, size(image, 1)-rowDown, '-g');
%     hold off
%     
%     figure(2), subplot(3, 6, 5), plot(filter, size(imHistColumnDiff, 2):-1:1), title('Filter'), axis([0 2.0*max(filter) 0 size(image, 1)]);
%     
%     figure(2), subplot(3, 6, 9), plot(1:size(imHistLine, 2), imHistLine), title('Signature Row'), axis([0 size(image, 2) 0 max(imHistLine)]);
%     figure(2), subplot(3, 6, 8), plot(1:size(imHistLineSignal, 2), imHistLineSignal), title('Signature Row'), axis([0 size(image, 2) 0 max(imHistLineSignal)]);
%     figure(2), subplot(3, 6, 7), plot(1:size(imHistLineDiff, 2), imHistLineDiff), title('Signature Row'), axis([0 size(image, 2) min(imHistLineDiff) max(imHistLineDiff)]);
%     hold on
%         col = min(imHistLineDiff):max(imHistLineDiff);
%         plot(colLeft, col, '-r');
%         plot(colRight, col, '-g');
%     hold off
%     figure(2), subplot(3, 6, 10), plot(filter2), title('Filter'), axis([0 size(image, 2) 0 2.0*max(filter2)]);
%     
% %    figure(2), subplot(3, 6, 13), imshow(imageMaskGauss);
%     figure(2), subplot(3, 6, 14), imshow(imEllipse);
%     
%     figure(2), subplot(3, 6, 15), imshow(imageSeg3);
%     figure(2), subplot(3, 6, 16), imshow(imageSeg2);
%     figure(2), subplot(3, 6, 17), imshow(imageMaskGauss);
%     figure(2), subplot(3, 6, 18), imshow(imageSeg);
    
%     figure(2), subplot(3, 6, 4), imshow(imageMaskGauss), title('Signature Removed');
%     hold on
%     plot(faceCenterCol, faceCenterRow, '-.or');
%     plot(faceCenterCol, rowDown, '-.og');
%     plot(faceCenterCol, rowUp, '-.oy');
%     plot(colRight, faceCenterRow, '-.xg');
%     plot(colLeft, faceCenterRow, '-.xy');
%     ellipse( abs(colRight - faceCenterCol), abs(rowDown - faceCenterRow), 2.0*pi, faceCenterCol, faceCenterRow, 'r', 300);
%     hold off
%     figure(2), subplot(2, 6, 5), plot(imHistColumn2, size(imHistColumn2, 2):-1:1),  title('Signature Column'), axis([0 max(imHistColumn2)+10 0 size(image, 1)]);
%     figure(2), subplot(2, 6, 10), plot(1:size(imHistLine2, 2), imHistLine2), title('Signature Row'), axis([0 size(image, 2) 0 max(imHistLine2)+10]);
%     
%     figure(2), subplot(2, 6, 11), imshow(imEllipse), title('Ellipse Mask');
%     figure(2), subplot(2, 6, 12), imshow(seg), title('Segmented');

    %pause(0.1);
end

imwrite(imageSeg, outputImageName);
