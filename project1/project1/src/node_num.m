%���������еĽڵ����ֻ�
netlist=fopen('new_netlist');
node_LUT_num=0;			%��ʼ���ڵ���ұ��еĽڵ���ĿΪ0�����ұ����еĽڵ����Ʊ�ʾ�ýڵ��ѱ����ֻ�
line_num=1;

while ~feof(netlist)
	line=fgetl(netlist);                                    %��ȡ�����е�һ��
	line_element=regexp(line,  '(\S)+', 'match');           %�����и���ǿ����ݴ浽line_element��
    
    line_element_end_value=regexp(line_element{end},  '[\d]+[.]*[\d]*', 'match');     %matlab����ʶ��n,m,k�����������������´���
    line_element_end_power=regexp(line_element{end},  '([a-zA-Z])+', 'match');
    
    if isempty(line_element_end_power)
        
    else
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
    

	if (strcmpi(line(1), 'K'))          %����������У������ڵ㴦������Ϊ���е�����û�нڵ���Ϣ
        line_element{4}=str2double(line_element{4});        %������ֵ���ַ�����ʽת��Ϊ������
		net{line_num}=line_element;
		line_num=line_num+1;
		continue;
    end
	     
	node_order=1;
	while node_order<=2                      %���δ���ÿ�ж�����2���ڵ�
		if (strcmpi(line_element{node_order+1}, '0'))       %�����ȫ�ֽڵ㣬��ֱ��ת��Ϊ����ֵ0
			line_element{node_order+1}=0;
            node_order=node_order+1;
			continue;
		end
		if (~node_LUT_num)                                  %����ڵ���ұ�Ϊ�գ����ʼ�������ұ�������һ����0�ڵ������ұ�
            node_LUT_num=1;
            node_LUT{1}=line_element{node_order+1};
            continue
        end
        
		node_seek_num=1;
		while node_seek_num<=node_LUT_num				    %������ڴ����Ľڵ�����ڲ��ұ����ҵ��������ֻ��ýڵ㣬���ֻ���ֵΪ�ýڵ��ڲ��ұ��е����
			if (strcmpi(line_element{node_order+1}, node_LUT{node_seek_num}))
				line_element{node_order+1}=node_seek_num;
                break;
			else
				node_seek_num=node_seek_num+1;
			end
		end
		
		if (node_seek_num>node_LUT_num)						 %������ڴ����Ľڵ㲻�ڲ��ұ��У���ô���ýڵ������ұ���Ȼ�����ֻ��ýڵ㣬���ֻ���ֵΪ�ýڵ��ڲ��ұ��е����
			node_LUT_num=node_LUT_num+1;
			node_LUT{node_LUT_num}=line_element{node_order+1};
			line_element{node_order+1}=node_LUT_num;
        end
        node_order=node_order+1;
	end
	line_element{end}=str2double(line_element{end});         %���ֻ�Ԫ��ֵ
	net{line_num}=line_element;                              %��Ԫ��ֵ�ͽڵ����ֻ�����µ�һ��Ԫ���������ݱ��浽net
	line_num=line_num+1;									 %����һ��Ԫ����������
end
fprintf('节点数字化\n');