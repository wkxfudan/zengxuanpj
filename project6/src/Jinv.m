% 定义反相器电路的Jacobi矩阵
% 分段给出J

function J=Jinv(Vin,Vout)
    format long;
             
    if(Vin<=0.7)                      
        J=1;
    elseif(Vin<0.9)                   
        J=1811*(Vin-0.7)*(Vin-0.7)*0.1-1725*(2*Vin-2+2*(1.8-Vout))*(1.36-0.2*Vout)-1725*(2*(1-Vin)*(1.8-Vout)-(1.8-Vout)*(1.8-Vout))*(-0.2);
    elseif(Vin<=1)                   
        J=1811*(2*(Vin-0.7)-2*Vout)*(1+0.1*Vout)+1811*(2*(Vin-0.7)*Vout- Vout*Vout)*0.1-1725*(1-Vin)*(1-Vin)*(1.36-0.2*Vout);
    else                           
        J=1;                
    end
end 