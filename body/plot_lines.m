function  plot_lines( pts )
%PLOT_LINES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    for i = 1:2:size(pts,1)
        plot(pts(i:i+1,1), pts(i:i+1,2),'-b');
%         axis([-50,50,-30,30]);
        hold on
    end
end

