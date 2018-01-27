function [L]=AGC_k(image,seeds,cluster_center, cluster_number,cons)
% This function performs the Automatic Graph Cut method.


    sz = size(image);

    % try to segment the image into k different regions
    k = cluster_number;



    % % cluster the image colors into k regions
    data = ToVector(image);



    % calculate the data cost per cluster center
    Dc = zeros([sz(1:2) k],'single');
    for ci=1:k
        % use covariance matrix per cluster
        icv = inv(cov(data(seeds==ci,:)));    
        dif = data - repmat(cluster_center(ci,:), [size(data,1) 1]);
        % data cost is minus log likelihood of the pixel to belong to each
        % cluster according to its RGB value
        Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
    end

    % cut the graph

    % smoothness term: 
    % constant part
    Sc = ones(k) - eye(k);
    % spatialy varying part
    %[Hc Vc] = gradient(imfilter(rgb2gray(image),fspecial('gauss',[3 3]),'symmetric'));
    [Hc Vc] = SpatialCues(image);

    % Change the smoothness constant multiplied before Sc
    gch = GraphCut('open', Dc, cons*Sc, exp(-Vc*5), exp(-Hc*5));
    [gch L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);



end