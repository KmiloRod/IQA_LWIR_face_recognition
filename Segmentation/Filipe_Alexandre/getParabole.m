function [fLeftRightOut, imageOriginal1] = getParabole(image, colLeft, colRight, debug)

image = image(:, :, 1);
imageOriginal1 = image;

limSup = double(uint32((2 * size(image, 1))/3));
image = double(image(limSup:size(image, 1), :));

numColors = 4;
factor = 256 / numColors;
imgColorReduction = image;
for i = 0 : numColors
    imgColorReduction(image >= i*factor & image < (i + 1) * factor) = uint8((i*factor + (i + 1)*factor)/2.0);
end

h = fspecial('gaussian', 25, 2.5);
imgBlur = imfilter(imgColorReduction, h);

imgEdge = edge(imgBlur,'canny', [0.2 0.7], 1.0);
imgEdge255 = imgEdge * 255;
 
[x0, y0] = find(imgEdge ~= 0);

x = 1 : size(imgEdge, 2);
[p,S,mu] = polyfit(y0, x0, 2);
% p(1) = abs(p(1)) * -1;
%disp(p)

xleftRight = colLeft : colRight;
[f, ~] = polyval(p, x, S, mu);
[xLeft, ~] = polyval(p, colLeft, S, mu);
[xRight, ~] = polyval(p, colRight, S, mu);
[fLeftRight, ~] = polyval(p, xleftRight, S, mu);

if(p(1) < 0)
    fLeftRight = max(fLeftRight);
else
    fLeftRight = mean([xLeft xRight]);
end

for i = 1 : colLeft
    if(double(uint32(f(i) + limSup)) >= 1)
        xx = double(uint32(f(i) + limSup)) : size(imageOriginal1, 1);
    else
        xx = 1 : size(imageOriginal1, 1);
    end

    if(f(i) + limSup <= size(imageOriginal1, 1))
        imageOriginal1(xx, i) = 0;
    end
end

for i = colLeft : colRight
    if(double(uint32(fLeftRight + limSup)) >= 1)
        xx = double(uint32(fLeftRight + limSup)) : size(imageOriginal1, 1);
    else
        xx = 1 : size(imageOriginal1, 1);
    end

    if(fLeftRight + limSup <= size(imageOriginal1, 1))
        imageOriginal1(xx, i) = 0;
    end
end

for i = colRight : size(imageOriginal1, 2)
    if(double(uint32(f(i) + limSup)) >= 1)
        xx = double(uint32(f(i) + limSup)) : size(imageOriginal1, 1);
    else
        xx = 1 : size(imageOriginal1, 1);
    end

    imageOriginal1(xx, i) = 0;
end

fLeftRightOut = fLeftRight + limSup;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG
if(debug)
    figure(3), subplot(2, 2, 1), imshow(imageOriginal1);
    hold on
        plot(colLeft, 1:size(imageOriginal1, 1), '-g');
        plot(colRight, 1:size(imageOriginal1, 1), '-g');
        
        plot(x, f + limSup, '.r');
        plot(xleftRight, fLeftRight + limSup, '-b');
    hold off
    
    figure(3), subplot(2, 2, 2), imshow(uint8(imgColorReduction));
    hold on
        plot(colLeft, 1:size(image, 1), '-g');
        plot(colRight, 1:size(image, 1), '-g');
        
        plot(x, f, '.r');
        plot(xleftRight, fLeftRight, '-b');
    hold off
    
    figure(3), subplot(2, 2, 3), imshow(uint8(imgBlur));
    hold on
        plot(colLeft, 1:size(image, 1), '-g');
        plot(colRight, 1:size(image, 1), '-g');
        
        plot(x, f, '.r');
        plot(xleftRight, fLeftRight, '-b');
    hold off
    
    figure(3), subplot(2, 2, 4), imshow(uint8(imgEdge255));
    hold on
        plot(colLeft, 1:size(image, 1), '-g');
        plot(colRight, 1:size(image, 1), '-g');
        
        plot(x, f, '.r');
        plot(xleftRight, fLeftRight, '-b');
    hold off
    
%     figure(5), plot(0, 0, '.r');
%     hold on;        
%         plot(x, f, '.r');
%         plot(x, fLeftRight, '-b');
%     hold off;
    
    pause(0.3)
end