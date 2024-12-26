%% 用imshow的方式把图形显示出来

clc;clear ;close all;
load('foxiang_data.mat');
load('everylap.mat');
n = length(save_cell);
figure(1);
% R = 0.5;
% [ball_x, ball_y, ball_z] = sphere(25);
% ball_x = R * ball_x;   ball_y = R * ball_y;   ball_z = R * ball_z;
% surf(ball_x,ball_y,ball_z);
% R1 = 0.2;
% [cylinder_x, cylinder_y, cylinder_z] = cylinder(2);
% cylinder_x = R1 * cylinder_x;    cylinder_y = R1 * cylinder_y;       cylinder_z = 4 * cylinder_z;
% surf(x,y,10 * z);


fiber_dis = 0.1;
save_pts = cell(1,n);
% n = 3;
fx = zeros(n, 500);
fy = zeros(n, 500);
fz = zeros(n, 500);
vx = zeros(n, 500);
vy = zeros(n, 500);
vz = zeros(n, 500);
% save_l = zeros(1,n-1);
% lastpts = zeros(n, 3,500);
for i = 1:n
    i
    lines_pts = save_cell{i};
%     plot(lines_pts(:,1), lines_pts(:,2),'-b');
%     hold on
    z  = sum(lines_pts(:,3))/ size(lines_pts,1);
    [kv, cpts] = fitlinepts2nurbs(lines_pts , fiber_dis);
    cpts(3,:) = z;
    pts = nurbs_curve_pts({kv} , cpts, 500);
    vel = nurbs_curve_vel({kv} , cpts, 500);
    fx(i,:) = pts(1,:); 
    fy(i,:) = pts(2,:); 
    fz(i,:) = z; 
    vx(i,:) = vel(1,:);
    vy(i,:) = vel(2,:);
    vz(i,:) = vel(3,:);
end

kk = 0;

% surf(fx,fy,fz);
% mesh(fx,fy,fz);

% for i = 1:n
%     newpts = squeeze(lastpts(i,:,:));
%     plot3(newpts(1,:), newpts(2,:), newpts(3,:),'-r');
%     hold on;
% end

% for j = 1:500
%     newpts = lastpts(:,:,j);
%     plot3(newpts(:,1), newpts(:,2), newpts(:,3),'-b');
%     hold on;
% end
    





% plot(pts(1,:), pts(2,:), '-k');






