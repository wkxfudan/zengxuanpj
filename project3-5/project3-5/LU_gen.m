%因为分解矩阵时要需要记录行交换信息因此需要创立自己的LU分解
%函数作用：稀疏矩阵的LU分解
function [L,U,change_line_info,LU_info,change_line_num,change_LU_num]=LU_gen(A)
    %A:待分解矩阵
    %L,U:分解后得到的L和U
    %change_line_info:交换行信息
    %LU_info:交换列信息
    %change_line_num:交换行数目
    %chang_LU_num:交换列数目
    
    A_size=size(A,1);
    A=full(A);
    change_line_info(1,1:2)=[1,1];
    change_line_num=0;
    LU_info(1,1:2)=[1,1];%lu分解必备换行信息，相当于lu分解函数中的P矩阵
    change_LU_num=0;
    
    
    for i=1:A_size-1
        
        Atmp_size=A_size-i+1;%Atmp is a matrix which is going to be change lines
        Markowitz=zeros(Atmp_size,2);%
        for j=i:A_size
            Atmp_size=A_size-j+1;%A_tmp是右下角矩阵用来进行换行
            [m,n,v]=find(A(j,:));%j是i后面所有行列
            Markowitz(j-i+1,1:2)=[j,size(m,1)];
        end
        [wuyong,ascend_num]=sort(Markowitz(:,2));%ascend_num是升序排列后对应Matrices矩阵行数
        min_loc=Markowitz(ascend_num(1),1);%对应的Markowitz积最小的行
        if (min_loc~=i)
            %交换行
            tmp=A(i,:);
            A(i,:)=A(min_loc,:);
            A(min_loc,:)=A(i,:);
            %交换列
            tmp=A(:,i);
            A(:,i)=A(:,min_loc);
            A(:,min_loc)=tmp;
            %记录信息
            change_line_num=change_line+1;
            change_line_info(changge_line_num,1:2)=[i,min_loc];
        end
        %以上完成Matrices积最小替换
    
        
       %开始LU分解     
        max=abs(A(i,i));
        for m=i+1:A_size%主要用于将该列最大值行提取出来
            if(abs(A(m,i))>max)
                max=abs(A(m,i));
                tmp=A(i,:);
                A(i,:)=A(m,:);
                A(m,:)=tmp;
                
                %换行记录下来
                change_LU_num=change_LU_num+1;
                LU_info(change_LU_num,1:2)=[i,m];
            end
        end 
        
        for j=i+1:A_size
            A(j,i)=A(j,i)/A(i,i);
            for k=i+1:A_size
                A(j,k)=A(j,k)-A(j,i)*A(i,k);
            end
        end
        %以上完成LU分解
        
    
       %提取LU矩阵
    U=triu(A);
    L=tril(A);
    for i=1:A_size
        L(i,i)=1;
    end
    end
                
end