%n_or_uv
function [L , u_array] = nurbs_curve_length_array(knots , CtrlPts, u_s, u_e ,u_in)

    u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
    v = nurbs_curve_vel(knots , CtrlPts ,  u_v);
    d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);

    L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
    L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));

    if abs(L1 - L2) < 1e-6
        L = L2;
        u_array = [u_in, (u_s + u_e)/2];
    else
        [L1, u_array_begin] = nurbs_curve_length_array(knots , CtrlPts, u_s , (u_s + u_e)/2, u_in) ;
        [L2, u_array_end] = nurbs_curve_length_array(knots , CtrlPts, (u_s + u_e)/2 , u_e, u_in);  
        L = L1 + L2;
        u_array = [u_array_begin, u_array_end];
    end