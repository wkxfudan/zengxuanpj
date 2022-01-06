%生成各个矩阵
line_num=1;
line_num_total=size(net,2);         %网表描述总个数
node_LUT_num=size(node_LUT,2);      %节点查找表中的总节点数
L_num=0;
V_num=0;
I_num=0;
E_num=0;
H_num=0;


%统计电感、电压源、电流源的数量，用来初始化各矩阵
while line_num<=line_num_total      
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

C_col_row=node_LUT_num+L_num+V_num+E_num+H_num;  %C矩阵的行和列
G_col_row=C_col_row;                          %G矩阵的行和列
B_col=C_col_row;                              %B矩阵的列
B_row=V_num+I_num;                                  %B矩阵的行
LT_col=probe_num;                                %LT矩阵的列
LT_row=C_col_row;                                %LT矩阵的列

C=sparse(C_col_row,C_col_row,0);              %初始化C矩阵，以稀疏矩阵存储
G=sparse(G_col_row,G_col_row,0);              %初始化G矩阵，以稀疏矩阵存储
X=node_LUT;                                         %初始化X向量，以稀疏矩阵存储，只包含电压量，电流量(由独立电压源，VCVS CCVS 电感产生）在之后依次插入
B=sparse(C_col_row,B_row,0);                     %初始化B矩阵，以稀疏矩阵存储
LT=sparse(LT_col,LT_row,0);                      %初始化LT矩阵，以稀疏矩阵存储

line_num=1;         
X_insert_num=0;                                     %表示已经插入X向量的电流量
source_num=0;                                       %表示已经插入U向量的独立源数目
while line_num<=line_num_total
	
	
	switch upper(net{line_num}{1}(1))               %将字符串转化为大写形式比较，以此忽略大小写
		case('R')                                   %电阻处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                 
				node_add=node1+node2;
				G(node_add,node_add)=G(node_add,node_add)+1/value;
			else
				G(node1,node1)=G(node1,node1)+1/value;
				G(node2,node2)=G(node2,node2)+1/value;
				G(node1,node2)=G(node1,node2)-1/value;
				G(node2,node1)=G(node2,node1)-1/value;
			end
		case('C')                                   %电容处理 
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			if(node1==0||node2==0)                  
				node_add=node1+node2;               
				C(node_add,node_add)=C(node_add,node_add)+value;
			else
				C(node1,node1)=C(node1,node1)+value;
				C(node2,node2)=C(node2,node2)+value;
				C(node1,node2)=C(node1,node2)-value;
				C(node2,node1)=C(node2,node1)-value;
			end
		case('L')                                   %电感处理    
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           
			C(node_add,node_add)=value;
			if (node1~=0)                          
				G(node_add,node1)=-1;
				G(node1,node_add)=1;
			end
			
			if (node2~=0)
				G(node_add,node2)=1;
				G(node2,node_add)=-1;
			end
		case('V')                                   %独立电压源处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};         
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};           
			B(node_add,source_num)=1;               
			if (node1~=0)                          
				G(node_add,node1)=1;
				G(node1,node_add)=-1;
			end
			
			if (node2~=0)
				G(node_add,node2)=-1;
				G(node2,node_add)=1;
			end
		case('I')                                   %独立电流源处理  
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            value=net{line_num}{4};
			source_num=source_num+1;
			U{source_num}=net{line_num}{1};       
			if (node1~=0)                        
                B(node1,source)=-1;
			end
			
			if (node2~=0)
				B(node2,source)=1;
			end
		case('K')                                   %互感处理
            value=net{line_num}{4};
			L_order=1;
			while L_order<=2                        
				n=node_LUT_num+1;
				while n<=size(X,2)
					if (strcmpi(net{line_num}{L_order+1},X{n}))
						break
					else
						n=n+1;
					end
				end
				
				if (n<=size(X,2))                            
					L_n(L_order)=n;                 
                else                               
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
					C(node_add,node_add)=net{n}{4};     
					node1=net{n}{2};
					node2=net{n}{3};
					if (node1~=0)
						G(node_add,node1)=-1;
						G(node1,node_add)=1;
					end
					
					if (node2~=0)
						G(node_add,node2)=1;
						G(node2,node_add)=-1;
					end
					X{node_add}=net{n}{1};             
					net{n}{1}='_Ready';                 
					L_n(L_order)=node_add;              
				end
				L_order=L_order+1;                      
			end
			C(L_n(1),L_n(2))=-value*sqrt(C(L_n(1),L_n(1))*C(L_n(2),L_n(2)));       
			C(L_n(2),L_n(1))=C(L_n(1),L_n(2));
        case('E')                                      
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               

			if (node1~=0)                               
				G(node_add,node1)=G(node_add,node1)+1;
				G(node1,node_add)=G(node1,node_add)+1;
			end
			
			if (node2~=0)
				G(node_add,node2)=G(node_add,node2)-1;
				G(node2,node_add)=G(node2,node_add)-1;
            end
            
            if (node3~=0)
				G(node_add,node3)=G(node_add,node3)-value;
			end
			
			if (node4~=0)
				G(node_add,node4)=G(node_add,node4)+value;
            end
            
        case('G')                                       %压控电流源处理
            node1=net{line_num}{2};
            node2=net{line_num}{3};
            node3=net{line_num}{4};
            node4=net{line_num}{5};
            value=net{line_num}{6};
            
			if (node1~=0 && node3~=0)                     
				G(node1,node3)=G(node1,node3)+value;
			end
			
			if (node1~=0 && node4~=0)
				G(node1,node4)=G(node1,node4)-value;
            end
            
            if (node2~=0 && node3~=0)
				G(node2,node3)=G(node2,node3)-value;
			end
			
			if (node2~=0 && node4~=0)
				G(node2,node4)=G(node2,node4)+value;
            end
            
        case('H')                                       %流控电压源处理
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    
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
                X{node_add}=net{n}{1};         
                source_num=source_num+1;
                U{source_num}=net{n}{1};                 
                B(node_add,source_num)=1;               
                if (node1~=0)                            
                    G(node_add,node1)=1;
                    G(node1,node_add)=-1;
                end

                if (node2~=0)
                    G(node_add,node2)=-1;
                    G(node2,node_add)=1;
                end
                V_match=node_add;
                net{n}{1}='_Ready';                     
            end         
            node1=net{line_num}{2};
            node2=net{line_num}{3};        
            value=net{line_num}{5};       
			X_insert_num=X_insert_num+1;
			node_add=node_LUT_num+X_insert_num;
			X{node_add}=net{line_num}{1};               

            if (node1~=0)                               
				G(node1,node_add)=G(node1,node_add)+1;
			end
			
			if (node2~=0)
				G(node2,node_add)=G(node2,node_add)-1;
            end
            
            if (node1~=0 && V_match~=0)
				G(V_match,node1)=G(V_match,node1)+1;
			end
			
			if (node2~=0 && V_match~=0)
				G(V_match,node2)=G(V_match,node2)-1;
            end
            
            if (V_match~=0)
				G(V_match,V_match)=G(V_match,V_match)-value;
            end
            
        case('F')                                       %流控电流源
            n=node_LUT_num+1;
            V_ctrl=net{line_num}{4};                    
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
                if (node1~=0)
                    G(node_add,node1)=1;
                    G(node1,node_add)=-1;
                end

                if (node2~=0)
                    G(node_add,node2)=-1;
                    G(node2,node_add)=1;
                end
                V_match=node_add;
                net{n}{1}='_Ready';
            end         
            node1=net{line_num}{2};            
            node2=net{line_num}{3};
            value=net{line_num}{5};
                      
            if (node1~=0 && V_match~=0)           
				G(node1,V_match)=G(node1,V_match)+value;
			end
			
			if (node2~=0 && V_match~=0)
				G(node2,V_match)=G(node2,V_match)-value;
            end
        
	end
	line_num=line_num+1;
end

probe_i=1;
probe_order=1;
while probe_i<=probe_line 
    probe_n=1;
    while probe_n<=size(probe{probe_line},2)-1                            
        Y{probe_order}=probe{probe_i}{probe_n+1};                 
        probe_node=Y{probe_order}(3:end-1);                         
        if (strcmpi(Y{probe_order}(1), 'V'))                       
            m=1;
            while m<=node_LUT_num
                if (strcmpi(probe_node,X{m}))                   
                    LT(probe_order,m)=1;                            
                    break
                end
                m=m+1;
            end
        else
            if (strcmpi(Y{probe_order}(1), 'I'))                         
                m=node_LUT_num+1;
                while m<=size(X,2)
                    if (strcmpi(probe_node,X{m}))
                        LT(probe_order,m)=1;                      
                        break
                    end
                    m=m+1;
                end
            end
        end
        probe_n=probe_n+1;
        probe_order=probe_order+1;
    end
    probe_i=probe_i+1;
end
fprintf('处理各元件\n');