% 调用PRIMA函数完成降阶后，再直接求解降阶后的系统

% 以下代码原理同originalsol中的代码，就是直接求解方程组
% 只不过降阶后的方程组规模大大减小
tic;    
finterval=20000;
step=15e9/finterval;
for j=1:1:finterval
	f(j)=j*step;
    H(j)=abs(LTq*inv(Gq+2*pi*i*f(j)*Cq)*Bq);
end
t_after=toc;  % 记录求解降阶后的方程组花费的时间
save ../Benchmark/sol_after_PRIMA.mat H t_after;   
