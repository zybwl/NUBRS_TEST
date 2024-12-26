%% 用imshow的方式把图形显示出来

clc;clear;close all;

fiber_dis = 1 ;
maxx = 20;
minx = -20;
maxy = 20;
miny = -20;

nx = ceil((maxx - minx)/fiber_dis) + 1;
ny = ceil((maxy - miny)/fiber_dis) + 1;

x_fiber = linspace(minx, maxx, nx);
y_fiber = linspace(miny, maxy, ny);

plot_xyfiber(x_fiber, y_fiber);
% hold on

n = 0:180;
t = n / 180 * pi;
x = 18 * cos(t);
y = 18 * sin(t);

% choose_index = 45;

for choose_index = 89:181
%     for choose_index = 1:37
    pts = [-0.2 -0.1; x(choose_index) y(choose_index)];
%     plot(pts(:,1) , pts(:,2), '-r');
%     hold on
%      plot_xyfiber(x_fiber, y_fiber);
%      hold on
% 
    plot_fiber_net1( pts, x_fiber, y_fiber);
    hold on

    plot(pts(:,1) , pts(:,2), '-r');
    hold on
    plot_xyfiber(x_fiber, y_fiber);
    
    hold off
end






