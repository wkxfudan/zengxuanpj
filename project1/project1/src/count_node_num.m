%将新网表中的节点数字化
netlist=fopen(mapped_netlist);
node_LUT_num=0;			%初始化节点查找表中的节点数目为0，查找表中有的节点名称表示该节点已被数字化
line_num=1;

while ~feof(netlist)
	line=fgetl(netlist);                                    %读取网表中的一行
	line_element=regexp(line,  '(\S)+', 'match');           %将本行各项非空内容存到line_element中
    line_element_end_value=regexp(line_element{end},  '[\d]+[.]*[\d]*', 'match');     %matlab不能识别n,m,k等数量级，故做如下处理
    line_element_end_power=regexp(line_element{end},  '([a-zA-Z])+', 'match');
    
    if ~isempty(line_element_end_power)
        switch lower(line_element_end_power{1})
            case('g')
            line_element{end}=strcat(line_element_end_value{1},'e9');
            case('meg')
            line_element{end}=strcat(line_element_end_value{1},'e6');
            case('k')
            line_element{end}=strcat(line_element_end_value{1},'e3');
            case('m')
            line_element{end}=strcat(line_element_end_value{1},'e-3');
            case('u')
            line_element{end}=strcat(line_element_end_value{1},'e-6');
            case('n')
            line_element{end}=strcat(line_element_end_value{1},'e-9');
            case('p')
            line_element{end}=strcat(line_element_end_value{1},'e-12');
            case('f')
            line_element{end}=strcat(line_element_end_value{1},'e-15');
            case('a')
            line_element{end}=strcat(line_element_end_value{1},'e-18');
        end
    end
    

	if (strcmpi(line(1), 'K'))          %互感
        line_element{4}=str2double(line_element{4});
		net{line_num}=line_element;
		line_num=line_num+1;
		continue;
    end
	     
	node_order=1;
	while node_order<=2
		if (strcmpi(line_element{node_order+1}, '0'))
			line_element{node_order+1}=0;
            node_order=node_order+1;
			continue;
		end
		if (~node_LUT_num)
            node_LUT_num=1;
            node_LUT{1}=line_element{node_order+1};
            continue
        end
        
		node_seek_num=1;
		while node_seek_num<=node_LUT_num
			if (strcmpi(line_element{node_order+1}, node_LUT{node_seek_num}))
				line_element{node_order+1}=node_seek_num;
                break;
			else
				node_seek_num=node_seek_num+1;
			end
		end
		
		if (node_seek_num>node_LUT_num)	
			node_LUT_num=node_LUT_num+1;
			node_LUT{node_LUT_num}=line_element{node_order+1};
			line_element{node_order+1}=node_LUT_num;
        end
        node_order=node_order+1;
	end
	line_element{end}=str2double(line_element{end});  
	net{line_num}=line_element;    
	line_num=line_num+1;		
end
fprintf('节点数字化\n');