clc;clear;close all;

[FileName,PathName] = uigetfile('*.igs','Select the Igs-file');
Full_name = strcat(PathName,FileName); 
lineArcCells = getIgsFileCells(Full_name);
kv = lineArcCells{1,1}.kv;
cpts = lineArcCells{1,1}.cpts';
w = lineArcCells{1,1}.w;
p = lineArcCells{1,1}.p;
%进行变换处理
knots{1} = (kv - kv(1,p+1))/ (kv(1,end - p) - kv(1,p+1));
ctrlPts = [cpts(1,:).*w ; cpts(2,:).*w ; cpts(3,:).*w ;  w];  

kcr = 0.4;
u_array = get_curvature_peak(knots , ctrlPts, kcr);
%调节起点和终点
if u_array(1) < 0.01
    u_array(1) = 0;
else
    u_array = [0, u_array];
end
if u_array(end) < 0.99
    u_array(end) = 1;
else
    u_array = [u_array,1];
end

% [L, u_array] = nurbs_curve_length_array(knots , ctrlPts, u_s, u_e ,u_in);
figure(1)
n = 1000;
u = linspace(0,1,n);
pts = nurbs_curve_pts(knots , ctrlPts,   u);
plot(pts(1,:), pts(2,:), '-r');
hold on
xpts = nurbs_curve_pts(knots , ctrlPts,   u_array);
plot(xpts(1,:), xpts(2,:), '*k');

figure(2)
kcr = 0.1;
u_array = get_curvature_peak(knots , ctrlPts, kcr);
%调节起点和终点
if u_array(1) < 0.01
    u_array(1) = 0;
else
    u_array = [0, u_array];
end
if u_array(end) < 0.99
    u_array(end) = 1;
else
    u_array = [u_array,1];
end
u_index = find(diff(u_array)> 0.001) ;
u_array = [0, u_array(u_index + 1)];
plot(pts(1,:), pts(2,:), '-r');
hold on
xpts = nurbs_curve_pts(knots , ctrlPts,   u_array);
plot(xpts(1,:), xpts(2,:), '*b');



% u_v = [0.49851    0.49852    0.49853]
% v = nurbs_curve_vel(knots , ctrlPts ,  u_v);
% a = nurbs_curve_acc(knots , ctrlPts ,  u_v);
% cuv = nurbs_curve_curvature(v , a);