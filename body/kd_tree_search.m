%% 查找最近邻的值
function res = kd_tree_search(kd_tree, target)
    dist_best = inf;
    node_best = sub_kd_tree_search(kd_tree, target, 1);
    queue = [1, node_best];
    while ~isempty(queue)
        root_cur = queue(1, 1);
        node_cur = queue(1, 2);
        queue(1, :) = [];
        while 1
            dist_cur = sqrt(sum((target - kd_tree(node_cur).Value).^2));
            if dist_cur < dist_best
                dist_best = dist_cur;
                node_best = node_cur;
            end
            if node_cur ~= root_cur
                node_brother = get_brother(kd_tree, node_cur);
                if ~isempty(node_brother)
                    dist_temp = abs(target(kd_tree(kd_tree(node_cur).Father).Dim) - kd_tree(kd_tree(node_cur).Father).Cut);
                    if dist_temp < dist_best
                        queue(end+1, :) = [node_brother, sub_kd_tree_search(kd_tree,target, node_brother)];
                    end
                end
                node_cur = kd_tree(node_cur).Father;
            else
                break
            end
        end
    end
    res = kd_tree(node_best).Value;