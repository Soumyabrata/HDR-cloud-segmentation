function [hdrMap]=createHDR(directory_name)

    dirName = directory_name;
    [filenames, exposures, numExposures] = readDir(dirName);
    filenames'
    exposures

    fprintf('Opening test image\n');
    tmp = imread(filenames{1});


    numPixels = size(tmp,1) * size(tmp,2);
    numExposures = size(filenames,2);


    % define lamda smoothing factor
    l = 50;


    fprintf('Computing weighting function\n');
    % precompute the weighting function value
    % for each pixel
    weights = [];
    for i=1:256
        weights(i) = weight(i,1,256);
    end


    % load and sample the images
    [zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, numPixels);

    B = zeros(size(zRed,1)*size(zRed,2), numExposures);

    fprintf('Creating exposures matrix B\n')
    for i = 1:numExposures
        B(:,i) = log(exposures(i));
    end

    % solve the system for each color channel
    fprintf('Solving for red channel\n')
    [gRed,lERed]=gsolve(zRed, B, l, weights);
    fprintf('Solving for green channel\n')
    [gGreen,lEGreen]=gsolve(zGreen, B, l, weights);
    fprintf('Solving for blue channel\n')
    [gBlue,lEBlue]=gsolve(zBlue, B, l, weights);
    save('gMatrix.mat','gRed', 'gGreen', 'gBlue');


    % compute the hdr radiance map
    fprintf('Computing hdr image\n')
    hdrMap = hdr(filenames, gRed, gGreen, gBlue, weights, B);

end