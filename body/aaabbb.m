%% 用imshow的方式把图形显示出来

clc;clear ;close all;

lines_pts = [
    -13,-7;
    -10,-8;
    -10,-5;
    -7,-5;
    -7,-8;
    -2,-8;
    -2,-5;
    1,-5;
    1,3;
    -3,2;
    -4,-1;
    -7,-1;
    -6,5;
    1,6;
    0,9;
    -6,8;
    -7,10;
    -11,9;
    -12,7;
    -15,6;
    -14,1;
    -11,0;
    -10,-2;
    -14,-3;
    -13,-7];
    
figure(1);
fiber_dis = 1;
maxx = max(lines_pts(:,1)) + fiber_dis;
minx = min(lines_pts(:,1)) - fiber_dis;
maxy = max(lines_pts(:,2)) + fiber_dis;
miny = min(lines_pts(:,2)) - fiber_dis;

nx = ceil((maxx - minx)/fiber_dis) + 1;
ny = ceil((maxy - miny)/fiber_dis) + 1;

x_fiber = linspace(minx, maxx, nx);
y_fiber = linspace(miny, maxy, ny);

plot_xyfiber(x_fiber, y_fiber);
hold on
for i = 1: size(lines_pts,1) - 1
% for i = 17
    pts = lines_pts(i:i+1,:);
    plot_fiber_net1( pts, x_fiber, y_fiber );
    hold on
    plot(pts(:,1) , pts(:,2), '-r');
    hold on
end

% imdata = transfer_lines2imfigure1( lines_pts, fiber_dis );
imdata = transfer_lines2imfigure1( lines_pts, fiber_dis );

% imdata = transfer_lines2imfigure1( lines_pts, fiber_dis );
% reverse_imdata = imdata';
% reimdata = reverse_imdata(end:-1:1,:);
% figure(2)
% imshow(reimdata);

% 
% direction_and_index = [];
% 
% %% 找到最左下角点
xfirstindex = 2;  yfirstindex = 2;
while ~imdata(xfirstindex, yfirstindex) 
    if yfirstindex < ny
        yfirstindex = yfirstindex + 1;
    elseif xfirstindex
        xfirstindex = xfirstindex + 1;
        yfirstindex = 2;
    else
        xfirstindex = 0;
        yfirstindex = 0;
        break;
    end 
end

firstxyd = [xfirstindex, yfirstindex, 2];
xyd = firstxyd;
route_array = xyd;
findflag = false;
count = 1;
while ~findflag && count < 1000
    xyd = findnextpoint( imdata, xyd);
    route_array = [route_array;xyd];
    if xyd(1:2) == firstxyd(1:2)
        findflag = true;
    end
    count = count + 1;
end

newx = x_fiber(route_array(:,1)) + 0.1;
newy = y_fiber(route_array(:,2)) + 0.1;
plot(newx, newy, '-k');



% 
% if xfirstindex == 0
%     return;
% else
%     if imdata(i - 1,j-1) 
%         direction_and_index = [direction_and_index ; i, j, 2];
%     elseif imdata(i-1,j) 
%         direction_and_index = [direction_and_index ; i, j, 1];
%     elseif imdata(i,j-1)
%         direction_and_index = [direction_and_index ; i, j, 3];
%     else
%         direction_and_index = [direction_and_index ; i, j, 4];
%     end
% end
% 
% 
% 
% for i = 2: nx 
%     for j = 2: ny 
%         sum_squa = imdata(i - 1,j-1) + imdata(i-1,j) + imdata(i,j-1) + imdata(i,j) ;
%         sum_squa1 = imdata(i - 1,j-1) + imdata(i,j);
%         sum_squa2 = imdata(i-1,j)  + imdata(i,j-1);
%         if sum_squa == 1 
%             if imdata(i - 1,j-1) 
%                 direction_and_index = [direction_and_index ; i, j, 2];
%             elseif imdata(i-1,j) 
%                 direction_and_index = [direction_and_index ; i, j, 1];
%             elseif imdata(i,j-1)
%                 direction_and_index = [direction_and_index ; i, j, 3];
%             else
%                 direction_and_index = [direction_and_index ; i, j, 4];
%             end
%         elseif sum_squa == 3 
%             if ~imdata(i - 1,j-1) 
%                 direction_and_index = [direction_and_index ; i, j, 2];
%             elseif ~imdata(i-1,j) 
%                 direction_and_index = [direction_and_index ; i, j, 1];
%             elseif ~imdata(i,j-1)
%                 direction_and_index = [direction_and_index ; i, j, 3];
%             else
%                 direction_and_index = [direction_and_index ; i, j, 4];
%             end         
%         elseif sum_squa1 == 2 
%             if imdata(i - 2, j-1) + imdata(i,j + 1) > 0
%                 direction_and_index = [direction_and_index ; i, j, 3];
%             else
%                 direction_and_index = [direction_and_index ; i, j, 1];
%             end
%         elseif sum_squa2 == 2
%             if imdata(i - 2, j) + imdata(i,j + 1) > 0
%                 direction_and_index = [direction_and_index ; i, j, 2];
%             else
%                 direction_and_index = [direction_and_index ; i, j, 4];
%             end
%         else
%             % do notiong
%         end
%     end
% end
% 
% imdata = transfer_lines2imfigure1( lines_pts, fiber_dis );
% reverse_imdata = imdata';
% reimdata = reverse_imdata(end:-1:1,:);
% figure(2)
% imshow(reimdata);

% plot_xyfiber(x_fiber, y_fiber);



% fiber_dis = 1;
% imdata = transfer_lines2imfigure( lines_pts, fiber_dis );
% 
% reverse_imdata = imdata';
% reimdata = reverse_imdata(end:-1:1,:);
% imshow(reimdata);

% contour = bwperim(reimdata);
% figure
% 
% imshow(contour);


% imshow(reimdata);








