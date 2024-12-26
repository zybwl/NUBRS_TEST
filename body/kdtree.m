clc
clear
close all

% ����ά��
% ����kd-tree���������������ά��û���ƣ�ֻ�ǻ���kd-treeֻ������Ϊ2ά����Ч
DATA_DIM = 2;
% ��������С
DATA_SIZE = 20;

data = rand(DATA_SIZE, DATA_DIM);
data = unique(data, 'rows');

% ����kd-treeǰӦ����һ�����ݣ���֤�Է�����Ϊѡȡ����ά�ȷ�ʽ�ĺ�����
% ����ÿ��ά�ȶ���0��1���������˲����ٹ�һ��
kd_tree = kd_tree_build(data);

if DATA_DIM == 2
    figure;
    hold on
    Limit_X = [0, 1];
    Limit_Y = [0, 1];
    plot_kd_tree(gca, kd_tree, Limit_X, Limit_Y);
end

% Ŀ���
target = rand(1, DATA_DIM);
if DATA_DIM == 2
    plot(target(1), target(2), '*');
end

% �Ƚ�kd-tree�����ͱ�����������ʱ
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
    
    assert(sqrt(sum((res_kd - res_simple).^2)) < 0.0000001, 'error��kd-tree�����ͱ������������һ��');
end

disp(['kd-tree������ʱ' num2str(time_kd) '��']);
disp(['����������ʱ' num2str(time_simple) '��']);
