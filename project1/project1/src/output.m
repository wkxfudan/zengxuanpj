%输出各稀疏矩阵以及报告
%运行过程和最后结果用稀疏矩阵存储，各矩阵都可以通过相应的.mat文件查看

if ~exist('results\')   %如果result文件夹不存在，则创建文件夹，用以存放C，G，B，U，X，Y二进制文件
    mkdir('results'); 
end                     %若result文件夹存在，则跳过创建文件夹步骤
  
X(1:node_LUT_num)=strcat('V(', X(1:node_LUT_num),')');    %X向量中电压量标上电压符号 如 V(node1) V(1)
X(node_LUT_num+1:C_column_row)=strcat('I(', X(node_LUT_num+1:C_column_row),')');   %X向量中电流量标上电流符号 如 I(Vin) I(L1)


fid=fopen('results\report.txt', 'w');
fprintf(fid,'** Matrix C (Size: %d x %d) **\n',C_column_row, C_column_row);
    fprintf(fid,'   This Matrix is too large. Please see results\\C.mat \n'); 
fclose(fid);

fid=fopen('results\report.txt', 'a');
fprintf(fid,'\n** Matrix G (Size: %d x %d) **\n',G_column_row, G_column_row);        %打印矩阵G到文本
    fprintf(fid,'   This Matrix is too large. Please see results\\G.mat  \n'); 
fclose(fid);

fid=fopen('results\report.txt', 'a');
fprintf(fid,'\n** Matrix B (Size: %d x %d) **\n',B_column, B_row);       %打印矩阵B到文本
    fprintf(fid,'   This Matrix is too large. Please see results\\B.mat  \n'); 
fclose(fid);

fid=fopen('results\report.txt', 'a');
fprintf(fid,'\n** Matrix LT (Size: %d x %d) **\n',LT_column, LT_row);         %打印矩阵LT到文本
    fprintf(fid,'   This Matrix is too large. Please see results\\LT.mat  \n');
fclose(fid);

fid=fopen('results\report.txt', 'a');                                                       
fprintf(fid,'\n** Vector X (Size: %d x %d) **\n',C_column_row, 1);
if(C_column_row<20)
    n=1;
    while n<=C_column_row
        fprintf(fid,'  %s', X{n});         %打印向量X到文本
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see results\\X.mat  '); 
end

fprintf(fid,'\n\n** Vector Y (Size: %d x %d) **\n',quest_num, 1);
if(quest_num<20)
    n=1;
    while n<=quest_num
        fprintf(fid,'  %s', Y{n});      %打印向量Y到文本
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see results\\Y.mat  '); 
end
    
fprintf(fid,'\n\n** Vector U (Size: %d x %d) **\n',B_row, 1);
if(B_row<20)
    n=1;
    while n<=source_num
        fprintf(fid,'  %s', U{n});          %打印向量U到文本
        n=n+1;
    end
else
    fprintf(fid,'  This Vector is too large. Please see results\\U.mat  \n'); 
end

save results\C.mat C;           %存储稀疏矩阵C

save results\G.mat G;           %存储稀疏矩阵G

save results\B.mat B;           %存储稀疏矩阵B

save results\LT.mat LT;         %存储稀疏矩阵LT 

X=X';                           %将X向量转为列向量存储
Y=Y';                           %将Y向量转为列向量存储
save results\X.mat X;           %存储向量X
save results\Y.mat Y;           %存储向量Y
save results\U.mat U;           %存储向量U
fprintf('已得到MNA方程各矩阵，保存在result文件夹下。\n');
fclose(fid);

