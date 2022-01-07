%打印输出报告文件
X(1:node_LUT_num)=strcat('V(', X(1:node_LUT_num),')');    
X(node_LUT_num+1:C_col_row)=strcat('I(', X(node_LUT_num+1:C_col_row),')');   

fid=fopen(output_file, 'w');

fprintf(fid,'** Matrix C (Size: %d x %d) **\n',C_col_row, C_col_row);
block_matrix_print(C,C_col_row,C_col_row,fid,false);

fprintf(fid,'\n** Matrix G (Size: %d x %d) **\n',G_col_row, G_col_row);      
block_matrix_print(G,G_col_row,G_col_row,fid,true);

fprintf(fid,'\n** Matrix B (Size: %d x %d) **\n',B_col, B_row);      
sparse_matrix_print(B, B_col, B_row, fid);

fprintf(fid,'\n** Matrix LT (Size: %d x %d) **\n',LT_col, LT_row);       
sparse_matrix_print(LT, LT_col, LT_row, fid);

fprintf(fid,'\n** Vector X (Size: %d x %d) **\n',C_col_row, 1);

for i=1:C_col_row
    fprintf(fid,    '    %s', upper(X{i}));    
end


fprintf(fid,'\n\n** Vector Y (Size: %d x %d) **\n',probe_num, 1);
for i=1:probe_num
    fprintf(fid,    '    %s', upper(Y{i}));    
end

    
fprintf(fid,'\n\n** Vector U (Size: %d x %d) **\n',B_row, 1);
for i=1:source_num
    fprintf(fid,    '    %s', upper(U{i}));    
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

