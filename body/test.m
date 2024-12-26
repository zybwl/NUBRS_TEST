
clc;clear;close all;
numpts = 192;
t = linspace( -pi, pi, numpts+1 )';
t(end) = [];
r = 0.1 + 5*sqrt( cos( 6*t ).^2 + (0.7).^2 );
x = r.*cos(t);
y = r.*sin(t);
ri = randperm(numpts);
x = x(ri);
y = y(ri);

% plot(x,y);


dt = delaunayTriangulation(x,y);
tri = dt(:,:);

V = voronoiDiagram(dt);

V(1,:) = [];
numv = size(V,1);
dt.Points(end+(1:numv),:) = unique(V,'rows');

delEdges = edges(dt);
validx = delEdges(:,1) <= numpts;
validy = delEdges(:,2) <= numpts;
boundaryEdges = delEdges((validx & validy),:)';
xb = x(boundaryEdges);
yb = y(boundaryEdges);
clf
triplot(tri,x,y)
axis equal
hold on
plot(x,y,'*r')
plot(xb,yb,'-r')
xlabel('Curve reconstruction from point cloud','FontWeight','b')
hold off