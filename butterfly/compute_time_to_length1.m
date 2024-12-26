%n代表第几个插补周期
%
function s_out = compute_time_to_length1(n  , J ,  v_start, s_param, s_delta_error)

v = s_param(2,:);
s = s_param(3,:);
Ja = J(1);
Jd = J(2);
cmp_num = s_param(4,:);
interpolation_cycle = 0.001;
t_input = n * interpolation_cycle;
t_n = round(s_param(1,:) / interpolation_cycle);
t = t_n * interpolation_cycle;
na1 = t_n(1);
nd1 = t_n(5)- t_n(4); 

if t_input <= t(1)
    dt = t_input; 
    compensation_num = n * (n + 1)/2 ;
    s_l =  v_start * dt + 1/6 * Ja * dt^3;  
elseif t_input <= t(2)
    dt = t_input - t(1);
    compensation_num = cmp_num(1)  +  na1 * (n - t_n(1));
    s_l = s(1) + v(1) * dt + 1/2 * Ja * t(1) * dt^2;  
elseif t_input <= t(3)
    dt = t_input - t(2);
    compensation_num = cmp_num(3) - (t_n(3) - n) * (t_n(3) - n + 1)/2  ;
    s_l = s(2) + v(2) * dt + 1/2 *  Ja * t(1) * dt^2 - 1/6 *Ja* dt^3;
elseif t_input <= t(4)
  dt = t_input - t(3);
    if na1 == 0 && nd1 == 0
        ns = t_n(4) - t_n(3);
        cn = floor(dt / interpolation_cycle);
        nmid = floor(ns/2);
        if mod(ns,2) == 1
            if cn <= nmid
                compensation_num = cn*(cn + 1)/2;
            else
                compensation_num = nmid*(nmid + 1) - (ns - cn)*(ns - cn - 1)/2;
            end
        else
            if cn <= nmid
                compensation_num = cn*(cn + 1)/2;
            else
                compensation_num = nmid * nmid - (ns - cn)*(ns - cn - 1)/2;
            end      
        end
    else
        compensation_num = cmp_num(4);
    end
    s_l = s(3) + v(3) * dt; 
elseif t_input <= t(5)
    dt = t_input - t(4);
    compensation_num = cmp_num(4) + (n - t_n(4)) * (n - t_n(4) + 1)/2;
    s_l = s(4) + v(4) * dt - 1/6 * Jd * dt^3;
elseif t_input <= t(6)
    dt = t_input - t(5);
    compensation_num = cmp_num(5) +  nd1 * (n - t_n(5));
    s_l = s(5) + v(5) * dt - 1/2 * Jd * (t(5) - t(4)) * dt^2;
else
    dt = t_input - t(6);
    compensation_num = cmp_num(7) - (t_n(7) - n) * (t_n(7) - n + 1)/2;
    s_l = s(6) + v(6) * dt - 1/2 * Jd * (t(5) - t(4)) * dt ^ 2 + 1/6 *Jd * dt^3;
end
s_out = s_l - compensation_num * s_delta_error;
% s_out = s_l ;

