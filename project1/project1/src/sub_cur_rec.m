%%提取子电路信息并处理
%%
netlist=fopen(bench_file);		%打开网表benchmark

sub_cur_n=0;					    %计数子电路数目
sub_cur_flag=0;					%标记

while ~feof(netlist)			%判断是否读到网表的最后一行
	line=fgetl(netlist);		%读取网表文件的一行

	%如果是空行和注释行，跳过
	if(isempty(line) || line(1)=='*')
		continue; 				
	end

	%以空格为分界线，划分元件，做成向量
	sub_cur= regexp(line, '\s+', 'split'); 	
     
	%判断是否进入子电路，如果进入子电路，则进行标记，并计数
	if (strcmpi(sub_cur{1}, '.SUBCKT'))		
        sub_cur_flag=1;								
        sub_cur_n=sub_cur_n+1;
        i=1;
        sub_cur_info{sub_cur_n}{i}=sub_cur;			
        i=i+1;
        continue;
	end
	
	%判断是否为子电路的结束
	if (strcmpi(sub_cur{1}, '.ENDS'))			
		sub_cur_flag=0;								
        continue;
	end
	
	%如果子电路没有结束，则需要保存该行信息
	if (sub_cur_flag)								
		sub_cur_info{sub_cur_n}{i}=sub_cur; 
        i=i+1;
	end

	%如果电路结束，则结束
    if (strcmpi(sub_cur{1},'.END'))
        break
    end 	

end
fprintf('子电路处理完成\n');
fclose(netlist)	;