% 根据PRIMA材料对该算法进行实现
% 完成模型降阶
%

function [Cq,Gq,Bq,LTq]=PRIMA(C,G,B,LT,q,s0)
    % MNA方程已经由PEEC得到
    % 求解方程(G+s0*C)R=B，得到矩阵R
    R=inv(G+s0*C)*B;
    [X(:,1),T]=qr(R,0);  % 对R进行qr分解
    N=size(B,3);
    % 按照PDF中所述，如果q/N不是整数，则向上取整
      if rem(q,N)>0		
          n=q/N+1;   
      else
          n=q/N;
      end
    
  
      %求解矩阵X
      for k=2:1:n
          V=C*X(:,k-1);
          % 对于特定的Xk,求解(G+s0*C)*Xk =V ，得到初值Xk(0)
          X(:,k)=inv(G+s0*C)*V;
          
          for j=1:1:k-1
              H=X(:,k-j)'*X(:,k);
              X(:,k)=X(:,k)-X(:,k-j)*H;
          end
          [X(:,k),T]=qr(X(:,k),0);
      end
      %更新Xq
      for k=1:1:q
          Xq(:,k)=X(:,k);
      end
  
      % 计算系数矩阵C~=Xq'*C*Xq ,G~=Xq'*G*Xq , B~=Xq'*B, L~=Xq'*L
      Cq=Xq'*C*Xq;
      Gq=Xq'*G*Xq;
      Bq=Xq'*B;
      LTq=LT*Xq;   %由于要返回的事LTq,故两边同取转置
  