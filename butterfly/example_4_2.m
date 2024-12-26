clc;clear;close all;

%% 有理B样条书本中4_2的例子，验证在u=0时的导数和加速度是否正确

%验证求加速度的算法是否正确
knots{1} = [0,0,0,1,1,1];
CtrlPts = [1,0,1;1,1,1;0,2,2]';

xi = 0; % parametric points
Cw = BsplineEval(knots , CtrlPts, {xi});
w = Cw(3, :);
C = bsxfun(@rdivide, Cw, w);

% figure(1)
% plot (C(1, :), C(2, :), 'Linewidth', 1, 'color', 'k');
p = 2;
uqKntVect{1} = 0;
Idx = FindSpan(3 , 2 , uqKntVect{1} , knots{1});
N = DersBasisFuns(Idx, uqKntVect{1}, p , 3, knots{1});
dAu = zeros( p + 1 ,  numel(uqKntVect{1}));
for i = 1 : p + 1
    dAu = dAu + bsxfun(@times, N(:, i , 2)' , CtrlPts(:, Idx - p + i - 1));
end
dw = dAu(3, :);
dCu = dAu - bsxfun(@times, dw , C);
D = bsxfun(@rdivide, dCu, w);

aAu = zeros( p + 1 ,  numel(uqKntVect{1}));
for i = 1 : p + 1
    aAu = aAu + bsxfun(@times, N(:, i , 3)' , CtrlPts(:, Idx - p + i - 1));
end
aw = aAu(3,:);
aCu = aAu - 2 * bsxfun(@times, dw , D) -  bsxfun(@times, aw , C);
J = bsxfun(@rdivide, aCu, w);

