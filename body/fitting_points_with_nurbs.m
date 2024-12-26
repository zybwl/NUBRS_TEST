
%% ��Ҫ���ڵ������ݣ���֤���ݲ��ᷴ����Ծ

clc;clear ;close all;
load('foxiang_data.mat');

n = length(save_cell);
treshold = cos(170/180*pi);

% for i = 1: n
for i = 22
    i
   new_pts = save_cell{i};
   n = size(new_pts,1);
   plot(new_pts(:,1), new_pts(:,2), '-r');
   hold on
   
   [kv, controls_points] = fitting_points(new_pts , 50);
   cpts = [controls_points';ones(1,size(controls_points,1))];
   
   pts = nurbs_curve_pts({kv} , cpts, 500);
    plot(pts(1,:), pts(2,:), '-b');
   

   hold off
%    hold on 
%    pts = new_pts(validindex,:);
%    if size(pts,1) > 0
%         plot(pts(:,1), pts(:,2), '+b');
%    end
%    hold off
   
end