clc
clear
close all

% 数据维度
% 建立kd-tree和最近邻搜索对于维度没限制，只是绘制kd-tree只有数据为2维才有效
DATA_DIM = 2;
% 数据量大小
DATA_SIZE = 20;

data = rand(DATA_SIZE, DATA_DIM);
data = unique(data, 'rows');

% 建立kd-tree前应当归一化数据，保证以方差作为选取划分维度方式的合理性
% 这里每个维度都是0到1的随机数因此不用再归一化
kd_tree = kd_tree_build(data);

if DATA_DIM == 2
    figure;
    hold on
    Limit_X = [0, 1];
    Limit_Y = [0, 1];
    plot_kd_tree(gca, kd_tree, Limit_X, Limit_Y);
end

% 目标点
target = rand(1, DATA_DIM);
if DATA_DIM == 2
    plot(target(1), target(2), '*');
end

% 比较kd-tree搜索和暴力搜索的用时
time_kd = 0;
time_simple = 0;
for i = 1: 10000
    tic
    res_kd = kd_tree_search(kd_tree, target);
    elapsedTime = toc;
    time_kd = time_kd + elapsedTime;
    
    tic
    res_simple = simple_search(data, target);
    elapsedTime = toc;
    time_simple = time_simple + elapsedTime;
    
    assert(sqrt(sum((res_kd - res_simple).^2)) < 0.0000001, 'error：kd-tree搜索和暴力搜索结果不一致');
end

disp(['kd-tree搜索用时' num2str(time_kd) '秒']);
disp(['暴力搜索用时' num2str(time_simple) '秒']);
