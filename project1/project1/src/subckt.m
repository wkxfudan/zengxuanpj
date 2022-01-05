%提取子电路信息
netlist=fopen(input_net);		%打开网表
subckt_n=0;					    %子电路数目
subckt_flag=0;					%标记是否在网表的子电路描述段落中

while ~feof(netlist)			%判断是否读到网表结束位置

	line=fgetl(netlist);		%读取网表中的一行
	
	if (isempty(line))			%判断是否读到空行，若是跳过该行，开始下个循环，读取下一行，进行判断
		continue;
	end
	
	if (line(1)=='*')			%判断是否读到注释行，若是跳过该行，开始下个循环，读取下一行，进行判断
		continue;
	end
	
	 line_element= regexp(line, '\s+', 'split'); %将该行字符串转换成数组组成的Cell，以空格为分界线
     
         
	if (strcmpi(line_element{1}, '.SUBCKT'))		%判断是否进入子电路，用strcnpi()函数可以忽略大小写进行比较
        subckt_flag=1;								%若进入子电路，则标记subckt_flag为1
        subckt_n=subckt_n+1;
        i=1;
        subckt_info{subckt_n}{i}=line_element;			%存取本行子电路描述	
        i=i+1;
        continue;
	end
	
	if (strcmpi(line_element{1}, '.ENDS'))			%判断是否读到该子电路的结束部分
		subckt_flag=0;								%若在子电路的结束部分，则标记subckt_flag为0
        continue;
	end
	
	if (subckt_flag)								%如果本行依然是子电路的描述，则保存本行信息
		subckt_info{subckt_n}{i}=line_element; 
        i=i+1;
	end

end
fprintf('处理子电路已完成。\n');
fclose(netlist)	;