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
cut_n = 500;
figure_array = cell(1,cut_n);
vz_array = linspace(minz + 0.1,  maxz - 0.1, cut_n);
first_n = ceil(cut_n/3);
max_error = 0.1;

tstart = tic;
for k = first_n :cut_n
% for k = 168
%     k 
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
    x = pathpts(:,1);  y = pathpts(:,2);
    [newx , ix] = sort(x);
    [newy,  iy] = sort(y);

    save_lines = sort_all_lines_new(pathpts, max_error, newx, ix, newy, iy);
    save_error = max_error;
    while isempty(save_lines) && save_error < 5
        save_error = save_error * 2;
        save_lines =  sort_all_lines_new(pathpts, save_error,  newx, ix, newy, iy); 
    end
    save_cell{k- first_n + 1} =   save_lines;
end
teclipse = toc(tstart)

for i = 1: cut_n - first_n + 1
   new_pts = save_cell{i};
   if size(new_pts,1) == 0
       kk = first_n + i - 1
       continue;
   end
   plot3(new_pts(:,1), new_pts(:,2), new_pts(:,3), '-r');
   hold on 
end




