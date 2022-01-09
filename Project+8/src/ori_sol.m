% 直接求解未降阶的MNA方程组，保存文件并记录时间

load ../Benchmark/PEEC.mat        % 载入未降阶的MNA方程组
finterval=20000;  % 对系统传输函数在20000个点上采样
step=15e9/finterval;   %传输函数观察0-15GHz区间

tic                
for j=1:1:finterval
    
    f(j)=j*step;
    % 直接求逆得到原系统的传递函数
    H(j)=abs(LT*inv(G+2*pi*i*f(j)*C)*B);  
   
end
t_ori=toc;        % 求解原系统的时间

fprintf('Time solving the orignal MNA: %d \n',t_ori);  
% 计算原始系统传输函数比较耗费时间，只计算一次，将结果保存下来，在
% 以后每次运行程序时作为输入读入即可。
save ori_sol.mat H t_ori;  
