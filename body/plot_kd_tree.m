%% 在坐标区ax上绘制kd_tree
% 绘制函数只支持二维数据
function plot_kd_tree(ax, kd_tree, Limit_X, Limit_Y)
plot_kd_tree_recurse(1, Limit_X, Limit_Y);

    % 递归子函数
    % 绘制以kd_tree_cur为根节点的子树
    function plot_kd_tree_recurse(kd_tree_cur, Limit_X_cur, Limit_Y_cur)
        if isempty(kd_tree_cur)
            return
        end
        
        if ~isempty(kd_tree(kd_tree_cur).Dim)
            % 绘制分割线
            % 递归进行子树的绘制
            if kd_tree(kd_tree_cur).Dim == 1
                plot(ax, [kd_tree(kd_tree_cur).Cut, kd_tree(kd_tree_cur).Cut], Limit_Y_cur, 'k-');
                plot_kd_tree_recurse(kd_tree(kd_tree_cur).Left_son, [Limit_X_cur(1), kd_tree(kd_tree_cur).Cut], Limit_Y_cur);
                plot_kd_tree_recurse(kd_tree(kd_tree_cur).Right_son, [kd_tree(kd_tree_cur).Cut, Limit_X_cur(2)], Limit_Y_cur);
            end
            if kd_tree(kd_tree_cur).Dim == 2
                plot(ax, Limit_X_cur, [kd_tree(kd_tree_cur).Cut, kd_tree(kd_tree_cur).Cut], 'k-');
                plot_kd_tree_recurse(kd_tree(kd_tree_cur).Left_son, Limit_X_cur, [Limit_Y_cur(1), kd_tree(kd_tree_cur).Cut]);
                plot_kd_tree_recurse(kd_tree(kd_tree_cur).Right_son, Limit_X_cur, [kd_tree(kd_tree_cur).Cut, Limit_Y_cur(2)]);
            end
        end
        
        % 绘制数据点
        plot(ax, kd_tree(kd_tree_cur).Value(1), kd_tree(kd_tree_cur).Value(2), 'r.');
        text(ax, kd_tree(kd_tree_cur).Value(1)+0.01, kd_tree(kd_tree_cur).Value(2), num2str(kd_tree_cur));
    end
end