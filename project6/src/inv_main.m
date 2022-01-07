% 在反相器的情况下，实际上是一维的牛顿法求解电路方程
clear all;
epi=0.0001; % 设置0.001是一个可以接受的误差容限

% 通过tran语句获得仿真时长、时间步长
T=10e-8;        
step=1e-11;    

timeintercal=T/step;
t=0;

for i=1:1:timeintercal+1                    %分时间点单独进行求解
    % Vint是Vin也就是输入电压在时间点t的数值
    Vint=pul_gen(t);

    % 输入电压小于0.7V和大于1V时直接输出结果
    if pul_gen(t)<=0.7                      
        Vout0=1.8;                        
        Vout=1.8;                         
    elseif pul_gen(t)>=1                   
        Vout=0;                           
        Vout0=0;
    else                                    % 这个else管到迭代结束！
        Vout0=0.9;                          % 两个MOS管都导通，这里假设初值为电源电压的一半0.9V
    
        trys=1000;                          % 经过1000次迭代若仍达不到epi的误差容限，就退出
                                            % 并视为不收敛（可能是波形的转折点）
        % 以下为牛顿法，求解单个时间点上的数值解
        while trys>=0
            F=Finv(Vint,Vout0);
            J=Jinv(Vint,Vout0);
            Vout=Vout0-inv(J)*F;             
            trys=trys-1;
            
            % 是否达到了上面定义的epi要求
            if abs(Vout-Vout0)<epi && abs(F)<epi   
               break;
            else
                % 继续迭代
                Vout0=Vout;
            end
        end

    % 超出迭代次数后，如果这些不收敛的点的确是0或1.8V附近的点，就直接把它们
    % “固定”到地或电源电平，否则输出波形错误！
        if Vout<0
            Vout=0;
        elseif Vout>1.8
            Vout=1.8;
        end
    end
        Voutput(i)=Vout;
        Vinput(i)=pul_gen(t);
        
        discretetime(i)=t;   %只用来制图
        t=t+step;    % 移动到下一个时间点
end

% 输入绘图
subplot(2,1,1);
plot(discretetime,Vinput,'r');
title('Input wave','FontSize',12);
xlabel('t','FontSize',12);
ylabel('Voltage','FontSize',12);

% 输出绘图
subplot(2,1,2);
plot(discretetime,Voutput,'b');
title('Output wave','FontSize',12);
xlabel('t','FontSize',12);
ylabel('Voltage','FontSize',12);
