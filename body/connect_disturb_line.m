clc;clear;close all;
[FileName,PathName] = uigetfile('*.stl','Select stl file');
fullfileName = strcat(PathName,FileName); 

[v,f] = stlread( fullfileName);

% plotquadmesh(v,f)
% 
minx = min(v(:,1)) ;
maxx = max(v(:,1)) ;
miny = min(v(:,2)) ;
maxy = max(v(:,2)) ;
minz = min(v(:,3)) ;
maxz = max(v(:,3)) ;
% vz = -13;
cut_n = 100;
figure_array = cell(1,cut_n);
vz_array = linspace(minz + 1e-9,  maxz - 1e-9, cut_n);

% for k = ceil(cut_n/3):cut_n
%     k
    k = 35;
    vz = vz_array(k);
    pathpts = [];
    for i = 1:size(f,1)
        index = f(i,1:3);
        minz = min(v(index, 3));
        maxz = max(v(index, 3));
        if (maxz >vz && minz < vz )   
            triangle_pts = v(index, :);
            line_pts = triangle_across_surface(triangle_pts, vz);
            if size(line_pts,1) == 2
                pathpts = [pathpts; line_pts];      
            end
        end
    end

% end
figure(1);
pts = pathpts;
for j = 1: 2: size(pts,1)
    plot([pts(j,1) pts(j+1,1)] , [pts(j,2) pts(j+1,2)] , '-k');
    hold on
end
max_error = 0.1;
x = pts(:,1);  y = pts(:,2);

[newx , ix] = sort(x);
[newy,  iy] = sort(y);
n = size(pts,1)/2;
occupy = zeros(1,2*n);

%% 找到某个点附近可连接的点
for j = 1:n
    k = 1;
    while(occupy(k) ~= 0)
        k = k+1;
    end
%     if k == 849
%         kk = 1;
%     end
    
    if mod(k,2) == 0
        twink = k - 1;
    else
        twink = k + 1;
    end
    
    find_pts = pts(k,:);
    k1 = findspanindex(newx, find_pts(1), max_error);
    k2 = findspanindex(newy, find_pts(2), max_error); 
    min_length = 100;
    last_index = 0;
    for i = 1:length(k1)
        findindex = ix(k1(i));
        if findindex == k || findindex == twink || occupy(findindex) > 0
            continue;
        end
        L = norm(pts(findindex,:) - find_pts);
        if L < min_length
            min_length = L;
            last_index = findindex;
        end
    end

    for i = 1:length(k2)
        findindex = iy(k2(i));
        if findindex == k || findindex == twink || occupy(findindex) > 0
            continue;
        end
        L = norm(pts(findindex,:) - find_pts);
        if L < min_length
            min_length = L;
            last_index = findindex;
        end
    end  
    if occupy(last_index) > 0 || occupy(k) > 0
        kk = 1;
    end
    occupy(last_index) = k;
    occupy(k) = last_index;

end

begin_index = 2;
% new_pts = zeros(n+1,3);
new_pts(1,:) = pts(1,:);
kkk = 2;
begin_flag  = 1;
while (begin_index ~= 2 || begin_flag > 0)
    begin_flag = 0;
    now_index = occupy(begin_index);
    new_pts(kkk,:) = (pts(now_index,:) + pts(begin_index,:))/2;
    if mod(now_index,2) == 0
        next_index = now_index - 1;
    else
        next_index = now_index + 1;
    end
    kkk = kkk + 1;
    begin_index = next_index;
end

plot(new_pts(:,1), new_pts(:,2) , '-r');
% for k = 1: size(new_pts,1)
%     plot(new_pts(1:k,1), new_pts(1:k,2) , '-r');
%     hold on
%     pause(0.1);
% end


        





