clc;clear ;close all;
[FileName,PathName] = uigetfile('*.igs','Select the Igs-file');
Full_name = strcat(PathName,FileName); 

lineArcCells = getIgsFileCells(Full_name);
segment_n  = length(lineArcCells);

for i = 1:segment_n
    kv = lineArcCells{1,i}.kv;
    cpts = lineArcCells{1,i}.cpts;
    w = lineArcCells{1,i}.w;
    p = lineArcCells{1,i}.p;
    %进行变换处理
    kv = (kv - kv(1,1))/(kv(1,end) - kv(1,1));
    cpts = [cpts(:,1).*w',cpts(:,2).*w',cpts(:,3).*w',  w'];   
end

n = 1000;
u = linspace(0,1,n);
knots{1} = kv;
CtrlPts = cpts';
pts = nurbs_curve_pts(knots , CtrlPts,   u);

plot(pts(1,:), pts(2,:));

