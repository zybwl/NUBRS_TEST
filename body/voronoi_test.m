% ����100�������
n = 10;
points = rand(n, 2);
 
% ����Voronoiͼ
% [V, C] = voronoin(points);
 
%  for i = 1:length(C)
%      disp(C{i})
%  end
% ����Voronoiͼ
figure;
voronoi(points(:,1), points(:,2));
hold on;
%  
% % ����ԭʼ��
plot(points(:,1), points(:,2), 'r*');
%  
% % ����ͼ������
% axis equal;
% title('Voronoi Diagram');
% xlabel('x');
% ylabel('y');