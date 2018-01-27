function [saturatedMap] = findSat_th(inputImage,THRESHOLD)

  
    % When red- green and blue- channels pixels are simulateneously more
    % than threshold.
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
    
   
    

end