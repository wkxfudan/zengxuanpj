% 求解差分放大器时，情况与反相器不同。有三个节点的电压未知，因此可以列出
% 三个方程，分别为Vout1,Vout2,Vp节点的电流方程
clear all;
% 设置0.001是一个可以接受的误差容限
% 仿真时长、时间步长由sp文件的.tran语句获得
T=0.2;                  
step=1e-3;		  
epi=0.0001;             
timeinterval=T/step;

t=0;
X0=[2;1;2];     % 大概合理的初始值

for i=1:1:timeinterval+1
    trys=1000;
    Vint = sin_gen(t);
    % 以下为牛顿法，求解单个时间点上的数值解
    while (trys>0)
       
       F=Famp(X0,Vint);
       J=Jamp(X0,Vint);
       X=X0-inv(J)*F;  
       trys=trys-1;
        % 是否达到了上面定义的epi要求
       if abs(X-X0)<=epi             
          break;
       else
            % 继续迭代
          X0=X;
       end
    end
    Voutput1(i)=X(1);
    Voutput2(i)=X(2);
    
    Vinput(i)=sin_gen(t);
    discretetime(i)=t;     %只用来制图
    t=t+step;     % 移动到下一个时间点
 end
   
  % 输入绘图
   subplot(3,1,1);
   plot(discretetime,Vinput,'g');
   title('Input wave','FontSize',12);
   xlabel('t','FontSize',12);
   ylabel('Voltage','FontSize',12);

   % 输出绘图
   subplot(3,1,2);
   plot(discretetime,Voutput1,'r');
   title('Voutput1 wave','FontSize',12);
   xlabel('t','FontSize',12);
   ylabel('Voltage','FontSize',12);

   % 输出绘图
   subplot(3,1,3);
   plot(discretetime,Voutput2,'b');
   title('Voutput2 wave','FontSize',12);
   xlabel('t','FontSize',12);
   ylabel('Voltage','FontSize',12);
