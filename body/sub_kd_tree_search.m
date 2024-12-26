     % 以当前节点为根节点一直搜索到叶节点
    function index = sub_kd_tree_search(kd_tree, target,index)
        while ~isempty(kd_tree(index).Left_son) || ~isempty(kd_tree(index).Right_son)
            if isempty(kd_tree(index).Left_son)
                index = kd_tree(index).Right_son;
                continue
            end
            if isempty(kd_tree(index).Right_son)
                index = kd_tree(index).Left_son;
                continue
            end
            if target(kd_tree(index).Dim) <= kd_tree(index).Cut
                index = kd_tree(index).Left_son;
            else
                index = kd_tree(index).Right_son;
            end
        end
    end