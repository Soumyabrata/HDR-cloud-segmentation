% This function is used to find the (B-R)/(B+R) from the given image
function [BRImage] = BRImage_func(TestImage)

    [red,green,blue] = RGBPlane(TestImage);
    DoubleRed=double(red);
    DoubleGreen=double(green);
    DoubleBlue=double(blue);

    [rows,cols]=size(red);
    BRImage=zeros(rows,cols);


    for i=1:rows
        for j=1:cols
            BRImage(i,j)=(-DoubleRed(i,j)+DoubleBlue(i,j))/(DoubleRed(i,j)+DoubleBlue(i,j));
        end
    end