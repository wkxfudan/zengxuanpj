%输出各矩阵
line_num=1;
line_num_total=size(net,2);         %网表描述总个数
node_LUT_num=size(node_LUT,2);      %节点查找表中的总节点数
L_num=0;
V_num=0;
I_num=0;
E_num=0;
H_num=0;

while line_num<=line_num_total      %统计电感、电压源、电流源的数量，用来初始化各矩阵
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

C_column_row=node_LUT_num+L_num+V_num+E_num+H_num;  %设置C矩阵的行和列的值
G_column_row=C_column_row;                          %设置C矩阵的行和列的值
B_column=C_column_row;                              %设置B矩阵的行的值
B_row=V_num+I_num;                                  %设置B矩阵的列的值
LT_column=quest_num;                                %设置LT矩阵的行的值
LT_row=C_column_row;                                %设置LT矩阵的列的值

C=sparse(C_column_row,C_column_row,0);              %初始化C矩阵，以稀疏矩阵存储
G=sparse(G_column_row,G_column_row,0);              %初始化G矩阵，以稀疏矩阵存储
X=node_LUT;                                         %初始化X向量，以稀疏矩阵存储，只包含电压量，电流量(由独立电压源，VCVS CCVS 电感产生）在之后依次插入
B=sparse(C_column_row,B_row,0);                     %初始化B矩阵，以稀疏矩阵存储
LT=sparse(LT_column,LT_row,0);                      %初始化LT矩阵，以稀疏矩阵存储

line_num=1;         
X_insert_num=0;                                     %表示已经插入X向量的电流量
source_num=0;                                       %表示已经插入U向量的独立源数目
while line_num<=line_num_total
	
	
	switch upper(net{line_num}{1}(1))               %将字符串转化为大写形式比较，以此忽略大小写
		case('R')                                   %如果元件是电阻，则按以下方法处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                  %更新G矩阵
				node_add=node1+node2;
				G(node_add,node_add)=G(node_add,node_add)+1/value;
			else
				G(node1,node1)=G(node1,node1)+1/value;
				G(node2,node2)=G(node2,node2)+1/value;
				G(node1,node2)=G(node1,node2)-1/value;
				G(node2,node1)=G(node2,node1)-1/value;
			end
		case('C')                                   %如果元件是电容，则按以下方法处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                  %更新C矩阵
				node_add=node1+node2;               
				C(node_add,node_add)=C(node_add,node_add)+value;
			else
				C(node1,node1)=C(node1,node1)+value;
				C(node2,node2)=C(node2,node2)+value;
				C(node1,node2)=C(node1,node2)-value;
				C(node2,node1)=C(node2,node1)-value;
			end
		case('L')                                   %如果元件是电感，则按以下方法处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           %在X向量中插入L上的电流名称（其实插入的是L的元件名，在output.m中会加上电流标签，如I(L1)）
			C(node_add,node_add)=value;
			if (node1==0)                           %更新G矩阵
			
			else
				G(node_add,node1)=-1;
				G(node1,node_add)=1;
			end
			
			if (node2==0)
			
			else
				G(node_add,node2)=1;
				G(node2,node_add)=-1;
			end
		case('V')                                   %如果元件是独立电压源，则按以下方法处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};         %将独立电压源插入到U向量中
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           %在X向量中插入V上的电流名称（其实插入的是V的元件名，在output.m中会加上电流标签，如I(V1)）
			B(node_add,source_num)=1;               %更新B矩阵
			if (node1==0)                           %更新G矩阵
			
			else
				G(node_add,node1)=1;
				G(node1,node_add)=-1;
			end
			
			if (node2==0)
			
			else
				G(node_add,node2)=-1;
				G(node2,node_add)=1;
			end
		case('I')                                   %如果元件是独立电流源，则按以下方法处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};         %将独立电流源插入到U向量中
			if (node1==0)                           %更新B矩阵
			
            else
                B(node1,source)=-1;
			end
			
			if (node2==0)
			
            else
				B(node2,source)=1;
			end
		case('K')                                   %如果元件是互感，则按以下方法处理
            value=net{line_num}{4};
			L_order=1;
			while L_order<=2                        %依次找到产生互感的2个电感的位置
				n=node_LUT_num+1;
				while n<=size(X,2)
					if (strcmpi(net{line_num}{L_order+1},X{n}))
						break
					else
						n=n+1;
					end
				end
				
				if (n<=size(X,2))                   %如果电感已经被处理过，即电感信息已经存入各矩阵中           
					L_n(L_order)=n;                 %保存该电感的位置
                else                                %如果电感还没被处理过，则在未处理过的网表信息中寻找该电感并处理
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
					C(node_add,node_add)=net{n}{4};     %找到电感，更新C矩阵和G矩阵
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
					X{node_add}=net{n}{1};              %由于是电感，因此如之前处理电感的部分相同，要更新X向量中的信息
					net{n}{1}='_Ready';                 %由于搜索到的电感已经被处理，因此标记该电感的网表信息，避免重复处理。在 _Ready标下划线"_"是为了避免当做电阻处理
					L_n(L_order)=node_add;              %保存该电感的位置
				end
				L_order=L_order+1;                      %处理下一个电感
			end
			C(L_n(1),L_n(2))=-value*sqrt(C(L_n(1),L_n(1))*C(L_n(2),L_n(2)));        %根据已得到的2电感位置信息将互感系数更新到C矩阵中
			C(L_n(2),L_n(1))=C(L_n(1),L_n(2));
        case('E')                                       %如果是压控电压源VCVS
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               %讲受控电压源电流信息更新到向量X（其实插入的是E的元件名，在output.m中会加上电流标签，如I(E1)）

			if (node1==0)                               %更新G矩阵
			
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
            
        case('G')                                       %如果是压控电流源VCCS
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
            
			if (node1==0||node3==0)                     %更新G矩阵
			
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
            
        case('H')                                       %如果是流控电压源CCVS
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    %提取产生控制电流的电压源到V_ctrl
            while n<=size(X,2)                          %确定该电压源的位置，如果在X向量中没有找到，说明该电压源的信息还没处理，则在未处理的网表信息中寻找该电压源
                if (strcmpi(V_ctrl,X{n}))
                    break
                else
                    n=n+1;
                end
            end

            if (n<=size(X,2))
                V_match=n;
            else                                        %该电压源的信息还没处理，在未处理的网表信息中寻找该电压源。找到之后，按照之前处理电压源的部分相同的方法处理电压源信息
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
                X{node_add}=net{n}{1};                  %将电压源信息更新到X向量        
                source_num=source_num+1;
                U{source_num}=net{n}{1};                %将电压源信息更新到U向量  
                B(node_add,source_num)=1;               %将电压源信息更新到B矩阵
                if (node1==0)                           %将电压源信息更新到G矩阵 

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
                net{n}{1}='_Ready';                     %标记更新后的电压源，避免之后被处理
            end         
            node1=net{line_num}{2};
            node2=net{line_num}{3};        
            value=net{line_num}{5};       
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               %将受控源的信息更新到X向量

            if (node1==0)                               %将受控源的信息更新到G矩阵
			
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
            
        case('F')                                       %如果是流控电流源CCCS
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    %提取产生控制电流的电压源到V_ctrl
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
            node1=net{line_num}{2};             %找到电压源之后，将受控源的信息更新到各矩阵
            node2=net{line_num}{3};
            value=net{line_num}{5};
                      
            if (node1==0||V_match==0)           %根据CCCS的网表描述更新G矩阵
			
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
        Y{quest_order}=quest{quest_i}{quest_n+1};                   %将待测信息更新到Y向量中
        quest_node=Y{quest_order}(3:end-1);                         %为方便比较，将V()或I()脱去，变成单节点
        if (strcmpi(Y{quest_order}(1), 'V'))                        %如果是待测值是电压，者按如下处理
            m=1;
            while m<=node_LUT_num
                if (strcmpi(quest_node,X{m}))                   
                    LT(quest_order,m)=1;                            %更新LT矩阵
                    break
                end
                m=m+1;
            end
        else
            if (strcmpi(Y{quest_order}(1), 'I'))                    %如果是待测值是电流，者按如下处理           
                m=node_LUT_num+1;
                while m<=size(X,2)
                    if (strcmpi(quest_node,X{m}))
                        LT(quest_order,m)=1;                        %更新LT矩阵
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
fprintf('处理各元件已完成。\n');