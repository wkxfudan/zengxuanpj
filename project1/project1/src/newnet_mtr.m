%���������
line_num=1;
line_num_total=size(net,2);         %���������ܸ���
node_LUT_num=size(node_LUT,2);      %�ڵ���ұ��е��ܽڵ���
L_num=0;
V_num=0;
I_num=0;
E_num=0;
H_num=0;

while line_num<=line_num_total      %ͳ�Ƶ�С���ѹԴ������Դ��������������ʼ��������
	switch upper(net{line_num}{1}(1))
		case('L')
			L_num=L_num+1;
        case('V')
			V_num=V_num+1;
        case('E')
			E_num=E_num+1;
        case('H')
			H_num=H_num+1;
        case('I'),
            I_num=I_num+1;
	end
	
	line_num=line_num+1;
end

C_column_row=node_LUT_num+L_num+V_num+E_num+H_num;  %����C������к��е�ֵ
G_column_row=C_column_row;                          %����C������к��е�ֵ
B_column=C_column_row;                              %����B������е�ֵ
B_row=V_num+I_num;                                  %����B������е�ֵ
LT_column=quest_num;                                %����LT������е�ֵ
LT_row=C_column_row;                                %����LT������е�ֵ

C=sparse(C_column_row,C_column_row,0);              %��ʼ��C������ϡ�����洢
G=sparse(G_column_row,G_column_row,0);              %��ʼ��G������ϡ�����洢
X=node_LUT;                                         %��ʼ��X��������ϡ�����洢��ֻ������ѹ����������(�ɶ�����ѹԴ��VCVS CCVS ��в�������֮�����β���
B=sparse(C_column_row,B_row,0);                     %��ʼ��B������ϡ�����洢
LT=sparse(LT_column,LT_row,0);                      %��ʼ��LT������ϡ�����洢

line_num=1;         
X_insert_num=0;                                     %��ʾ�Ѿ�����X�����ĵ�����
source_num=0;                                       %��ʾ�Ѿ�����U�����Ķ���Դ��Ŀ
while line_num<=line_num_total
	
	
	switch upper(net{line_num}{1}(1))               %���ַ���ת��Ϊ��д��ʽ�Ƚϣ��Դ˺��Դ�Сд
		case('R')                                   %���Ԫ���ǵ��裬�����·�������
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                  %����G����
				node_add=node1+node2;
				G(node_add,node_add)=G(node_add,node_add)+1/value;
			else
				G(node1,node1)=G(node1,node1)+1/value;
				G(node2,node2)=G(node2,node2)+1/value;
				G(node1,node2)=G(node1,node2)-1/value;
				G(node2,node1)=G(node2,node1)-1/value;
			end
		case('C')                                   %���Ԫ���ǵ��ݣ������·�������
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                  %����C����
				node_add=node1+node2;               
				C(node_add,node_add)=C(node_add,node_add)+value;
			else
				C(node1,node1)=C(node1,node1)+value;
				C(node2,node2)=C(node2,node2)+value;
				C(node1,node2)=C(node1,node2)-value;
				C(node2,node1)=C(node2,node1)-value;
			end
		case('L')                                   %���Ԫ���ǵ�У������·�������
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           %��X�����в���L�ϵĵ������ƣ���ʵ�������L��Ԫ��������output.m�л���ϵ�����ǩ����I(L1)��
			C(node_add,node_add)=value;
			if (node1==0)                           %����G����
			
			else
				G(node_add,node1)=-1;
				G(node1,node_add)=1;
			end
			
			if (node2==0)
			
			else
				G(node_add,node2)=1;
				G(node2,node_add)=-1;
			end
		case('V')                                   %���Ԫ���Ƕ�����ѹԴ�������·�������
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};         %��������ѹԴ���뵽U������
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           %��X�����в���V�ϵĵ������ƣ���ʵ�������V��Ԫ��������output.m�л���ϵ�����ǩ����I(V1)��
			B(node_add,source_num)=1;               %����B����
			if (node1==0)                           %����G����
			
			else
				G(node_add,node1)=1;
				G(node1,node_add)=-1;
			end
			
			if (node2==0)
			
			else
				G(node_add,node2)=-1;
				G(node2,node_add)=1;
			end
		case('I')                                   %���Ԫ���Ƕ�������Դ�������·�������
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};         %����������Դ���뵽U������
			if (node1==0)                           %����B����
			
            else
                B(node1,source)=-1;
			end
			
			if (node2==0)
			
            else
				B(node2,source)=1;
			end
		case('K')                                   %���Ԫ���ǻ��У������·�������
            value=net{line_num}{4};
			L_order=1;
			while L_order<=2                        %�����ҵ��������е�2����е�λ��
				n=node_LUT_num+1;
				while n<=size(X,2)
					if (strcmpi(net{line_num}{L_order+1},X{n}))
						break
					else
						n=n+1;
					end
				end
				
				if (n<=size(X,2))                   %�������Ѿ�����������������Ϣ�Ѿ������������           
					L_n(L_order)=n;                 %����õ�е�λ��
                else                                %�����л�û�������������δ�������������Ϣ��Ѱ�Ҹõ�в�����
					X_insert_num=X_insert_num+1;
					node_add=node_LUT_num+X_insert_num;					
					n=line_num+1;
					while n<=line_num_total
						if (strcmp(net{line_num}{L_order+1},net{n}{1}))
							break;
						else
							n=n+1;
						end
					end
					C(node_add,node_add)=net{n}{4};     %�ҵ���У�����C�����G����
					node1=net{n}{2};
					node2=net{n}{3};
					if (node1==0)
			
					else
						G(node_add,node1)=-1;
						G(node1,node_add)=1;
					end
					
					if (node2==0)
					
					else
						G(node_add,node2)=1;
						G(node2,node_add)=-1;
					end
					X{node_add}=net{n}{1};              %�����ǵ�У������֮ǰ�����еĲ�����ͬ��Ҫ����X�����е���Ϣ
					net{n}{1}='_Ready';                 %�����������ĵ���Ѿ���������˱�Ǹõ�е�������Ϣ�������ظ������� _Ready���»���"_"��Ϊ�˱��⵱�����账��
					L_n(L_order)=node_add;              %����õ�е�λ��
				end
				L_order=L_order+1;                      %������һ�����
			end
			C(L_n(1),L_n(2))=-value*sqrt(C(L_n(1),L_n(1))*C(L_n(2),L_n(2)));        %�����ѵõ���2���λ����Ϣ������ϵ�����µ�C������
			C(L_n(2),L_n(1))=C(L_n(1),L_n(2));
        case('E')                                       %�����ѹ�ص�ѹԴVCVS
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               %���ܿص�ѹԴ������Ϣ���µ�����X����ʵ�������E��Ԫ��������output.m�л���ϵ�����ǩ����I(E1)��

			if (node1==0)                               %����G����
			
			else
				G(node_add,node1)=G(node_add,node1)+1;
				G(node1,node_add)=G(node1,node_add)+1;
			end
			
			if (node2==0)
			
			else
				G(node_add,node2)=G(node_add,node2)-1;
				G(node2,node_add)=G(node2,node_add)-1;
            end
            
            if (node3==0)
			
			else
				G(node_add,node3)=G(node_add,node3)-value;
			end
			
			if (node4==0)
			
			else
				G(node_add,node4)=G(node_add,node4)+value;
            end
            
        case('G')                                       %�����ѹ�ص���ԴVCCS
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
            
			if (node1==0||node3==0)                     %����G����
			
			else
				G(node1,node3)=G(node1,node3)+value;
			end
			
			if (node1==0||node4==0)
			
			else
				G(node1,node4)=G(node1,node4)-value;
            end
            
            if (node2==0||node3==0)
			
			else
				G(node2,node3)=G(node2,node3)-value;
			end
			
			if (node2==0||node4==0)
			
			else
				G(node2,node4)=G(node2,node4)+value;
            end
            
        case('H')                                       %��������ص�ѹԴCCVS
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    %��ȡ�������Ƶ����ĵ�ѹԴ��V_ctrl
            while n<=size(X,2)                          %ȷ���õ�ѹԴ��λ�ã������X������û���ҵ���˵���õ�ѹԴ����Ϣ��û��������δ�����������Ϣ��Ѱ�Ҹõ�ѹԴ
                if (strcmpi(V_ctrl,X{n}))
                    break
                else
                    n=n+1;
                end
            end

            if (n<=size(X,2))
                V_match=n;
            else                                        %�õ�ѹԴ����Ϣ��û������δ�����������Ϣ��Ѱ�Ҹõ�ѹԴ���ҵ�֮�󣬰���֮ǰ�����ѹԴ�Ĳ�����ͬ�ķ��������ѹԴ��Ϣ
                X_insert_num=X_insert_num+1;
                node_add=node_LUT_num+X_insert_num;
                n=line_num+1;
                while n<=line_num_total
                    if (strcmpi(V_ctrl,net{n}{1}))
                        break;
                    else
                        n=n+1;
                    end
                end
                node1=net{n}{2};
                node2=net{n}{3};
                value=net{n}{4};          
                X{node_add}=net{n}{1};                  %����ѹԴ��Ϣ���µ�X����        
                source_num=source_num+1;
                U{source_num}=net{n}{1};                %����ѹԴ��Ϣ���µ�U����  
                B(node_add,source_num)=1;               %����ѹԴ��Ϣ���µ�B����
                if (node1==0)                           %����ѹԴ��Ϣ���µ�G���� 

                else
                    G(node_add,node1)=1;
                    G(node1,node_add)=-1;
                end

                if (node2==0)

                else
                    G(node_add,node2)=-1;
                    G(node2,node_add)=1;
                end
                V_match=node_add;
                net{n}{1}='_Ready';                     %��Ǹ��º�ĵ�ѹԴ������֮�󱻴���
            end         
            node1=net{line_num}{2};
            node2=net{line_num}{3};        
            value=net{line_num}{5};       
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               %���ܿ�Դ����Ϣ���µ�X����

            if (node1==0)                               %���ܿ�Դ����Ϣ���µ�G����
			
            else
				G(node1,node_add)=G(node1,node_add)+1;
			end
			
			if (node2==0)
			
            else
				G(node2,node_add)=G(node2,node_add)-1;
            end
            
            if (node1==0||V_match==0)
			
			else
				G(V_match,node1)=G(V_match,node1)+1;
			end
			
			if (node2==0||V_match==0)
			
			else
				G(V_match,node2)=G(V_match,node2)-1;
            end
            
            if (V_match==0)
			
            else
				G(V_match,V_match)=G(V_match,V_match)-value;
            end
            
        case('F')                                       %��������ص���ԴCCCS
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    %��ȡ�������Ƶ����ĵ�ѹԴ��V_ctrl
            while n<=size(X,2)              
                if (strcmpi(V_ctrl,X{n}))
                    break
                else
                    n=n+1;
                end
            end

            if (n<=size(X,2))
                V_match=n;
            else
                X_insert_num=X_insert_num+1;
                node_add=node_LUT_num+X_insert_num;

                n=line_num+1;
                while n<=line_num_total
                    if (strcmpi(V_ctrl,net{n}{1}))
                        break;
                    else
                        n=n+1;
                    end
                end
                node1=net{n}{2};
                node2=net{n}{3};
                value=net{n}{4};
                source_num=source_num+1;
                U{source_num}=net{n}{1};          
                X{node_add}=net{n}{1};
                B(node_add,source_num)=1;
                if (node1==0)

                else
                    G(node_add,node1)=1;
                    G(node1,node_add)=-1;
                end

                if (node2==0)

                else
                    G(node_add,node2)=-1;
                    G(node2,node_add)=1;
                end
                V_match=node_add;
                net{n}{1}='_Ready';
            end         
            node1=net{line_num}{2};             %�ҵ���ѹԴ֮�󣬽��ܿ�Դ����Ϣ���µ�������
            node2=net{line_num}{3};
            value=net{line_num}{5};
                      
            if (node1==0||V_match==0)           %����CCCS��������������G����
			
			else
				G(node1,V_match)=G(node1,V_match)+value;
			end
			
			if (node2==0||V_match==0)
			
			else
				G(node2,V_match)=G(node2,V_match)-value;
            end
        
	end
	line_num=line_num+1;
