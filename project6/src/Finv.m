function F = Finv(Vin,Vout)

    %分段给出F

    if Vin<=0.7                      
        F=0;
    elseif Vin<0.9                   
        F = 1811*(Vin-0.7)*(Vin-0.7)*(1+0.1*Vout)-1725*(2*(1-Vin)*(1.8-Vout)-(1.8-Vout)*(1.8-Vout))*(1.36-0.2*Vout);
    elseif Vin<=1                  
        F = 1811*(2*(Vin-0.7)*Vout-Vout*Vout)*(1+0.1*Vout)-1725*(1-Vin)*(1-Vin)*(1.36-0.2*Vout);
    else                              
        F=0;               
    end
    
end
    