clc;clear;close all;
[FileName,PathName] = uigetfile('*.stl','Select stl file');
fullfileName = strcat(PathName,FileName); 

[v,f] = stlread( fullfileName);

plotquadmesh(v,f)
hold on
% 
minx = min(v(:,1)) ;
maxx = max(v(:,1)) ;
miny = min(v(:,2)) ;
maxy = max(v(:,2)) ;
minz = min(v(:,3)) ;
maxz = max(v(:,3)) ;
% vz = -13;
cut_n = 500;
figure_array = cell(1,cut_n);
vz_array = linspace(minz + 0.1,  maxz - 0.1, cut_n);
first_n = ceil(cut_n/3);
max_error = 0.1;
fiber_dis = 0.1;
tstart = tic;
for k = first_n :cut_n
% for k = 169
    k 
    vz = vz_array(k);
    pathpts = [];
    for i = 1:size(f,1)
        index = f(i,1:3);
        minz = min(v(index, 3));
        maxz = max(v(index, 3));
        if (maxz >=vz && minz <= vz )   
            triangle_pts = v(index, :);
            line_pts = triangle_across_surface(triangle_pts, vz);
            if size(line_pts,1) == 2
                pathpts = [pathpts; line_pts];      
            end
        end
    end
%     x = pathpts(:,1);  y = pathpts(:,2);
%     [newx , ix] = sort(x);
%     [newy,  iy] = sort(y);
    lines_pts = pathpts;
    maxx = max(lines_pts(:,1)) + fiber_dis;
    minx = min(lines_pts(:,1)) - fiber_dis;
    maxy = max(lines_pts(:,2)) + fiber_dis;
    miny = min(lines_pts(:,2)) - fiber_dis;

    nx = ceil((maxx - minx)/fiber_dis) + 1;
    ny = ceil((maxy - miny)/fiber_dis) + 1;
    x_fiber = linspace(minx, maxx, nx);
    y_fiber = linspace(miny, maxy, ny);
%     imdata = false(nx + 1,ny + 1);
    
%     plot_lines(pathpts);
    imdata = transfer_lines2imfigure2( pathpts, fiber_dis );
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
    newz = ones(1,length(newx)) * vz;
    save_lines = [newx; newy; newz];
    plot3(newx, newy,newz, '-r');
    hold on;
    pause(0.2);
      
    save_cell{k- first_n + 1} =   save_lines;
end
teclipse = toc(tstart)

% n = length(save_cell);
% for i = 1: n
%    new_pts = save_cell{i};
%    if size(new_pts,1) == 0
%        kk = first_n + i - 1
%        continue;
%    end
%    plot3(new_pts(1,:), new_pts(2,:), new_pts(3,:), '-r');
%    hold on 
% end
n = length(save_cell);
fx = zeros(n, 500);
fy = zeros(n, 500);
fz = zeros(n, 500);
vx = zeros(n, 500);
vy = zeros(n, 500);
vz = zeros(n, 500);

for k = 1: n
    k
    savepts = save_cell{k};
    newx = savepts(1,:);
    newy = savepts(2,:);
    lengtharray = sqrt(diff(newx).^2 + diff(newy).^2);
    lcumsum = [0 cumsum(lengtharray)];
    fitn = 1000;
    xyarray = linspace(0,lcumsum(end), fitn);
    new_pts = zeros(fitn, 3);
    for i = 1:fitn
        findx = xyarray(i);
        index = findspannew( lcumsum, findx);
        paraml = (findx - lcumsum(index))/(lcumsum(index + 1) - lcumsum(index));
        paramr = (lcumsum(index + 1) - findx)/(lcumsum(index + 1) - lcumsum(index));
        new_pts(i,1:2) = [newx(index) newy(index)] * paramr + [newx(index + 1) newy(index+1)] * paraml;
    end

    [kv, controls_points] = fitting(new_pts, ceil(fitn/5));
    cpts = [controls_points';ones(1,size(controls_points,1))];
    cpts(3,:) = savepts(3,1);
    pts = nurbs_curve_pts({kv} , cpts, 500);
    vel = nurbs_curve_vel({kv} , cpts, 500);
    fx(k,:) = pts(1,:); 
    fy(k,:) = pts(2,:); 
    fz(k,:) = savepts(3,1); 
    vx(k,:) = vel(1,:);
    vy(k,:) = vel(2,:);
    vz(k,:) = vel(3,:);
end
kk = 0;




