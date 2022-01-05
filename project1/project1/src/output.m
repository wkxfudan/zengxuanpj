
result = [benchmark, '.out']

if ~exist(result)
    mkdir(result); 
end                     %判断有无result文件夹，如果没有则创建。
  
X(1:node_LUT_num)=strcat('V(', X(1:node_LUT_num),')');    %X�����е�ѹ�����ϵ�ѹ���� �� V(node1) V(1)
X(node_LUT_num+1:C_column_row)=strcat('I(', X(node_LUT_num+1:C_column_row),')');   %X�����е��������ϵ������� �� I(Vin) I(L1)


fid=fopen(result, 'w');
fprintf(fid,'** Matrix C (Size: %d x %d) **\n',C_column_row, C_column_row);
    fprintf(fid,'   This Matrix is too large. Please see results\\C.mat \n'); 
fclose(fid);

fid=fopen(result, 'a');
fprintf(fid,'\n** Matrix G (Size: %d x %d) **\n',G_column_row, G_column_row);        %��ӡ����G���ı�
    fprintf(fid,'   This Matrix is too large. Please see results\\G.mat  \n'); 
fclose(fid);

fid=fopen(result, 'a');
fprintf(fid,'\n** Matrix B (Size: %d x %d) **\n',B_column, B_row);       %��ӡ����B���ı�
    fprintf(fid,'   This Matrix is too large. Please see results\\B.mat  \n'); 
fclose(fid);

fid=fopen(result, 'a');
fprintf(fid,'\n** Matrix LT (Size: %d x %d) **\n',LT_column, LT_row);         %��ӡ����LT���ı�
    fprintf(fid,'   This Matrix is too large. Please see results\\LT.mat  \n');
fclose(fid);

fid=fopen(result, 'a');                                                       
fprintf(fid,'\n** Vector X (Size: %d x %d) **\n',C_column_row, 1);
if(C_column_row<20)
    n=1;
    while n<=C_column_row
        fprintf(fid,'  %s', X{n});         %��ӡ����X���ı�
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see results\\X.mat  '); 
end

fprintf(fid,'\n\n** Vector Y (Size: %d x %d) **\n',quest_num, 1);
if(quest_num<20)
    n=1;
    while n<=quest_num
        fprintf(fid,'  %s', Y{n});      %��ӡ����Y���ı�
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see results\\Y.mat  '); 
end
    
fprintf(fid,'\n\n** Vector U (Size: %d x %d) **\n',B_row, 1);
if(B_row<20)
    n=1;
    while n<=source_num
        fprintf(fid,'  %s', U{n});          %��ӡ����U���ı�
        n=n+1;
    end
else
    fprintf(fid,'  This Vector is too large. Please see results\\U.mat  \n'); 
end

save [results, '\C.mat']  C;           %�洢ϡ�����C

save [results, '\G.mat'] G;           %�洢ϡ�����G

save [results, '\B.mat'] B;           %�洢ϡ�����B

save [results, '\LT.mat'] LT;         %�洢ϡ�����LT 

X=X';                           %��X����תΪ�������洢
Y=Y';                           %��Y����תΪ�������洢
save [results, '\X.mat'] X;           %�洢����X
save [results, '\Y.mat'] Y;           %�洢����Y
save [results, '\U.mat'] U;           %�洢����U
fprintf('得到mna方程\n');
fclose(fid);

