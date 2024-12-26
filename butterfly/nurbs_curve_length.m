%n_or_uv
function L = nurbs_curve_length(knots , CtrlPts, u_s, u_e)

    u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
    v = nurbs_curve_vel(knots , CtrlPts ,  u_v);
    d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);

    L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
    L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));

    if abs(L1 - L2) < 1e-6
        L = L2;
    else
        L = nurbs_curve_length(knots , CtrlPts, u_s , (u_s + u_e)/2) + nurbs_curve_length(knots , CtrlPts, (u_s + u_e)/2 , u_e);  
    end