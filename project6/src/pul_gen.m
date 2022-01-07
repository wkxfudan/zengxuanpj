%方波波形发生器，参数从inv.sp中pulse语句获得
%Vin = pulse(0 1.8 10e-9 1.5e-9 1.5e-9 4e-9 3e-8);


function pul=pul_gen(t)
    t = rem(t,3e-8);
    
    
    if t<=10e-9
        pul=0;
    elseif t<=11.5e-9
        pul=(1.8/1.5)*(t-10e-9)*1e9;
    elseif t<=15.5e-9
        pul=1.8;
    elseif t<=17e-9
        pul=1.8-(1.8/1.5)*(t-15.5e-9)*1e9;
    else
        pul=0;
    end
end