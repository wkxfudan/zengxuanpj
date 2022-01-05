netlist=fopen(benchmark);		%打开网表benchmark

subckt_n=0;					    %计数子电路数目
subckt_flag=0;					%标记

while ~feof(netlist)			%判断是否读到网表的最后一行

	line=fgetl(netlist);		%读取网表文件的一行
	

	if（isempty(line) || line(1)=='*')
		continue; 				%如果是空行和注释行，跳过
	end
	
	line_element= regexp(line, '\s+', 'split'); 	%以空格为分界线，划分原件
     
         
	if (strcmpi(line_element{1}, '.SUBCKT'))		%
        subckt_flag=1;								%
        subckt_n=subckt_n+1;
        i=1;
        subckt_info{subckt_n}{i}=line_element;			%
        i=i+1;
        continue;
	end
	
	if (strcmpi(line_element{1}, '.ENDS'))			%
		subckt_flag=0;								%
        continue;
	end
	
	if (subckt_flag)								%
		subckt_info{subckt_n}{i}=line_element; 
        i=i+1;
	end

end
fprintf('子电路 <<%s>> 处理完成\n', benchmark);
fclose(netlist)	;