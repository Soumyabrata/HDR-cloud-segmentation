clc;

addpath(genpath('./scripts/'));
addpath(genpath('./GraphCut/'));
addpath(genpath('./HDRimaging/'));


I = imread('B10.jpg') ;
figure; imshow(I);

[color_ch]=color16_struct(I);
I_c=color_ch.c15;

figure; 
imshow(I_c);

[rows,cols,~]=size(I);

X_data=I_c(:);
[center, U, obj_fcn] = fcm(X_data, 2);
res=U(1,:);
center

if center(1)<center(2)
    cloud_mem=reshape(res,rows,cols);
else
    cloud_mem=ones(rows,cols)-reshape(res,rows,cols);
end

figure; 
imshow(cloud_mem); colormap(parula); %colorbar;
newmap = parula;