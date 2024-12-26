%% 根据data建立kd_tree
function kd_tree = kd_tree_build(data)
kd_tree = [];
kd_tree_build_recurse(data, []);
    % 递归子函数
    function index_cur = kd_tree_build_recurse(data_cur, index)
        index_cur = [];
        if size(data_cur, 1) == 0
            return
        end
        
        index_cur = length(kd_tree) + 1;
        kd_tree(index_cur).Dim = [];
        kd_tree(index_cur).Cut = [];
        kd_tree(index_cur).Value = [];
        kd_tree(index_cur).Father = index;
        kd_tree(index_cur).Left_son = [];
        kd_tree(index_cur).Right_son = [];
        
        % 选取方差最大的维度进行划分，分割值设置为该维度上的中位数       
        data_var = var(data_cur, 0, 1);
%         a = sum(data_cur,1) / 20;
%         b = data_cur - repmat(a,20,1);
%         c = sum(b.^2,1)/19;
              
        [~, choose_dim] = max(data_var);
        data_cur = sortrows(data_cur, choose_dim);
        kd_tree(index_cur).Dim = choose_dim;
        left_data = data_cur(1: ceil(size(data_cur, 1)/2)-1, :);
        right_data = data_cur(ceil(size(data_cur, 1)/2)+1: end, :);
        kd_tree(index_cur).Value = data_cur(ceil(size(data_cur, 1)/2), :);
        kd_tree(index_cur).Cut = kd_tree(index_cur).Value(choose_dim);
        % 递归进行左右子树的构建
        kd_tree(index_cur).Left_son = kd_tree_build_recurse(left_data, index_cur);
        kd_tree(index_cur).Right_son = kd_tree_build_recurse(right_data, index_cur);
    end
end