%��ȡ�ӵ�·��Ϣ
netlist=fopen(input_net);		%������
subckt_n=0;					    %�ӵ�·��Ŀ
subckt_flag=0;					%����Ƿ���������ӵ�·����������

while ~feof(netlist)			%�ж��Ƿ�����������λ��

	line=fgetl(netlist);		%��ȡ�����е�һ��
	
	if (isempty(line))			%�ж��Ƿ�������У������������У���ʼ�¸�ѭ������ȡ��һ�У������ж�
		continue;
	end
	
	if (line(1)=='*')			%�ж��Ƿ����ע���У������������У���ʼ�¸�ѭ������ȡ��һ�У������ж�
		continue;
	end
	
	 line_element= regexp(line, '\s+', 'split'); %�������ַ���ת����������ɵ�Cell���Կո�Ϊ�ֽ���
     
         
	if (strcmpi(line_element{1}, '.SUBCKT'))		%�ж��Ƿ�����ӵ�·����strcnpi()�������Ժ��Դ�Сд���бȽ�
        subckt_flag=1;								%�������ӵ�·������subckt_flagΪ1
        subckt_n=subckt_n+1;
        i=1;
        subckt_info{subckt_n}{i}=line_element;			%��ȡ�����ӵ�·����	
        i=i+1;
        continue;
	end
	
	if (strcmpi(line_element{1}, '.ENDS'))			%�ж��Ƿ�������ӵ�·�Ľ�������
		subckt_flag=0;								%�����ӵ�·�Ľ������֣�����subckt_flagΪ0
        continue;
	end
	
	if (subckt_flag)								%���������Ȼ���ӵ�·���������򱣴汾����Ϣ
		subckt_info{subckt_n}{i}=line_element; 
        i=i+1;
	end

end
fprintf('�����ӵ�·����ɡ�\n');
fclose(netlist)	;