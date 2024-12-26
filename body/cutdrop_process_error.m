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

% error_array = [ 179,190,193,224,265,275,285, ...
%                 293,298,306,311,320,324,325, ... 
%                 326,327,328,329,330,331,338, ...
%                 346,359,367,368,329,330,331, ...
%                 338,346,359,367,368,369,370, ...
%                 371,372,373,374,375,382,395, ...
%                 396,412,430,436,458];
error_array = [ 265,275,285, ...
                293,298,306,311,320,324,325, ... 
                326,327,328,329,330,331,338, ...
                346,359,367,368,329,330,331, ...
                338,346,359,367,368,369,370, ...
                371,372,373,374,375,382,395, ...
                396,412,430,436,458];
    
num = 1;
for k = error_array
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
            else
                kk = 1;
            end
        end
    end
    pts = pathpts;
    plot_lines(pts);
    pts = sort_all_lines(pathpts, 3); 
    plot(pts(:,1), pts(:,2), '-r');
%     pts1 = sort_all_lines1(pathpts, 3); 
%     plot(pts1(:,1), pts1(:,2), '-b');
%     plot3(new_pts(:,1), new_pts(:,2), new_pts(:,3), '-r');
    hold off;
    
%     save_cell{num} = sort_all_lines(pathpts, 0.2);    
    num = num + 1;
    
end



