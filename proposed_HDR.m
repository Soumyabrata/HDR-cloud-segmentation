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

fileID = fopen('./results/proposed-HDR.txt','a');
fprintf(fileID,'Set_number \t Precision \t Recall \t FScore \t Error \n');

Precision_arr=[];
Recall_arr=[];
FScore_arr=[];
Error_arr=[];

CROP_DIM = 350 ;  

for kot = set_numbers

    
    % Creating HDR
    dirName=(['./HDRSEG/',set_cell{kot,1},'/cropped/']);
    [hdrMap]=createHDR(dirName);
    RGB = tonemap(hdrMap);
    
    
    % Change the image size      
    rect = [(250-CROP_DIM/2) (250-CROP_DIM/2) CROP_DIM-1 CROP_DIM-1];

    

    [satMap,~] = maskSaturatedHDR(dirName,250);    
    satMap_crop = imcrop(satMap,rect);
    
    

    
    

    [color_ch]=color16_struct(hdrMap);
    im = double(color_ch.c15);
    [rows,cols]=size(im);


    obs=15;

    I_cc = eval(['color_ch.c',num2str(obs)]);


    X_data=I_cc(:);


    [center, U, obj_fcn] = fcm(X_data, 2);
    res=U(1,:);

    center




    if center(1)<center(2)
        cloud_mem=reshape(res,rows,cols);
    else
        cloud_mem=ones(rows,cols)-reshape(res,rows,cols);
    end


    % Thresholds for setting seeds.
    t2=0.88;
    t1=1-t2;


    I_overlay=double(RGB);


    I_seed=zeros(rows,cols);
    I_seed(I_seed==0)=99;

    cloud_data=zeros(rows*cols,1);
    sky_data=zeros(rows*cols,1);

    cc=0; sc=0;

    for i=1:rows
       for j=1:cols
            if cloud_mem(i,j)>t2

                cc=cc+1;

                I_overlay(i,j,1)=0;
                I_overlay(i,j,2)=1;
                I_overlay(i,j,3)=0;

                I_seed(i,j)=2; % Cloud label

                cloud_data(cc,1)=I_cc(i,j);

            elseif cloud_mem(i,j)<t1

                sc=sc+1;

                I_overlay(i,j,1)=1;
                I_overlay(i,j,2)=0;
                I_overlay(i,j,3)=0;

                I_seed(i,j)=1; % Sky label

                sky_data(sc,1)=I_cc(i,j);
            end
       end
    end



    I_overlay=uint8(I_overlay);



    % Trimming the extra zeros.
    cloud_data(((cc+1):(rows*cols)),:)=[];
    sky_data(((sc+1):(rows*cols)),:)=[];


    % Finding cluster centers of the seeded points
    try 
        [~,c1] = kmeans(sky_data, 1, 'distance', 'sqEuclidean','maxiter',200);
        [~,c2] = kmeans(cloud_data, 1, 'distance', 'sqEuclidean','maxiter',200);
    catch
        disp('Same clusters --- skipping')
        continue;
    end    


    cluster_center(1,1)=c1;
    cluster_center(2,1)=c2;
    st_seed=ToVector(I_seed);


    [L]=AGC(I_cc,st_seed,cluster_center, 2);



    comb_I=uint8(L.*255);
    L_crop = imcrop(L,rect); 




    I_GT=double(imread(['./HDRSEG/',set_cell{kot,1},'/GT/GT.png']));
  
    
    % Change the image size
    I_GT_crop = imcrop(I_GT,rect); 
    

    [Precision,Recall,FScore,Error,~,~] = error_withSat_s_c(L_crop,I_GT_crop,satMap_crop)

     
    fprintf(fileID,'%d \t %f \t %f \t %f \t %f \n', kot, Precision, Recall, FScore, Error);
    
    Precision_arr=cat(1,Precision_arr,Precision);
    Recall_arr=cat(1,Recall_arr,Recall);
    FScore_arr=cat(1,FScore_arr,FScore);
    Error_arr = cat(1,Error_arr,Error);   
    

   close all;
    
end

disp ('Testing Done');

Precision=nanmean(Precision_arr)
Recall=nanmean(Recall_arr)
FScore=nanmean(FScore_arr)
Error = nanmean(Error_arr)

fclose(fileID);
