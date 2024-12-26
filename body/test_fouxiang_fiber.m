%% 用imshow的方式把图形显示出来

clc;clear ;close all;
load('foxiang_data.mat');
n = length(save_cell);
figure(1);

i = 200; 
% for i = 7
    lines_pts = save_cell{i};
    plot(lines_pts(:,1), lines_pts(:,2),'-b');
% end
hold on

fiber_dis = 0.1;
maxx = max(lines_pts(:,1)) + fiber_dis;
minx = min(lines_pts(:,1)) - fiber_dis;
maxy = max(lines_pts(:,2)) + fiber_dis;
miny = min(lines_pts(:,2)) - fiber_dis;
nx = ceil((maxx - minx)/fiber_dis) + 1;
ny = ceil((maxy - miny)/fiber_dis) + 1;
x_fiber = linspace(minx, maxx, nx);
y_fiber = linspace(miny, maxy, ny);
    
imdata = transfer_lines2imfigure1( lines_pts, fiber_dis );

% %% 找到最左下角点
xfirstindex = 2;  yfirstindex = 2;
while ~imdata(xfirstindex, yfirstindex) 
    if yfirstindex < ny
        yfirstindex = yfirstindex + 1;
    elseif xfirstindex < nx
        xfirstindex = xfirstindex + 1;
        yfirstindex = 2;
    else
        xfirstindex = 0;
        yfirstindex = 0;
        break;
    end 
end

firstxyd = [xfirstindex, yfirstindex, 2 , 1];
xyd = firstxyd;
route_array = xyd;
findflag = false;
count = 1;
while ~findflag && count < 10000
    xyd = findnextpoint(imdata, xyd);
    route_array = [route_array;xyd];
    if xyd(1:2) == firstxyd(1:2)
        findflag = true;
    end
    count = count + 1;
end

outindex = find(route_array(:,4) == 1);
newx = x_fiber(route_array(outindex,1)) ;
newy = y_fiber(route_array(outindex,2)) ;
line_length = sum(sqrt(diff(newx).^2 + diff(newy).^2));

new_pts = [newx' newy' zeros(length(newx),1)];
last_pts = [];
for i = 2:length(newx) 
    v = new_pts(i,:) - new_pts(i-1,:);
    L = norm(v);
    if L > 0.5
        divn = ceil(L/0.5);
        divarray = linspace(0, L , divn+1);
        if i ~= 2
            for j = 2:length(divarray)
                add_pts(j,:) = new_pts(i-1,:) + v/L * divarray(j);
                last_pts = [last_pts; add_pts(j,:) ];
            end
        else
            for j = 1:length(divarray)
                add_pts(j,:) = new_pts(i-1,:) + v/L * divarray(j);
                last_pts = [last_pts; add_pts(j,:) ];
            end
        end
    else
        pre_flag  = false;
        if i == 2
            last_pts = new_pts(1,:);
        end
        last_pts = [last_pts; new_pts(i,:)];
    end
end

[kv, controls_points] = fitting(last_pts, 100);
cpts = [controls_points';ones(1,size(controls_points,1))];

pts = nurbs_curve_pts({kv} , cpts, 2000);
plot(pts(1,:), pts(2,:), '-k');






