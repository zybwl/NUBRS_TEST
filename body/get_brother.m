
  % 获取节点的兄弟节点
    function brother_index = get_brother(kd_tree, index)
        brother_index = [];
        father_index = kd_tree(index).Father;
        if isempty(father_index)
            return
        end
        if kd_tree(father_index).Left_son == index
            brother_index = kd_tree(father_index).Right_son;
        else
            brother_index = kd_tree(father_index).Left_son;
        end
    end
% end