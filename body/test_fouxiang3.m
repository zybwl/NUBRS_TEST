%% 用imshow的方式把图形显示出来

clc;clear ;close all;
% load('foxiang_data.mat');
load('everylap.mat');
figure(1);
R = 0.5;
[ball_x, ball_y, ball_z] = sphere(25);
ball_x = R * ball_x;   ball_y = R * ball_y;   ball_z = R * ball_z;
% surf(ball_x, ball_y, ball_z)
% hold on
cylinder_r  = 0.2; cylinder_l = 4;
[cylinder_x, cylinder_y, cylinder_z] = cylinder(2);
A = pi/2;
cylinder_x = cylinder_r * cylinder_x;    cylinder_y = cylinder_r * cylinder_y;       cylinder_z = 4 * cylinder_z;
rot_cylinder_x = cylinder_x;
rot_cylinder_y = cos(A) * cylinder_y - sin(A) * cylinder_z;
rot_cylinder_z = sin(A) * cylinder_y + cos(A) * cylinder_z;
% surf(rot_cylinder_x , rot_cylinder_y, rot_cylinder_z);
% axis equal
% kk = 1;
for i = 300:-1:1
    for j = 1:5:500   
        v = [vx(i,j),vy(i,j),vz(i,j)];
        normv = v/ norm(v);
        if normv(2) > 0
            C = 2*pi - acos(normv(1));
        else
            C = acos(normv(1));
        end
        newx = fx * cos(C) - fy * sin(C);
        newy = fx * sin(C) + fy * cos(C);
        mesh(newx,newy,fz);
        hold on
        surf(rot_cylinder_x + newx(i,j) - 2*R ,  rot_cylinder_y + newy(i,j),  rot_cylinder_z + fz(i,j));
        hold on
        surf(ball_x + newx(i,j) - 2*R ,  ball_y + newy(i,j),  ball_z + fz(i,j));
        hold off
        pause(0.2);
    end
end


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






