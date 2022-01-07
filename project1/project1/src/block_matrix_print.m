function out = block_matrix_print(sparse_matrix, col, row, fid, isfloat)
%block_matrix_print - Description
%
% Syntax: out = block_matrix_print(sparse_matrix, col, row, fid)
%
% Long description
for i = 1:col
    for j = 1:row
        [x,y,z]=find(sparse_matrix(i,j));
        if (isempty(z))
            a = 0;
            fprintf(fid, '%10d',a);
        elseif isfloat
            fprintf(fid, '%10.5f', z(1));
        else
            fprintf(fid, '%10d', z(1));
        end
    end
    fprintf(fid, '\n');
end    

end

