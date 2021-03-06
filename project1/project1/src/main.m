close all;
clear all;

benchmarks=fopen('filelist.f');         %打开benchmark文件路径，请在该文件中

while ~feof(benchmarks)                 %读取按行读取benchmark文件
    clearvars -except benchmarks;
    benchmark   = fgetl(benchmarks);

    if (isempty(benchmarks) || benchmark(1)=='#')     %如果是空行和注释行，说明不是一个benchmark文件
        continue;
    end

    %生成文件路径
    bench_file  = fullfile('..', 'benchmark', [benchmark, '.sp']);
    output_dir  = ['../output/', benchmark];

    if ~exist(output_dir,"dir")
        mkdir(output_dir); 
    end    

    output_file = fullfile(output_dir, [benchmark, '.out']);

    fprintf('开始处理电路 %s.sp \n', benchmark);


    sub_cur_rec
    sub_cur_map
    node_num
    matrix_gen
    output
    fprintf('电路 %s.sp 处理结束\n', benchmark);
    fprintf('--------分隔符---------\n');


end

fclose(benchmarks);


