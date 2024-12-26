%% ��������ax�ϻ���kd_tree
% ���ƺ���ֻ֧�ֶ�ά����
function plot_kd_tree(ax, kd_tree, Limit_X, Limit_Y)
plot_kd_tree_recurse(1, Limit_X, Limit_Y);

    % �ݹ��Ӻ���
    % ������kd_tree_curΪ���ڵ������
    function plot_kd_tree_recurse(kd_tree_cur, Limit_X_cur, Limit_Y_cur)
        if isempty(kd_tree_cur)
            return
        end
        
        if ~isempty(kd_tree(kd_tree_cur).Dim)
            % ���Ʒָ���
            % �ݹ���������Ļ���
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
        
        % �������ݵ�
        plot(ax, kd_tree(kd_tree_cur).Value(1), kd_tree(kd_tree_cur).Value(2), 'r.');
        text(ax, kd_tree(kd_tree_cur).Value(1)+0.01, kd_tree(kd_tree_cur).Value(2), num2str(kd_tree_cur));
    end
end