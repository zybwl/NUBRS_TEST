
%% 主要用于调整数据，保证数据不会反复跳跃

clc;clear ;close all;
load('foxiang_data.mat');

n = length(save_cell);
treshold = cos(170/180*pi);

for i = 1: n
% for i = 22
    i
   new_pts = save_cell{i};
   plot(new_pts(:,1), new_pts(:,2), '-r');
   hold on
   save_pts = new_pts;
    
   validindex = false(1, size(new_pts,1));
    for j = 2: size(save_pts,1) - 1
        v1 = save_pts(j,1:2) - save_pts(j-1,1:2);
        v2 = save_pts(j+1,1:2) - save_pts(j,1:2);
        v3 = (v1(1)*v2(1) + v1(2) * v2(2))/norm(v1)/norm(v2);
        if v3 < treshold %&& j ~= 2 && j ~= size(save_pts,1) - 1
            validindex(j) = true;
            plot(new_pts(j,1), new_pts(j,2), '+b');
%             save_pts(j-2:j+2,1:2) = fit5point(save_pts(j-2:j+2,1:2)) ;
        end 
    end
   kk = find(validindex == true);
   
   plot(save_pts(:,1), save_pts(:,2), '-b');
   hold off
%    hold on 
%    pts = new_pts(validindex,:);
%    if size(pts,1) > 0
%         plot(pts(:,1), pts(:,2), '+b');
%    end
%    hold off
   
end