clc;clear;close all;

%第一步画出蝴蝶形状
load('butterfly_data.mat'); 
n  = 4000;
CC = nurbs_curve_pts(knots , CtrlPts, n);

xi = linspace(0, 1, n);
uqKntVect{1} = xi;
w = CtrlPts(4,:);
 
%第二步求出蝴蝶在控制点出的导数
p = 3;
NCtrlPts = size(CtrlPts);
Idx = FindSpan(NCtrlPts(2) , p , uqKntVect{1} , knots{1});
N = DersBasisFuns(Idx, uqKntVect{1}, p , 2, knots{1});
dAu = zeros( p + 1 ,  numel(uqKntVect{1}));
for i = 1 : p + 1
    dAu = dAu + bsxfun(@times, N(:, i , 2)' , CtrlPts(:, Idx - p + i - 1));
end
dw = dAu(4, :);
dCu = dAu - bsxfun(@times, dw , CC);
D = bsxfun(@rdivide, dCu, w);

% ks = 3;
% for j = 1:numel(uqKntVect{1})
%     d = sqrt(D(1,j)^2 + D(2,j)^2);
%     k1 = D(1,j)/d;
%     k2 = D(2,j)/d;
%     plot ([ C(1, j)  C(1,j) + ks * k1]  , [C(2, j)  C(2,j) + ks * k2])
%     hold on
% end

%第三步求出蝴蝶在控制点出的曲率
aAu = zeros( p + 1 ,  numel(uqKntVect{1}));
for i = 1 : p + 1
    aAu = aAu + bsxfun(@times, N(:, i , 3)' , CtrlPts(:, Idx - p + i - 1));
end
aw = aAu(4,:);
aCu = aAu - 2 * bsxfun(@times, dw , D) -  bsxfun(@times, aw , CC);
J = bsxfun(@rdivide, aCu, w);

% curvature = zeros(1,div_n);
% for k = 1:div_n
%     v = D(1:3, k);
%     a = J(1:3, k);
%     curvature(k) = norm(cross(v , a)/norm(v)^3);
% end

v = D(1:3, :);
a = J(1:3, :);
vn = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);
cv = bsxfun(@rdivide, cross(v , a) , vn.^3); 
curvature = sqrt(cv(1,:).^2 + cv(2,:).^2 + cv(3,:).^2);

figure(1)
plot (CC(1, :), CC(2, :), 'Linewidth', 1, 'color', 'k');
hold on
plot(CtrlPts(1, :)./ CtrlPts(4, :) , CtrlPts(2, :)./ CtrlPts(4, :), '.-','MarkerSize',20,'color','r')
hold on
% plot (CC(1, :), CC(2, :), '*','color','b')
% hold on

vip_point_index = curvature > 0.2;
plot (CC(1, vip_point_index), CC(2, vip_point_index), '*','color','b')

figure(2)
kn = linspace(0, 1, numel(uqKntVect{1}));
plot( kn,  curvature);

    





