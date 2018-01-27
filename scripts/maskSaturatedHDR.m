function [saturatedMap,mask] = maskSaturatedHDR(dirName,THRESHOLD)

  
    [hdrMap]=createHDR(dirName);
    RGB = tonemap(hdrMap);
    
    % Extracting the files
    [filenames, ~, ~] = readDir(dirName);   
    
    % 3 = Low; 2 = Mid; 1 = High
    m_image = filenames(3);    
    low_LDR = imread(m_image{1}) ;
    
    m_image = filenames(2);    
    med_LDR = imread(m_image{1}) ;
    
    m_image = filenames(1);    
    high_LDR = imread(m_image{1}) ;  
    
    % Find saturated maps for all LDR images.
    satMap_low = findSat_th(low_LDR,THRESHOLD);
    satMap_med = findSat_th(med_LDR,THRESHOLD);
    satMap_high = findSat_th(high_LDR,THRESHOLD);
    
    
    

    
    [rows,cols,~] = size(low_LDR);
    
    saturatedMap = zeros(rows,cols);
    
    
    for i = 1:rows
       for j = 1:cols
           if (satMap_low(i,j)==1) && (satMap_med(i,j)==1) && (satMap_high(i,j)==1)
               saturatedMap(i,j) = 1;
           end
       end
    end    
    
   
    mask = RGB;
    
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