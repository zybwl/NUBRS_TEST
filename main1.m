clc;clear ;close all;

%% (1) 给定系统运行参数
vm = 500;
am = 1000;
jm = 30000;
ts = 1e-3; %插补周期
ce = 5*1e-6;
v_start = 0;
v_end = 0;

%% (2) 读取曲线的信息
[FileName,PathName] = uigetfile('*.igs','Select the Igs-file');
Full_name = strcat(PathName,FileName); 

pathParamCells = getIgsFileCells(Full_name);
path_num  = length(pathParamCells);

%% (3) 调整曲线的顺序
path_bgn_index = find_index(pathParamCells , 0);
path_end_index = find_index(pathParamCells , 1);
path_index = [path_bgn_index(1,end:-1:2) path_end_index];
% path_index = 1;

several_paths = cell(1,path_num);
kconstraint = [vm,am,jm];
itp = interpolation(ts);

%% 找出关键节点，并进行分段
v_next_start = 0;
% path_num = 1;
all_length = 0;
for i = 1:path_num
    one_nurbs = pathParamCells{1,abs(path_index(i))};
    if path_index(i) < 0
        one_nurbs.cpts = one_nurbs.cpts(:, end:-1:1);
        one_nurbs.kv = 1 - one_nurbs.kv(end:-1:1);
    end
    one_path = path(one_nurbs.cpts, one_nurbs.kv);
    
    critical_u = one_path.divCurveToSegments(vm, am, jm, ts, ce);
    for j = 1: length(critical_u)-1   
        us = critical_u(j);
        ue = critical_u(j + 1);
        new_path = path(one_nurbs.cpts, one_nurbs.kv , us , ue);
        all_length = all_length + new_path.getTotalLength();
        onetraj = trajectory(new_path,kconstraint, ts, ce);
        if i == 1 && j == 1
            onetraj.vs = v_start;
        else
            now_tangent = new_path.getBeginTangent();
            if norm(now_tangent - pre_tangent) > 1
                cos_alpha = dot(pre_tangent,now_tangent)  / norm(pre_tangent) / norm(now_tangent); 
                cos_half_alpha = sqrt((1 + cos_alpha) / 2);
                R = ce * cos_half_alpha / (1 - cos_half_alpha);
                vc = sqrt( am * R);
                sin_half_alpha = sqrt((1 - cos_alpha) / 2);
                vt = am * ts / sin_half_alpha;
                onetraj.vs = min([v_next_start, vc, vt]); 
            else
                onetraj.vs = v_next_start; 
            end    
            if i== path_num && j == length(critical_u) - 1
                onetraj.ve = v_end; 
            end
        end    
        itp = itp.addTraj(onetraj);
        pre_tangent = new_path.getEndTangent();
        v_next_start = onetraj.ve;   
    end
end

%% 提前规划，双向前瞻
itp = itp.plan();
itp_n = round(itp.tsum / ts);
ksp = zeros(3, itp_n);
run_flag = 1;
n = 1;
%% 插补
while(1)
    itp = itp.run();
    flag = itp.isFinished();
    if flag
        break;
    else
%         if n == 1123
%             kkk = 1;
%         end
        ksp(:,n) = itp.now_point; 
        n = n+ 1;
    end   
end

x = ksp(1,:);
y = ksp(2,:);
n = length(x);
figure(1);
plot(x, y)
title('原始曲线');
axis equal

vx = 1000*diff(x);
vy = 1000*diff(y);
v = sqrt(vx.^2 + vy.^2); 
figure(2);
plot((1:length(v))/1000, v);
title('速度曲线');

figure(3)
a = 1000 * diff(v);
plot((1:length(a))/1000, a);
title('加速度曲线');

figure(4)
jerk = 1000 * diff(a);
plot((1:length(jerk))/1000, jerk);
title('加加速度曲线');









