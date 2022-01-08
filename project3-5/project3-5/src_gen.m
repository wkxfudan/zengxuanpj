%处理信号源函数
function U=src_gen(U,SRC,t)
    %根据不同的激励源种类在时间t处会获得U值
    %SRC：信号源种类
    %U：信号源矩阵
    %t：时间t
    
    for i=1:size(U,1)
        %脉冲信号
        
        if(strcmpi(SRC{i}(1),'pulse'))
            %提取参数
            V1=cell2mat(SRC{i}(2));
            V2=cell2mat(SRC{i}(3)); 
            TD=cell2mat(SRC{i}(4));
            TR=cell2mat(SRC{i}(5));
            TF=cell2mat(SRC{i}(6));
            TW=cell2mat(SRC{i}(7));
            T=cell2mat(SRC{i}(8));
            t0 = t-TD-(fix((t-TD)/T))*T;
            %开始赋值
            if(t<=TD)
                U(i)=V1;
            else
                if(t0<=TR)
                    U(i)=(V2-V1)/TR*t0+V1;
                elseif(t0<=TR+TW)
                    U(i)=V2;
                elseif(t0<=TR+TW+TF)
                    U(i)=(V2-V1)/TF*(TF+TR+TW-t0)+V1;
                else
                    U(i)=V1;
                end
            end
            
            
        %正弦信号
        
        elseif(strcmpi(SRC{i}(1),'sin'))
            %提取参数
            VD=cell2mat(SRC{i}(2));
            VM=cell2mat(SRC{i}(3)); 
            F=cell2mat(SRC{i}(4));
            TD=cell2mat(SRC{i}(5));
            
            %开始赋值
            if(t<=TD)
                U(i)=VD;
            else
                U(i)=VM*sin(2*pi*F*(t-TD))+VD;
            end
          %直流信号
        elseif(strcmpi(SRC{i}(1),'DC'))
            %提取参数
            V=cell2mat(SRC{i}(2));
            %开始赋值
            U(i)=V;
        end
    end
end    