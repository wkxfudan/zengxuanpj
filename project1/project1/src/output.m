%打印输出报告文件
X(1:node_LUT_num)=strcat('V(', X(1:node_LUT_num),')');    
X(node_LUT_num+1:C_col_row)=strcat('I(', X(node_LUT_num+1:C_col_row),')');   

fid=fopen(output_file, 'w');

fprintf(fid,'** Matrix C (Size: %d x %d) **\n',C_col_row, C_col_row);
fprintf(fid,'   This Matrix is too large. Please see C.mat \n'); 

fprintf(fid,'\n** Matrix G (Size: %d x %d) **\n',G_col_row, G_col_row);      
fprintf(fid,'   This Matrix is too large. Please see G.mat  \n'); 

fprintf(fid,'\n** Matrix B (Size: %d x %d) **\n',B_col, B_row);      
fprintf(fid,'   This Matrix is too large. Please see B.mat  \n'); 

fprintf(fid,'\n** Matrix LT (Size: %d x %d) **\n',LT_col, LT_row);       
fprintf(fid,'   This Matrix is too large. Please see LT.mat  \n');

fprintf(fid,'\n** Vector X (Size: %d x %d) **\n',C_col_row, 1);
if(C_col_row<20)
    n=1;
    while n<=C_col_row
        fprintf(fid,'  %s', X{n});    
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see X.mat  '); 
end

fprintf(fid,'\n\n** Vector Y (Size: %d x %d) **\n',probe_num, 1);
if(probe_num<20)
    n=1;
    while n<=probe_num
        fprintf(fid,'  %s', Y{n});
        n=n+1;
    end
else
    fprintf(fid,'   This Vector is too large. Please see Y.mat  '); 
end
    
fprintf(fid,'\n\n** Vector U (Size: %d x %d) **\n',B_row, 1);
if(B_row<20)
    n=1;
    while n<=source_num
        fprintf(fid,'  %s', U{n});    
        n=n+1;
    end
else
    fprintf(fid,'  This Vector is too large. Please see U.mat  \n'); 
end

save ([output_dir, '/C.mat'], 'C');      
save ([output_dir, '/G.mat'], 'G');      
save ([output_dir, '/B.mat'], 'B');     
save ([output_dir, '/LT.mat'], 'LT');     


X=X';                       
Y=Y';                 
save ([output_dir, '/X.mat'], 'X');      
save ([output_dir, '/Y.mat'], 'Y');      
save ([output_dir, '/U.mat'], 'U');      
    
fprintf('得到mna方程\n');
fclose(fid);

