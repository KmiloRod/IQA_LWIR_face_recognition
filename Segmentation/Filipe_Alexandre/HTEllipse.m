%Hough Transform for Ellipses
function [row col] = HTEllipse(inputimage,a,b)
    %image size
    [rows,columns]=size(inputimage);
    %accumulator
    acc=zeros(rows,columns);
    %image
    for x=1:columns
        for y=1:rows
            if(inputimage(y,x)==0)
                for ang=0:360
                    t=(ang*pi)/180;
                    x0=round(x-a*cos(t));
                    y0=round(y-b*sin(t));
                    
                    if(x0<columns & x0>0 & y0<rows & y0>0)
                        acc(y0,x0)=acc(y0,x0)+1;
                    end
                end
            end
        end
    end
    
    m = max(max(acc));
    [row, col] = find(acc == m);
    %row = mean(row);
    %col = mean(col);
    figure(2), surf(acc);