close all;
clear all;

benchmarks=fopen('filelist.f');         %打开benchmark文件路径，请在该文件中

while ~feof(benchmarks)                 %读取按行读取benchmark文件
    benchmark   = fgetl(benchmarks);
    if (isempty(line) || benchmark(1)=='#')     %如果是空行和注释行，说明不是一个benchmark文件
        continue;
    end

    %生成文件路径
    bench_file  = fullfile('..', 'benchmark', [benchmark, '.sp']);
    output_dir  = ['../output/', benchmark];

    if ~exist(output_dir,"dir")
        mkdir(output_dir); 
    end    

    output_file = fullfile(output_dir, [benchmark, '.out']);


    sub_cur_rec
    sub_cur_map
    node_num
    matrix_gen
    output

end



