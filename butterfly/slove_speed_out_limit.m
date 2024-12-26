%% 解决第16个点速度超出的问题

clc;clear ;close all;
%% 每一个分段的程序孤立运算，不需要整到一起

%% 给定系统运行参数

tol = 5*1e-3;
amax = 1000;
jmax = 30000;
vmax = 100;
v_start = 0;
v_end = 0;
ts = 1e-3; %插补周期
kcr = min( [8*tol / ((vmax * ts)^2 + 4 * tol^2), amax/vmax^2, sqrt(jmax/vmax^3)]);

%% 读取曲线的信息
[FileName,PathName] = uigetfile('*.igs','Select the Igs-file');
Full_name = strcat(PathName,FileName); 

lineArcCells = getIgsFileCells(Full_name);
segment_n  = length(lineArcCells);

max_x = max(lineArcCells{1,1}.cpts(:,1)) + 10;
min_x = min(lineArcCells{1,1}.cpts(:,1)) - 10;
max_y = max(lineArcCells{1,1}.cpts(:,2)) + 10;
min_y = min(lineArcCells{1,1}.cpts(:,2)) - 10;
for i = 1:segment_n
    kv = lineArcCells{1,i}.kv;
    cpts = lineArcCells{1,i}.cpts;
    w = lineArcCells{1,i}.w;
    p = lineArcCells{1,i}.p;
    %进行变换处理
    kv = (kv - kv(1,1))/(kv(1,end) - kv(1,1));
    cpts = [cpts(:,1).*w',cpts(:,2).*w',cpts(:,3).*w',  w'];   
end

knots{1} = kv;
CtrlPts = cpts';

%% 采用只给个数的方式求点、导数、加速度
% n  = 1000;
% pts = nurbs_curve_pts(knots , CtrlPts,   n);
% vel = nurbs_curve_vel(knots , CtrlPts ,  n);
% acc = nurbs_curve_acc(knots , CtrlPts ,  n);

%% 采用直接给参数的方式求点、导数、加速度
n = 5000;
u = linspace(0,1,n);
pts = nurbs_curve_pts(knots , CtrlPts,   u);
vel = nurbs_curve_vel(knots , CtrlPts ,  u);
acc = nurbs_curve_acc(knots , CtrlPts ,  u);

%% 求曲率
curvature = nurbs_curve_curvature(vel , acc);
% index = curvature > kcr;

%% 从曲率大于阀值的点中取出关键点的标号
index = [];
% curvature = [curvature(1,end-1) curvature];
for i = 2: length(curvature)-1
    if curvature(i)>=curvature(i-1) && curvature(i)>=curvature(i+1) && curvature(i)>kcr
        index = [index i];
    end
end
if index(1) < 5
    index(1) = 1;
else
    index = [1, index];
end
if abs(index(end) - n) < 5
    index(end) = n;
else
    index =[index, n];
end
critical_u = u(index);

%% 求每个关键点之间的距离
critical_u_n = length(critical_u);
s = zeros(1, critical_u_n - 1);
for i = 1:critical_u_n - 1
    u_s = critical_u(i);
    u_e = critical_u(i + 1);
    s(i) = nurbs_curve_length(knots , CtrlPts, u_s, u_e);
end

%% 给出每个关键点的最大速度
v = zeros(1,critical_u_n);
for i = 1: critical_u_n
    now_index = index(i);
    ki = curvature(now_index);
    v1 = 2/ts * sqrt(2*tol/ki - tol^2);
    v2 = sqrt(amax/ki);
    v3 = (jmax/ki^2)^(1/3);
    v(i) = min([v1,v2,v3, vmax]);
end
v(1) = v_start;
v(end) = v_end;

%% 双向查询，限制速度的最大值
v1 = bidirection_scanning(v,s);

%% 求出每段在插补周期内的移动距离，形成一个超大的数组
i = 16;
vs = v1(i);
ve = v1(i+1);
L = s(i);
[t_sum , s_param, s_delta_error, Jout] = compute_start_stop_time_variable_jerk(amax , jmax , vs,  vmax ,  ve , L);
n = round(t_sum*1000);
s_run = zeros(1,n);
for j = 1:n
    s_run(1,j) = compute_time_to_length1(j  , Jout ,  vs , s_param, s_delta_error);
end
run_s = diff([0 s_run]);

u_div = zeros(1, length(run_s) + 1);
 for j = 1: length(run_s)
    delta_s = run_s(j);
    dsdt_vec = nurbs_curve_vel(knots , CtrlPts ,  u_div(1,j));
    dsdtdt_vec = nurbs_curve_acc(knots , CtrlPts ,  u_div(1,j));
    dtds = 1/norm(dsdt_vec);
    dtdsds = -dot(dsdt_vec, dsdtdt_vec)/ norm(dsdt_vec)^4;     
    u_div(1,j+1) = u_div(1,j) + dtds * delta_s + 0.5 * dtdsds * delta_s^2;  
 end

mov_pts = nurbs_curve_pts(knots , CtrlPts,   u_div);
vx = 1000*diff(mov_pts(1,:));
vy = 1000*diff(mov_pts(2,:));
v = sqrt(vx.^2 + vy.^2);

figure(1)
plot(mov_pts(1, :), mov_pts(2,:), 'Linewidth', 1, 'color', 'r');

figure(2)
plot((1:length(v))/1000, v);







