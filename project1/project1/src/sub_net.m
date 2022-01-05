%将子电路映射到全局电路中
old_netlist=fopen(input_net);				%打开旧网表
new_netlist=fopen('new_netlist', 'w');		%打开新网表
quest_num=0;
quest_line=0;
X_num=0;

while ~feof(old_netlist)        %判断是否读到网表结束位置
	line=fgetl(old_netlist);
	
	if (isempty(line))			%判断是否读到空行，若是就马上开始下个循环
		continue;
	end
	
	if (line(1)=='*')			%判断是否读到注释行，若是就马上开始下个循环
		continue;
	end
	
	line_element=regexp(line,'(\S)+', 'match');		%将本行各项非空内容存到line_element中
	
	if (strcmpi(line_element{1}, '.SUBCKT'))		%判断是否进入子电路
        subckt_flag=1;
		continue;
	end
	
	if (strcmpi(line_element{1}, '.ENDS'))			%判断是否读到该子电路的结束部分
		subckt_flag=0;								%若在子电路的结束部分，则标记subckt_flag为0
        continue;
	end
	
	if (subckt_flag)	%如果本行依然是子电路的描述，则保存本行信息
		continue;
	end
	
    switch upper(line(1))		%判断字符串时，用upper函数将字符串都变成大写形式，这样就解决网表不区分大小写的问题
        case{'V', 'I', 'R', 'L', 'C', 'K'}          %如果元件是V,I,R,L.C,K,则直接写入新网表
            fprintf(new_netlist, '%s\n',line);
            continue;
    end
           
	
	if (strcmpi(line_element{1}, '.PROBE'))		    %如果读到被测量，则保存该被测量
        quest_line=quest_line+1;
		quest_num=quest_num+size(line_element,2)-1;
		quest{quest_line}=line_element;
		continue;
    end
	
     %如果提前遇到.end，则终止文件的扫描
    if (strcmpi(line_element{1},'.END'))
        break
    end 
    
    
    
	if (strcmpi(line(1), 'X'))			%读到子电路，则按如下方法将子电路映射到全局网表中
		n=1;
		while n<=subckt_n				%在提取的子电路中寻找当前调用的子电路
			if (strcmpi(line_element{end}, subckt_info{n}{1}{2}))
				break;
			else
				n=n+1;
			end
		end
		
		subckt_node_num=size(line_element,2)-2;   	%被调用子电路的输入输出节点数量
		m=2;%m代表子电路中元件的对应顺序,第二行开始才是真正元件开始的序号
		
		while m<=size(subckt_info{n},2)
			if (strcmpi(subckt_info{n}{m}{1}(1), 'K'))	%如果子电路中有互感，则在全局网表中，子电路中的元件名称统一映射为“元件名_子电路名”，如L1_X1
					fprintf(new_netlist, '%s ', strcat(subckt_info{n}{m}{1},'_',line_element{1}));
                    fprintf(new_netlist, '%s ', strcat(subckt_info{n}{m}{2},'_',line_element{1}));
                    fprintf(new_netlist, '%s ', strcat(subckt_info{n}{m}{3},'_',line_element{1}));
                    fprintf(new_netlist, '%s\n', subckt_info{n}{m}{4});
                    m=m+1;
                    continue
            end
		
                    subckt_node=subckt_info{n}{m}(2:3);
     
            node_order=1;

            while node_order<=2
				if (subckt_node{node_order}=='0')               %该节点是全局节点0，则映射值保持为0                   
                    node_order=node_order+1;
					continue;
				else
					seek_global_node=1;				
					while seek_global_node<=subckt_node_num                                 %该节点不是全局节点0，则扫描该节点是否是此子电路的输入输出节点
						if (strcmpi(subckt_info{n}{m}{node_order+1}, subckt_info{n}{1}{seek_global_node+2}))
                             %strcmpi(子电路节点名称,子电路输入输出节点名称}
							subckt_node{node_order}=line_element{seek_global_node+1};       %该节点是输子电路的入输出节点，则将其映射为对应的外部节点
							break;
						else
							seek_global_node=seek_global_node+1;
						end
                    end
                     %如果没有找到公共节点，那么就是用新的节点名称代替掉
                    if (seek_global_node>subckt_node_num)                                   %该节点不是子电路的输入输出节点，则将其映射为“节点名_子电路名”
						subckt_node{node_order}=strcat(subckt_node{node_order}, '_', line_element{1});
					end
				end
				node_order=node_order+1;
            end		

                fprintf(new_netlist,'%s ',strcat(subckt_info{n}{m}{1},'_',line_element{1}));
                fprintf(new_netlist,'%s ',subckt_node{1});
                fprintf(new_netlist,'%s ',subckt_node{2});
                fprintf(new_netlist,'%s\n',subckt_info{n}{m}{4});
                m=m+1;

        end
	end
end
fprintf('子电路映射到全局电路,新建全局电路网表文件。\n');
fclose(old_netlist);
fclose(new_netlist);