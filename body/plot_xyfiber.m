function plot_xyfiber( x_fiber, y_fiber)
%PLOT_XYFIBER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
    for kx = x_fiber
        plot([kx kx], [y_fiber(1) y_fiber(end)],' -b');
        hold on
    end

    for ky = y_fiber
        plot([x_fiber(1), x_fiber(end)], [ky ky],' -k');
        hold on
    end
end

