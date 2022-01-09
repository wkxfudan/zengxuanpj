% 对未降阶系统和PRIMA降阶的系统的传递函数进行对比，计算误差

clear;
warning off all; %关闭warning 
format long;
load ../Benchmark/ori_sol.mat;  % 降阶前的系统传递函数和计算时间
H0=H;
fprintf('计算未降阶的方程用时: %d \n',t_ori);  

q=60;   %阶数
s0=2*pi*1e7;    %展开点

% 载入未降阶的MNA 方程，后续调用PRIMA函数时作为参数传入
load ../Benchmark/PEEC.mat;  

tic      
[Cq,Gq,Bq,LTq]=PRIMA(C,G,B,LT,q,s0); % 调用PRIMA函数
t_prima=toc; 
% 记录降阶这一操作消耗的时间
fprintf('PRIMA降阶用时: %d \n',t_prima);  


sol_after_PRMIA;      % PRIMA降阶后的系统传递函数和计算时间
load ../Benchmark/sol_after_PRIMA.mat;   
H1=H;
fprintf('计算降阶后的方程用时: %d \n',t_after);     
esum=0;
emax=0;
step=15e9/20000;
for i=1:20000
    f(i)=i*step;           %为了制图
	err(i)=abs(H0(i)-H1(i));                 % 计算误差
    esum=esum+err(i)^2;    %采样点误差的平方和
    if emax<err(i)
        emax=err(i);     %记录下最大的绝对误差数值
    end
end

MSE=(esum/20000)^0.5;            % 均方绝对误差MSE
emax;

fprintf('绝对误差为: %f\n均方绝对误差为: %f\n', emax, MSE);


% 传递函数绘图
subplot(2,1,1);
plot(f,H0,'r');
hold on
plot(f,H1,'g');
title('传递函数: H0(S) for original,H1(s) for PRIMA');
xlabel('f');
ylabel('H(s)');
legend('Orignal','PRIMA');

% 误差绘图
subplot(2,1,2);
plot(f,err,'b');
title('误差分布');
xlabel('f');
ylabel('Error');
