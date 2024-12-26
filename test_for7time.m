
clc;clear;close all;
% load('computer7_test.mat');

load('xx.mat');

traj_temp = traj_temp.plan();

xyz = zeros(3,292);
for i = 1:292
    traj_temp = traj_temp.interpolation();
    xyz(:,i) = traj_temp.now_point;
end
plot(xyz(1,:) , xyz(2,:))

x = xyz(1,:);
y = xyz(2,:);
n = length(x);
figure(1);
plot(x, y)

vx = 1000*diff(x);
vy = 1000*diff(y);
v = sqrt(vx.^2 + vy.^2); 
figure(2);
plot((1:length(v))/1000, v);

figure(3)
a = 1000 * diff(v);
plot((1:length(a))/1000, a);

figure(4)
jerk = 1000 * diff(a);
plot((1:length(jerk))/1000, jerk);


% A = 1000;
% 
% t_first = compute_7_time(v_max, v_start, v_end, J ,A, L);
% t_sum = sum(t_first);
% 
% v_e = newton_iteration(J ,A , v_end , L, 5*1e-5);
% 
% is_half_cycle = sum(t_first > 0) <= 3;
% if is_half_cycle
%     low = 1;
%     high = 1.2;
%     t_int_ts = floor(t_sum * 1000) / 1000;
% else
%     low = 0.8;
%     high = 1;
%     t_int_ts = ceil(t_sum * 1000) / 1000;
% end
% avg = (low + high) / 2;
% 
% n = 1;
% while (abs(t_sum - t_int_ts) > 1e-6)
%    t = compute_7_time(v_max, v_start, v_end, J * avg ,A, L);
%    t_sum = sum(t);
%    if t_sum > t_int_ts
%        low = avg;
%    else
%        high = avg;
%    end     
%    avg = (low + high) / 2;
%    kkk = abs(t_sum - t_int_ts);
% %    [n, kkk, avg]
%    
% end
% J = avg * J;