%直接法解方程函数
function x=solveLU(L,U,b,change_line_info,LU_info,change_line_num,change_LU_num)
    %主要用于初值问题和迭代问题两部分
    %特殊性在于解方程前b的变换和解方程后x的恢复
    
        
    for i=1:change_line_num
        tmp=b(change_line_info(i,1));
        b(change_line_info(i,1))=b(change_line_info(i,2));
        b(change_line_info(i,2))=tmp;
    end
    
    for i=1:change_LU_num
        tmp=b(LU_info(i,1));
        b(LU_info(i,1))=b(LU_info(i,2));
        b(LU_info(i,2))=tmp;
    end
    
    
    %进行方程求解
    
    n=size(L,1);
    y=zeros(n,1);
    y(1)=b(1);
    for i = 2 : n
        y(i) = b(i);
        for j = 1 : i-1
            y(i) = y(i) - y(j)*L(i,j);
        end
    end
    
    x = zeros(n,1);
    x(n) = y(n) / U(n,n);
    
    %直接法求取
    for i = n-1 : -1 : 1
        x(i) = y(i);
        for j = i+1 : n
            x(i) = x(i) - x (j)*U(i,j);
        end
        x(i) = x(i)/ U(i,i);
    end
    
    
    %将X变回正确的顺序      
    
    for i=change_line_num:-1:1
        tmp=x(change_line_info(i,2));
        x(change_line_info(i,2))=x(change_line_info(i,1));
        x(change_line_info(i,1))=tmp;
    end
    
end    