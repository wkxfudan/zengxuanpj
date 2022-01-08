clear all;
close all;
stamp RLC_s3.sp;                %读入网表文件
data=read_data('RLC_s3.lis');   %读入仿真波形

t_total=data(size(data,1),1);   %为了保持与HSPICE的一致性，选择HSPICE的仿真时长，作为本设计的仿真时长。
t_step=data(2,1)-data(1,1);
n=t_total/t_step;


%初值问题求解

tic;

[L0,U0,change_line_info,LU_info,change_line_num,change_LU_num]=LU_gen(G);%进行LU分解
b=B*U;
u(:,1)=U;%所有独立源输入在初始时刻的值
x(:,1)=solve_LU(L0,U0,b,change_line_info,LU_info,change_line_num,change_LU_num);%解方程得到所有未知量的初始值


%后项欧拉法解方程

[L1,U1,change_line_info,LU_info,change_line_num,change_LU_num]=LU_gen(G+C/t_step);
for i=1:n
   u(:,i+1)=src_gen(U,SRC,t_step*i); 
   b=B*u(:,i+1)+C*x(:,i)/t_step;
   x(:,i+1)=solve_LU(L1,U1,b,change_line_info,LU_info,change_line_num,change_LU_num);
end
y=LT*x; 

toc;
time=toc;



%画图

t=0:t_step:t_total;

subplot(2,2,1);
for i=1:size(u,1)
    plot(t,u(i,:));
    hold on;
end
    xlabel('time(t)');
    ylabel('input');
    title('输入波形');
    
subplot(2,2,2);
for i=1:size(y,1)%即确定有多少个源，画多少条线
        m=1/round(unifrnd(1,5,1,1));
        o=1/round(unifrnd(1,5,1,1));
        p=1/round(unifrnd(1,5,1,1));
    plot(t,y(i,:),'color',[m,o,p]);
    hold on;
end
    xlabel('time(t)');
    ylabel('output');
    title('后向欧拉法输出波形');
    
subplot(2,2,3);
plot(t,y(1,:),'-g');
hold on
plot(t,data(:,2),'r');
xlabel('time(t)');
ylabel('compare');
title('后向欧拉法输出波形与SPICE输出波形对比');


%计算误差

error=zeros(size(data,1),1);
SE=0;
for i=1:size(data,1)
    error(i)=abs(data(i,2)-y(1,i));
    SE=SE+error(i)^2;
end
MSE=sqrt(SE/size(data,1));


%输出误差

subplot(2,2,4);
plot(t,error,'m');
xlabel('time(t)');
ylabel('error');
title('所选输出绝对误差分布');


%打印输出

fprintf('后项欧拉方法计算点数:      %d\n',size(data,1));
fprintf('后项欧拉方法总模拟时间:    %d(s)\n',time);
fprintf('最大绝对误差:             %f\n',max(abs(error)));
fprintf('均方绝对误差MSE:          %f\n',MSE);


