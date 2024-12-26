
function [kv, cpts] = fitlinepts2nurbs(lines_pts , fiber_dis)

% fiber_dis = 0.1;
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
lengtharray = sqrt(diff(newx).^2 + diff(newy).^2);
lcumsum = [0 cumsum(lengtharray)];
fitn = 1000;
xyarray = linspace(0,lcumsum(end), fitn);
new_pts = zeros(fitn, 3);
for i = 1:fitn
    findx = xyarray(i);
    index = findspannew( lcumsum, findx);
%     vectxy = [newx(index +1) - newx(index), newy(index + 1) - newy(index)];  
%     onel = sqrt(vectxy(1)^2 + vectxy(2)^2);
%      if onel < 0.05
%         kk = 1;
%     end
    paraml = (findx - lcumsum(index))/(lcumsum(index + 1) - lcumsum(index));
    paramr = (lcumsum(index + 1) - findx)/(lcumsum(index + 1) - lcumsum(index));
    new_pts(i,1:2) = [newx(index) newy(index)] * paramr + [newx(index + 1) newy(index+1)] * paraml;
end

% plot(new_pts(:,1), new_pts(:,2),'-r');

[kv, controls_points] = fitting(new_pts, ceil(fitn/5));
cpts = [controls_points';ones(1,size(controls_points,1))];
