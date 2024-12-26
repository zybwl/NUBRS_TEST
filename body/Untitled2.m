clc;clear;close all;

pts = [
    -6,14,0;
    11,14,0;
    13,15,0;
    25,20,0;
    -17,9,0;
    -9,14,0;
    38,-9,0;
    29,-20,0
    16,-25,0;
    1,-25,0;
    29,-20,0;
    16,-25,0;
    38,9,0;
    38,-7,0;
    27,19,0;
    37,9,0;
    -1,-25,0;
    -19,-13,0;
    -19,-12,0;
    -18,8,0;    
    ];

plot_lines(pts);
hold on

max_error = 5;
x = pts(:,1);  y = pts(:,2);

[newx , ix] = sort(x);
[newy,  iy] = sort(y);

save_lines = sort_all_lines_new(pts, max_error, newx, ix, newy, iy);
save_error = max_error;
while isempty(save_lines) && save_error < 20
    save_error = save_error * 2;
    save_lines =  sort_all_lines_new(pathpts, save_error,  newx, ix, newy, iy); 
end

plot(save_lines(:,1), save_lines(:,2), '-r');

% %% 找到某个点附近可连接的点
% find_pts = [27,19,0];
% plot(find_pts(1), find_pts(2), '*r');
% 
% k1 = findspanindex(newx, find_pts(1), max_error);
% k2 = findspanindex(newy, find_pts(2), max_error);
% 
% min_length = 100;
% last_index = 0;
% for i = 1:length(k1)
%     findindex = ix(k1(i));
%     L = norm(pts(findindex,:) - find_pts);
%     if L < min_length
%         min_length = L;
%         last_index = findindex;
%     end
% end
% 
% for i = 1:length(k2)
%     findindex = ix(k2(i));
%     L = norm(pts(findindex,:) - find_pts);
%     if L < min_length
%         min_length = L;
%         last_index = findindex;
%     end
% end
% 
% plot(pts(last_index,1), pts(last_index,2), '+r');

% nxi = ix(k1);
% nyi = iy(k2);
% 
% p1 = pts(nxi,:);
% p2 = pts(nyi,:);
% plot(p1(:,1), p1(:,2), '*k');
% plot(p2(:,1), p2(:,2), '+k');




