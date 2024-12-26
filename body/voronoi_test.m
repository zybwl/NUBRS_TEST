% 生成100个随机点
n = 10;
points = rand(n, 2);
 
% 计算Voronoi图
% [V, C] = voronoin(points);
 
%  for i = 1:length(C)
%      disp(C{i})
%  end
% 绘制Voronoi图
figure;
voronoi(points(:,1), points(:,2));
hold on;
%  
% % 绘制原始点
plot(points(:,1), points(:,2), 'r*');
%  
% % 设置图形属性
% axis equal;
% title('Voronoi Diagram');
% xlabel('x');
% ylabel('y');