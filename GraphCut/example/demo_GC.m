% Demo on graph cut method.


% An example of how to segment a color image according to pixel colors.
% Fisrt stage identifies k distinct clusters in the color space of the
% image. Then the image is segmented according to these regions; each pixel
% is assigned to its cluster and the GraphCut poses smoothness constraint
% on this labeling.

clear all; clc;

% read an image
%im = im2double(imread('outdoor_small.jpg'));
%[color_ch]=color16_struct(hdrMap);
%im = im2double(imread('12img.png'));
%im = color_ch.c15;

image = im2double(imread('/home/soumya/Dropbox/MATLAB/HDR_input/SetE/cropped/set_three_1_125.png'));
[color_ch]=color16_struct(image);
im = color_ch.c15;

sz = size(im);

% try to segment the image into k different regions
k = 3;

% color space distance
distance = 'sqEuclidean';

% cluster the image colors into k regions
data = ToVector(im);
[idx c] = kmeans(data, k, 'distance', distance,'maxiter',200);
idx(1:1:2879999,:)=[];


% calculate the data cost per cluster center
Dc = zeros([sz(1:2) k],'single');
for ci=1:k
    % use covariance matrix per cluster
    icv = inv(cov(data(idx==ci,:)));    
    dif = data - repmat(c(ci,:), [size(data,1) 1]);
    % data cost is minus log likelihood of the pixel to belong to each
    % cluster according to its RGB value
    Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
end

% cut the graph

% smoothness term: 
% constant part
Sc = ones(k) - eye(k);
% spatialy varying part
% [Hc Vc] = gradient(imfilter(rgb2gray(im),fspecial('gauss',[3 3]),'symmetric'));
[Hc Vc] = SpatialCues(im);

gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
[gch L] = GraphCut('expand',gch);
gch = GraphCut('close', gch);

% show results
figure;
imshow(im);
hold on;
PlotLabels(L);

figure; imagesc(double(L)); colormap(parula); colorbar;





