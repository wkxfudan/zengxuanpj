close all;
clear all;

benchmark=fopen('filelist.f'); %打开benchmark文件路径


switch (Input)
    case 1 
        input_net='RLC_s3.sp';
        subckt        
        sub_net
        node_num
        newnet_mtr
        output
        
    case 2 
        input_net='Test_0.sp';
        subckt
        sub_net
        node_num
        newnet_mtr
        output
        
    case 3 
        input_net='Tree_l7.sp';
        subckt
        sub_net
        node_num
        newnet_mtr
        output
    case 4 
        input_net='Bus_l12s16.sp';
        subckt
        sub_net
        node_num
        newnet_mtr
        output
end



