 function [ThresholdValue] = MCE_func(BRImage)
 % This function finds the threshold value based on MCE approach (as suggested in HYTA paper)
    %
%     I5=imread('B5.jpg');
%     [BRImage] = BRImage_func(I5);
     %I=imread(['./Florian_dB/Binary/' '100img.png']);


    [rows,cols]=size(BRImage);
    StArray=double(reshape(BRImage,1,(rows*cols)));

    x=-1:0.01:1;
    y=histc(StArray,x);
    %plot(x,y);

    % To start the initial t_int value for MCE; or else you will get NaN value
    % in the subsequent calculations
    MinValue=min(StArray);  MaxValue=max(StArray);
    %t_int=120;
    t_int_decimal= MinValue+((MaxValue-MinValue)/2);
    t_int = ceil(t_int_decimal*100)/100; 
    %
    % Finding index of t_int
    index_of_t_int=find(abs(x-t_int) < eps)
    
%     for i=1:200+1
%         f3 = ceil(x(1,i)*100)/100; 
%         
%         %f2=x(1,i)/t_int;
%         %f3 = ceil(f2*100)/100; 
%         
%         if (f3==t_int)
%             disp('sonam');
%             index_of_t_int=i;
%         end
%     end
    
    m0a=0;  m1a=0;
    for i=1:(index_of_t_int-1)
        m0a=m0a+y(1,i);
        m1a=m1a+(x(1,i)*y(1,i));
    end

    m0b=0;  m1b=0;
    for i=index_of_t_int:200+1
        m0b=m0b+y(1,i);
        m1b=m1b+(x(1,i)*y(1,i));
    end

    mu_a=(m1a/m0a);   mu_b=(m1b/m0b);

    diff=5; % Just a random starting value so that while loop continues

    t_n_decimal=((mu_b-mu_a) /(log(mu_b)-log(mu_a)));
    t_n = ceil(t_n_decimal*100)/100; 

    %
    iter=1;
    while (diff~=0)
        disp('Present iteration');
        disp(iter);
    
        t_int=t_n;
        
        % Finding index of t_int
        for i=1:200+1
          if (x(1,i)==t_int)
             index_of_t_int=i;
          end
        end
        
    
        m0a=0;  m1a=0;
        for i=1:(index_of_t_int-1)
            m0a=m0a+y(1,i);
            m1a=m1a+(x(1,i)*y(1,i));
        end

        m0b=0;  m1b=0;
        for i=index_of_t_int:200+1
            m0b=m0b+y(1,i);
            m1b=m1b+(x(1,i)*y(1,i));
        end

        mu_a=m1a/m0a;   mu_b=m1b/m0b;

        t_nplus1_decimal=((mu_b-mu_a) /   (log(mu_b)-log(mu_a)));
        t_nplus1 = ceil(t_nplus1_decimal*100)/100

        diff=abs(t_nplus1-t_n);
        t_n=t_nplus1;

        iter=iter+1;
    
    end
    
    ThresholdValue=t_n;