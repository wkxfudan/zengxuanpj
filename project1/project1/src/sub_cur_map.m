%将子电路映射到全局电路中
old_netlist=fopen(bench_file);													%映射前网表文件
mapped_netlist=fopen(fullfile(output_dir, [benchmark, '.mapped.sp']), 'w');	 	%映射后网表文件
probe_num=0;
probe_line=0;
X_num=0;

while ~feof(old_netlist)        					%判断是否读到网表结束位置
	line=fgetl(old_netlist);
	
	%如果是空行和注释行，跳过
	if(isempty(line) || line(1)=='*')
		continue; 				
	end	

	
	circuit=regexp(line,'(\S)+', 'match');			%将本行非空内容读为电路内容
	
	%子电路判断，如果读到子电路，则不进行处理直接保存电路内容中
	if (strcmpi(circuit{1}, '.SUB_cur'))	
        sub_cur_flag=1;
		continue;	
	elseif (strcmpi(circuit{1}, '.ENDS'))
		sub_cur_flag=0;
        continue;
	elseif (sub_cur_flag)	
		continue;
	end
	
    switch upper(line(1))							%统一网表大小写
        case{'V', 'I', 'R', 'L', 'C', 'K'}          %如果元件是V I R L C K基础元件，则直接写入被映射网表
            fprintf(mapped_netlist, '%s\n',line);
            continue;
    end
           
	
	if (strcmpi(circuit{1}, '.PROBE'))		    	%将被测量量读入电路
        probe_line=probe_line+1;
		probe_num=probe_num+size(circuit,2)-1;
		probe{probe_line}=circuit;
		continue;
    end
	
	%如果电路结束，则结束
	if (strcmpi(circuit{1},'.END'))
        break
    end 
    
    
   %子电路映射过程 
	if (strcmpi(line(1), 'X'))			%读取到子电路
		n=1;
		while n<=sub_cur_n				%在上一个过程中保存的子电路信息中寻找对应子电路
			if (strcmpi(circuit{end}, sub_cur_info{n}{1}{2}))
				break;
			else
				n=n+1;
			end
		end
		
		sub_cur_node_num=size(circuit,2)-2;   	%被调用子电路的输入输出节点数量
		m=2;%m代表子电路中元件的对应顺序,第二行开始才是真正元件开始的序号
		
		while m<=size(sub_cur_info{n},2)
			if (strcmpi(sub_cur_info{n}{m}{1}(1), 'K'))	%如果子电路中有互感，则在全局网表中，子电路中的元件名称统一映射为“元件名_子电路名”，如L1_X1
					fprintf(mapped_netlist, '%s ', strcat(sub_cur_info{n}{m}{1},'_',circuit{1}));
                    fprintf(mapped_netlist, '%s ', strcat(sub_cur_info{n}{m}{2},'_',circuit{1}));
                    fprintf(mapped_netlist, '%s ', strcat(sub_cur_info{n}{m}{3},'_',circuit{1}));
                    fprintf(mapped_netlist, '%s\n', sub_cur_info{n}{m}{4});
                    m=m+1;
                    continue
            end
		
                    sub_cur_node=sub_cur_info{n}{m}(2:3);
     
            node_order=1;

            while node_order<=2
				if (sub_cur_node{node_order}=='0')               %该节点是全局节点0，则映射值保持为0                  
                    node_order=node_order+1;
					continue;
				else
					seek_global_node=1;				
					while seek_global_node<=sub_cur_node_num                                 %该节点不是全局节点0，则扫描该节点是否是此子电路的输入输出节点
						if (strcmpi(sub_cur_info{n}{m}{node_order+1}, sub_cur_info{n}{1}{seek_global_node+2}))
                             %子电路节点名称与子电路输入输出节点名称进行拼接
							sub_cur_node{node_order}=circuit{seek_global_node+1};       	%该节点是输子电路的入输出节点，则将其映射为对应的外部节点
							break;
						else
							seek_global_node=seek_global_node+1;
						end
                    end
                    %如果没有找到公共节点，那么就是用新的节点名称代替掉
					if (seek_global_node>sub_cur_node_num)                                    %该节点不是子电路的输入输出节点，则将其映射为“节点名_子电路名”
						sub_cur_node{node_order}=strcat(sub_cur_node{node_order}, '_', circuit{1});
					end
				end
				node_order=node_order+1;
            end		

                fprintf(mapped_netlist,'%s ',strcat(sub_cur_info{n}{m}{1},'_',circuit{1}));
                fprintf(mapped_netlist,'%s ',sub_cur_node{1});
                fprintf(mapped_netlist,'%s ',sub_cur_node{2});
                fprintf(mapped_netlist,'%s\n',sub_cur_info{n}{m}{4});
                m=m+1;

        end
	end
end
fprintf('子电路映射到全局电路，新建全局电路网表文件\n');
fclose(old_netlist);
fclose(mapped_netlist);