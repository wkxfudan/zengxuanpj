%���ӵ�·ӳ�䵽ȫ�ֵ�·��
old_netlist=fopen(input_net);				%�򿪾�����
new_netlist=fopen('new_netlist', 'w');		%��������
quest_num=0;
quest_line=0;
X_num=0;

while ~feof(old_netlist)        %�ж��Ƿ������������λ��
	line=fgetl(old_netlist);
	
	if (isempty(line))			%�ж��Ƿ�������У����Ǿ����Ͽ�ʼ�¸�ѭ��
		continue;
	end
	
	if (line(1)=='*')			%�ж��Ƿ����ע���У����Ǿ����Ͽ�ʼ�¸�ѭ��
		continue;
	end
	
	line_element=regexp(line,'(\S)+', 'match');		%�����и���ǿ����ݴ浽line_element��
	
	if (strcmpi(line_element{1}, '.SUBCKT'))		%�ж��Ƿ�����ӵ�·
        subckt_flag=1;
		continue;
	end
	
	if (strcmpi(line_element{1}, '.ENDS'))			%�ж��Ƿ�������ӵ�·�Ľ�������
		subckt_flag=0;								%�����ӵ�·�Ľ������֣�����subckt_flagΪ0
        continue;
	end
	
	if (subckt_flag)	%���������Ȼ���ӵ�·���������򱣴汾����Ϣ
		continue;
	end
	
    switch upper(line(1))		%�ж��ַ���ʱ����upper�������ַ�������ɴ�д��ʽ�������ͽ�����������ִ�Сд������
        case{'V', 'I', 'R', 'L', 'C', 'K'}          %���Ԫ����V,I,R,L.C,K,��ֱ��д��������
            fprintf(new_netlist, '%s\n',line);
            continue;
    end
           
	
	if (strcmpi(line_element{1}, '.PROBE'))		    %����������������򱣴�ñ�����
        quest_line=quest_line+1;
		quest_num=quest_num+size(line_element,2)-1;
		quest{quest_line}=line_element;
		continue;
    end
	
     %�����ǰ����.end������ֹ�ļ���ɨ��
    if (strcmpi(line_element{1},'.END'))
        break
    end 
    
    
    
	if (strcmpi(line(1), 'X'))			%�����ӵ�·�������·������ӵ�·ӳ�䵽ȫ��������
		n=1;
		while n<=subckt_n				%����ȡ���ӵ�·��Ѱ�ҵ�ǰ���õ��ӵ�·
			if (strcmpi(line_element{end}, subckt_info{n}{1}{2}))
				break;
			else
				n=n+1;
			end
		end
		
		subckt_node_num=size(line_element,2)-2;   	%�������ӵ�·����������ڵ�����
		m=2;%m�����ӵ�·��Ԫ���Ķ�Ӧ˳��,�ڶ��п�ʼ��������Ԫ����ʼ�����
		
		while m<=size(subckt_info{n},2)
			if (strcmpi(subckt_info{n}{m}{1}(1), 'K'))	%����ӵ�·���л��У�����ȫ�������У��ӵ�·�е�Ԫ������ͳһӳ��Ϊ��Ԫ����_�ӵ�·��������L1_X1
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
				if (subckt_node{node_order}=='0')               %�ýڵ���ȫ�ֽڵ�0����ӳ��ֵ����Ϊ0                   
                    node_order=node_order+1;
					continue;
				else
					seek_global_node=1;				
					while seek_global_node<=subckt_node_num                                 %�ýڵ㲻��ȫ�ֽڵ�0����ɨ��ýڵ��Ƿ��Ǵ��ӵ�·����������ڵ�
						if (strcmpi(subckt_info{n}{m}{node_order+1}, subckt_info{n}{1}{seek_global_node+2}))
                             %strcmpi(�ӵ�·�ڵ�����,�ӵ�·��������ڵ�����}
							subckt_node{node_order}=line_element{seek_global_node+1};       %�ýڵ������ӵ�·��������ڵ㣬����ӳ��Ϊ��Ӧ���ⲿ�ڵ�
							break;
						else
							seek_global_node=seek_global_node+1;
						end
                    end
                     %���û���ҵ������ڵ㣬��ô�������µĽڵ����ƴ����
                    if (seek_global_node>subckt_node_num)                                   %�ýڵ㲻���ӵ�·����������ڵ㣬����ӳ��Ϊ���ڵ���_�ӵ�·����
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
fprintf('子电路映射到全局电路，新建全局电路网表文件\n');
fclose(old_netlist);
fclose(new_netlist);