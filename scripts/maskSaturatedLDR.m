function [saturatedMap,mask] = maskSaturatedLDR(inputImage,THRESHOLD)

  
    % When red- green and blue- channels pixels are simulateneously more
    % than threshold.----> it is saturated.
    [red,green,blue] = RGBPlane(inputImage);
    
    red = double(red);
    green = double(green);
    blue = double(blue);
    
    [rows,cols] = size(red);
    
    saturatedMap = zeros(rows,cols);
    
    
    for i = 1:rows
       for j = 1:cols
           if (red(i,j)>THRESHOLD) && (green(i,j)>THRESHOLD) && (blue(i,j)>THRESHOLD)
               saturatedMap(i,j) = 1;
           end
       end
    end    
    
   
    mask = inputImage;
    
    for i=1:rows
       for j=1:cols
          if  saturatedMap(i,j)==1
              mask(i,j,1)=255;
              mask(i,j,2)=0;
              mask(i,j,3)=255;
          end
       end

    end    
    

end