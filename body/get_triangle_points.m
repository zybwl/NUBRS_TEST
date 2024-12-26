
clc;clear;close all;
[FileName,PathName] = uigetfile('*.stl','Select stl file');
fullfileName = strcat(PathName,FileName); 

[v,f] = stlread( fullfileName);

maxval = zeros(1,6);
minval = 100 * ones(1,6);
for i = 1:size(f,1)
    n = f(i,:);
    p = v(n,:);
    a = [min(p(:,2)) , max(p(:,2)), min(p(:,3)), max(p(:,3))];
    for j = 1:4
        if a(j) > maxval(2 + j)
            maxval(2 + j) = a(j);
        end
        if a(j) < minval(2 + j)
            minval(2 + j) = a(j);
        end
    end
end

start_val = 0;
mid_val = 0;
max_val = 0;
for i = 1:4
    temp_val = maxval(2+i) - minval(2+ i) ;
    if temp_val > max_val
        max_val = temp_val;
        start_val = minval(2+ i) ;
    end
end

cutvalue = start_val + max_val / 2;

% a = zeros(1,3);
% a(1) = max(v(:,1)) - min(v(:,1)) ;
% a(2) = max(v(:,2)) - min(v(:,2)) ;
% a(3) = max(v(:,3)) - min(v(:,3)) ;
% d = sort(v(:,2));
% 
% [b,c] = max(a);



