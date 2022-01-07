function output = sparse_matrix_print(sparse_matrix, col, row, fid)
%sparse_matrix_print - Description
%
% Syntax: output = sparse_matrix_print(sparse_matrix, col, row, fid)
%
% Long description
[r,c,d] = find(sparse_matrix);                                                           %return the size of matrix and non-zero data
for i = 1:size(r)                                                          
    fprintf(fid,'(%d,%d)\t\t%d\n ',r(i),c(i),d(i));
end
end