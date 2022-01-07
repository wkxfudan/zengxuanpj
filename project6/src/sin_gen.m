%正弦波波形发生器，参数从diff_amp.sp中sin语句获得
%Vin=sin(1.65 1m 1e2)
function my_sin=sin_gen(t)
   my_sin=1.65 + (1e-3)*sin(200*pi*t);
end
