clc;clear ;close all;
x = 10 * rand(1,100);
y = 10 * rand(1,100);
% mapshow(x,y,'Marker','+')
xlimit = [0 5];
ylimit = [0  5];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
[xi, yi] = polyxpoly(x, y, x, y);
plot(x,y);
hold on
% plot(xbox, ybox);
% hold on
plot(xi, yi, '+r');

% x1 = x(1:50);
% x2 = x(51:end);
% y1 = y(1:50);
% y2 = y(51:end);
% 
% plot(x1,y1, '-b');
% hold on
% plot(x2,y2,'-r');
% hold on
% 
% [xi, yi] = polyxpoly(x1, y1, x2,y2);
% plot(xi, yi, '+k');
