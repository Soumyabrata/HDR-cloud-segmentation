function [Precision,Recall,FScore, Error, s_error, c_error] = error_withSat_s_c(ThreshImage,GroundTruth,saturatedMap)
% This also calculates error.
% Also calculates the sky- and cloud- error.

    [r1,c1]=size(ThreshImage);

    
    GroundTruth1=GroundTruth;
    [r,c]=size(GroundTruth1);
    GroundTruth=zeros(r,c);
    for i=1:r
        for j=1:c
            if GroundTruth1(i,j)<128
                GroundTruth(i,j)=0;
            else
                GroundTruth(i,j)=1;
            end
        end
    end
    
    
    
    TP=0;   FP=0;   TN=0;   FN=0;
    

    for i=1:r1
        for j=1:c1
            
            if (saturatedMap(i,j) == 0)
                if (GroundTruth(i,j)==1 && ThreshImage(i,j)==1)   % TP condition
                    TP=TP+1;
                elseif ((GroundTruth(i,j)==0)&& (ThreshImage(i,j)==1))   % FP condition
                    FP=FP+1;
                elseif ((GroundTruth(i,j)==0)&& (ThreshImage(i,j)==0))   % TN condition
                    TN=TN+1;
                elseif ((GroundTruth(i,j)==1)&&(ThreshImage(i,j)==0))   % FN condition
                    FN=FN+1;
                end
            end   
        end
    end
    

    
    Precision=TP/(TP+FP);
    Recall=TP/(TP+FN);
    FScore=(2*Precision*Recall)/(Precision+Recall);
    
    
    error_count=0;
    cloud_error_count = 0;
    sky_error_count = 0;
    
    for i=1:r1
        for j=1:c1
            
            if (saturatedMap(i,j) == 0)
                if (GroundTruth(i,j)~=ThreshImage(i,j))
                    error_count=error_count+1;
                end                
                
                % Check for cloud error. Actual is cloud, but detected sky
                if (GroundTruth(i,j)==1) && (ThreshImage(i,j)==0)
                    cloud_error_count=cloud_error_count+1;
                end
                
                % Check for sky error. Actual is sky, but detected cloud
                if (GroundTruth(i,j)==0) && (ThreshImage(i,j)==1)
                    sky_error_count=sky_error_count+1;
                end
                
            end
        end
        
    end
    
    consideredPixels = length(find(saturatedMap(:)==0));

    
    Error=(error_count/consideredPixels)*100;
    
    s_error=(sky_error_count/consideredPixels)*100;
    c_error=(cloud_error_count/consideredPixels)*100;
    
