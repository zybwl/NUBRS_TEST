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

% save_cell = cell(1,26);
% for k = ceil(cut_n/3):cut_n
for k = first_n :cut_n
% for k = 242
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
%     if k - first_n + 1 == 76
%         pts = pathpts;
% %         for i = 1:size(new_pts,1)
%         for j = 1: 2: size(pts,1)
%             plot([pts(j,1) pts(j+1,1)] , [pts(j,2) pts(j+1,2)] , '-k');
%             hold on
%         end
% %         end  
%     end
    save_cell{k- first_n + 1} = sort_all_lines(pathpts, 0.2);    
end
% figure(1);
% pts = save_cell{76};

% for j = 1: 2: size(pts,1)
%     plot([pts(j,1) pts(j+1,1)] , [pts(j,2) pts(j+1,2)] , '-k');
%     hold on
% end
% new_pts = sort_all_lines(pathpts, 0.5); 
% 
% for i = 1:size(new_pts,1)
%     plot(new_pts(1:i,1), new_pts(1:i,2), '-r');
%     pause(0.1);
% end
% plot(pts(797,1), pts(797,2), '*r');

for i = 1: cut_n - first_n + 1
   new_pts = save_cell{i};
   if size(new_pts,1) == 0
       kk = first_n + i - 1
       continue;
   end
   plot3(new_pts(:,1), new_pts(:,2), new_pts(:,3), '-r');
   hold on 
%    plot(new_pts(:,1), new_pts(:,2), '-r');
end