end

quest_i=1;
quest_order=1;
while quest_i<=quest_line 
    quest_n=1;
    while quest_n<=size(quest{quest_line},2)-1                            
        Y{quest_order}=quest{quest_i}{quest_n+1};                   %��������Ϣ���µ�Y������
        quest_node=Y{quest_order}(3:end-1);                         %Ϊ����Ƚϣ���V()��I()��ȥ����ɵ��ڵ�
        if (strcmpi(Y{quest_order}(1), 'V'))                        %����Ǵ���ֵ�ǵ�ѹ���߰����´���
            m=1;
            while m<=node_LUT_num
                if (strcmpi(quest_node,X{m}))                   
                    LT(quest_order,m)=1;                            %����LT����
                    break
                end
                m=m+1;
            end
        else
            if (strcmpi(Y{quest_order}(1), 'I'))                    %����Ǵ���ֵ�ǵ������߰����´���           
                m=node_LUT_num+1;
                while m<=size(X,2)
                    if (strcmpi(quest_node,X{m}))
                        LT(quest_order,m)=1;                        %����LT����
                        break
                    end
                    m=m+1;
                end
            end
        end
        quest_n=quest_n+1;
        quest_order=quest_order+1;
    end
    quest_i=quest_i+1;
end
fprintf('�����Ԫ������ɡ�\n');