%% 五个点拟合成二次函数抛物线

function  newpts = fit5point(pts)
%     clc;clear;close all;
%     x = 1:5;
%     x = x';
%     y = 1.5 * x.^2 + 3.2 * x + 6 + rand(5,1);
%     plot(x,y);
%     pts = [-11.8698   19.1240
%       -11.5126   19.5199
%       -10.5979   20.1317
%       -10.6047   20.1285
%       -10.6327   20.0710];

    x = pts(:,1); 
    y = pts(:,2);
    n = length(x);
    
%     plot(x,y, '*r');
%     hold on
    
    a = [x.^2 x ones(n,1)];
    b = (a' * a) \ a' * y;
    
    maxx = max(x);
    minx = min(x);
    ox = linspace(minx, maxx, n)';
    a = [ox.^2 ox ones(n,1)];
    newpts = [ox a * b];
    
%     plot(newpts(:,1), newpts(:,2), '-b')
    
    