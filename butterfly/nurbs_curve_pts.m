%n_or_uv
function points = nurbs_curve_pts(knots , CtrlPts, n_or_uv)

if numel(n_or_uv) == 1 && n_or_uv > 1   
    xi = linspace(0, 1, n_or_uv);
else
    xi = n_or_uv;
end
Cw = BsplineEval(knots , CtrlPts, {xi});
w = Cw(4, :);
points_w = bsxfun(@rdivide, Cw, w);
points = points_w(1:3,:);