
clc;clear ;close all;
[FileName,PathName] = uigetfile('*.igs','Select the Igs-file');
Full_name = strcat(PathName,FileName); 

lineArcCells = getIgsFileCells(Full_name);
segment_n  = length(lineArcCells);
lineArcLength = zeros(1,segment_n);

for i = 1:segment_n
    kv = lineArcCells{1,i}.kv;
    cpts = lineArcCells{1,i}.cpts;
    w = lineArcCells{1,i}.w;
    p = lineArcCells{1,i}.p;
    %进行变换处理
    kv = (kv - kv(1,1))/(kv(1,end) - kv(1,1));
    cpts = [cpts(:,1).*w',cpts(:,2).*w', w'];
    num_cpts = size(cpts,1);
    lineArcLength(1,i) = nurbsLength(cpts ,num_cpts , kv,  p , 0 , 1);
    
    % 每个图形都用100个点来显示
    new_points = computer_nurbs_points(cpts, p,kv, 1000);
    plot(new_points(:,1), new_points(:,2));
    hold on
end
axis equal

%求出封闭图形总长
s = sum(lineArcLength);









    
    