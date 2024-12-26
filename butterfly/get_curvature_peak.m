function  u_array = get_curvature_peak(kv , CtrlPts, kcr , u_s, u_e, u_in)

% persistent count;
% 
% if isempty(count)
%     count = 1
% else
%     count = count + 1
% end
if nargin < 4
    u_s = 0;
    u_e = 1;
    u_in = [];
end

u_v = [u_s , (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e];
v = nurbs_curve_vel(kv , CtrlPts ,  u_v);
d = sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2);

L1 = (u_e - u_s)/6 * (d(1) + 4 * d(3) + d(5));
L2 = (u_e - u_s)/12 * (d(1) + 4*d(2) + 2*d(3) + 4*d(4) + d(5));
zero_eps = 1e-9;

% 第二个条件，防止圆的长度算不准，因为圆的这几个导数值都一样
if abs(L1 - L2) < 1e-6 && abs((u_s + u_e)/2 - 0.5) > 1e-6
    if u_s > 1e-6 && u_e < 1 - 1e-6
        u_ts = [u_s - 1e-6 ,u_s, (3*u_s + u_e)/4, (u_s + u_e)/2, (u_s + 3*u_e)/4, u_e , u_e + 1e-6];
    else
        u_array = u_in;
        return;
    end
    cuv = nurbs_curve_curvature(kv , CtrlPts ,  u_ts);    
    
    condition1 = cuv(2:6) > kcr;
    condition2 = (cuv(2:6) - cuv(1:5))>zero_eps;
    condition3 = (cuv(2:6) - cuv(3:7))>zero_eps;
    condition = condition1 & condition2 & condition3;
    satisfied_index = find(condition > 0, 1);
    if ~isempty(satisfied_index)
%         kk = 0;
        u_array = [ u_in, u_ts(satisfied_index + 1)];
    else
        u_array = u_in;
    end
    
        
%     if cuv(2) > kcr && (cuv(2)- cuv(1)) > zero_eps && (cuv(2)- cuv(3)) > zero_eps      
%             u_array = [u_in, u_s];
%     elseif cuv(3) > kcr && (cuv(3)- cuv(2)) > zero_eps && (cuv(3)- cuv(4)) > zero_eps
%          u_array = [u_in, (3*u_s + u_e)/4];
%     elseif cuv(4) > kcr && (cuv(4)- cuv(3)) > zero_eps && (cuv(4)- cuv(5)) > zero_eps
%          u_array = [u_in, (u_s + u_e)/2];  
%     elseif cuv(5) > kcr && (cuv(5)- cuv(4)) > zero_eps && (cuv(5)- cuv(6)) > zero_eps
%          u_array = [u_in, (u_s + 3*u_e)/4];
%     elseif cuv(6) > kcr && (cuv(6)- cuv(5)) > zero_eps && (cuv(6)- cuv(7)) > zero_eps
%          u_array = [u_in, u_e];
%     else
%         u_array = u_in;
%     end
%     if ~isempty(u_array)
%         if u_array(end) < 0.01
%              u_array = [u_in, 0];
%         elseif u_array(end) > 0.99
%              u_array = [u_in, 1];
%         end  
%     end
else
    u_array_begin = get_curvature_peak(kv , CtrlPts, kcr,  u_s , (u_s + u_e)/2, u_in);
    u_array_end = get_curvature_peak(kv , CtrlPts, kcr,  (u_s + u_e)/2 , u_e, u_in);  
    u_array = [u_array_begin, u_array_end];
end