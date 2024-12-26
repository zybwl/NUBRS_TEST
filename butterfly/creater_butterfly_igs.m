clc;clear;close all;

load('butterfly_data.mat'); 

w = CtrlPts(4,:);
cpts = bsxfun(@rdivide, CtrlPts(1:3,:) , w);
kv = knots{1};

cpts_num = size(cpts,2) - 1;
begin_str = sprintf('126,%d,3,1,1,0,0',cpts_num);

kv_str = '';
for i = 1:length(kv)
    kv_str = sprintf('%s,%.4fD0',kv_str,  kv(i));
end
% bbb = strsplit(kv_str, ',')

w_str = '';
for i = 1:length(w)
    w_str = sprintf('%s,%.1fD0',w_str,  w(i));
end

cpts_str = '';
for i = 1:length(w)
    cpts_str = sprintf('%s,%.6fD0,%.6fD0,%.6fD0',cpts_str, cpts(1,i), cpts(2,i), cpts(3,i));
end

end_str = ',0.0D0,1.0D0,0.0D0,0.0D0,1.0D0';

last_str = [begin_str  kv_str  w_str  cpts_str  end_str];

data_cell = strsplit(last_str, ',');

line_rem = 5;
line_str = '';
sum_l = 0;
for i = 1: length(data_cell)
    sum_l = sum_l + length(data_cell{i})+ 1;
    if sum_l < 64
        line_str = sprintf('%s%s,', line_str, data_cell{i});
    else
        line_str = sprintf('%s    0000009P     %d\n', line_str, line_rem);  
        line_str = sprintf('%s%s,', line_str, data_cell{i});
        sum_l = length(data_cell{i})+ 1;
        line_rem = line_rem + 1;
    end 
end
line_str(end) = ';';
line_str = sprintf('%s               0000009P     %d\n', line_str, line_rem);  
line_str
