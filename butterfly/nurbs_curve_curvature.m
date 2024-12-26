%求速度
function curvature = nurbs_curve_curvature(knots , CtrlPts ,  n_or_uv)

if numel(n_or_uv) == 1 && n_or_uv > 1   
    knt_cell{1} = linspace(0, 1, n_or_uv);
    n = n_or_uv;
else
    knt_cell{1} = n_or_uv;
    n = numel(n_or_uv);
end
NCtrlPts = size(CtrlPts);
p = numel(knots{1}) - NCtrlPts(2) - 1;
Idx = FindSpan(NCtrlPts(2) , p , knt_cell{1} , knots{1});
N = DersBasisFuns(Idx, knt_cell{1} , p , 2, knots{1});
%先求原始点是多少
Cw = zeros( p + 1 ,  n);
for i = 1 : p + 1
    Cw = Cw + bsxfun(@times, N(:, i , 1)' , CtrlPts(:, Idx - p + i - 1));
end
w = Cw(4, :);
pts = bsxfun(@rdivide, Cw, w);

%再求原始点基础上的导数
Dw = zeros( p + 1 ,  n);
for i = 1 : p + 1
    Dw = Dw + bsxfun(@times, N(:, i , 2)' , CtrlPts(:, Idx - p + i - 1));
end
w1 = Dw(4, :);
velw = Dw - bsxfun(@times, w1 , pts);
vel = bsxfun(@rdivide, velw , w);
v = vel(1:3,:);

%在求二阶导数是多少
Aw = zeros( p + 1 ,  n);
for i = 1 : p + 1
    Aw = Aw + bsxfun(@times, N(:, i , 3)' , CtrlPts(:, Idx - p + i - 1));
end
w2 = Aw(4,:);
accw = Aw - 2 * bsxfun(@times, w1 , vel) -  bsxfun(@times, w2 , pts);
acc = bsxfun(@rdivide, accw, w);
a = acc(1:3,:);

vn = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);
cv = bsxfun(@rdivide, cross(v , a) , vn.^3); 
curvature = sqrt(cv(1,:).^2 + cv(2,:).^2 + cv(3,:).^2);