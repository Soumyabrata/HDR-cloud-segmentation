% This script is used to indicate the Long et. al approach
  
clc;

addpath(genpath('./scripts/'));
addpath(genpath('./GraphCut/'));
addpath(genpath('./HDRimaging/'));

set_cell{1,1}='SetA';
set_cell{2,1}='SetB';
set_cell{3,1}='SetC';
set_cell{4,1}='SetD';
set_cell{5,1}='SetE';
set_cell{6,1}='SetF';
set_cell{7,1}='SetG';
set_cell{8,1}='SetH';
set_cell{9,1}='SetI';
set_cell{10,1}='SetJ';
set_cell{11,1}='SetK';
set_cell{12,1}='SetL';
set_cell{13,1}='SetM';
set_cell{14,1}='SetN';
set_cell{15,1}='SetO';
set_cell{16,1}='SetP';
set_cell{17,1}='SetQ';
set_cell{18,1}='SetR';
set_cell{19,1}='SetS';
set_cell{20,1}='SetT';
set_cell{21,1}='SetU';
set_cell{22,1}='SetV';
set_cell{23,1}='SetW';
set_cell{24,1}='SetX';
set_cell{25,1}='SetY';
set_cell{26,1}='SetZ';
set_cell{27,1}='SetZA';
set_cell{28,1}='SetZB';
set_cell{29,1}='SetZC';
set_cell{30,1}='SetZD';
set_cell{31,1}='SetZE';
set_cell{32,1}='SetZF';
set_cell{33,1}='SetZG';
set_cell{34,1}='SetZH';
set_cell{35,1}='SetZI';
set_cell{36,1}='SetZJ';
set_cell{37,1}='SetZK';
set_cell{38,1}='SetZL';
set_cell{39,1}='SetZM';
set_cell{40,1}='SetZN';
set_cell{41,1}='SetZO';
set_cell{42,1}='SetZP';
set_cell{43,1}='SetZQ';
set_cell{44,1}='SetZR';
set_cell{45,1}='SetZS';
set_cell{46,1}='SetZT';
set_cell{47,1}='SetZU';
set_cell{48,1}='SetZV';
set_cell{49,1}='SetZW';
set_cell{50,1}='SetZX';
set_cell{51,1}='SetZY';
set_cell{52,1}='SetZZ';


set_numbers=1:52;

Precision_arr=[];
Recall_arr=[];
FScore_arr=[];
Error_arr = [];


%Text file where data is to be written
fileID = fopen(['./results/Long-LDR','.txt'],'a');
fprintf(fileID,'FileNames \t Precision \t Recall \t FScore \t Error \n');

CROP_DIM = 350 ;  

for kot=set_numbers

    % Change the image size      
    rect = [(250-CROP_DIM/2) (250-CROP_DIM/2) CROP_DIM-1 CROP_DIM-1];    

    % Creating HDR
    dirName=(['./HDRSEG/',set_cell{kot,1},'/cropped/']);
    
    % Extracting the files
    [filenames, ~, ~] = readDir(dirName);
    
    %Med LDR image
    med_image = filenames(2);    
    I = imread(med_image{1}) ;
    
    [satMap,~] = maskSaturatedLDR(I,250);   
    satMap_crop = imcrop(satMap,rect);       
    
    [Red,Green,Blue] = RGBPlane(I);
    
    [rows, cols] = size(Red); %capture row's and column's length
    
   
    RBRatioImage = zeros(rows, cols); %declare an empty array filled with 0s.
    
    for i=1:rows
        for j=1:cols
            RBRatioImage(i,j)=Red(i,j)/Blue(i,j);
        end
    end    

    FinalImage = zeros(rows, cols);
    for i = 1:rows %nested for loops to traverse image row by row
        for j = 1:cols
            if RBRatioImage(i,j)<0.5755
                FinalImage(i,j) = 0/255; % sky
            else
                FinalImage(i,j) = 255/255;     % cloud
            end
        
        end
    end
    
    ThreshImage=FinalImage;
    ThreshImage_crop = imcrop(ThreshImage,rect);   


    I_GT=double(imread(['./HDRSEG/',set_cell{kot,1},'/GT/GT.png']));
    I_GT_crop = imcrop(I_GT,rect);  
    

    [Precision,Recall,FScore,Error,~,~] = error_withSat_s_c(ThreshImage_crop,I_GT_crop,satMap_crop)

    
    fprintf(fileID,'%d \t %f \t %f \t %f \t %f \n',kot,Precision, Recall, FScore, Error);
  
    Precision_arr=cat(1,Precision_arr,Precision);
    Recall_arr=cat(1,Recall_arr,Recall);
    FScore_arr=cat(1,FScore_arr,FScore);
    Error_arr=cat(1,Error_arr,Error);
 

end

disp ('Testing done');

Precision=mean(Precision_arr)
Recall=mean(Recall_arr)
FScore=mean(FScore_arr)
Error = mean(Error_arr)


fclose(fileID);


close all;
    