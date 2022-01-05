close all;
clear all;

benchmarks=fopen('filelist.f');         %打开benchmark文件路径

while ~feof(benchmarks)                 %读取按行读取benchmark文件
    benchmark = fgetl(benchmarks);

    if (isempty(line) || benchmark(1)=='#')     %如果是空行和注释行，说明不是一个benchmark文件
        continue;
    end

    subckt
    sub_net
    node_num
    newnet_mtr
    output

end



