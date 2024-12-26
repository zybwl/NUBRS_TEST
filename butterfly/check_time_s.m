%% 主要检验时间是否计算正确

new_Ja = 30000;
new_Jd = 30000;

v_start = 94.8285071700338;
v_end = 98.756390441322300;
interpolation_cycle = 0.001;
t  = [0.0131294742595509,0,0.0131294742595509,0.0414630823474422,0.00643845105253767,0,0.00643845105253800];
t_num = round(t/interpolation_cycle);
t_new = t_num * interpolation_cycle;

v1 = v_start + 1/2* new_Ja *t_new(1)^2;
v2 = v1 + new_Ja * t_new(1) * t_new(2);
v3 = v2 + new_Ja * t_new(1) * t_new(3) - 1/2 * new_Ja * t_new(3)^2;
v4 = v3;
v5 = v4 - 1/2* new_Jd *t_new(5)^2;
v6 = v5 - new_Jd *t_new(5)*t_new(6);
v7 = v6 - new_Jd * t_new(5) * t_new(7) + 1/2 * new_Jd * t_new(7)^2    

sa1 = v_start * t_new(1) + 1/6 * new_Ja * t_new(1)^3;
sa2 = sa1 + v1 * t_new(2) + 1/2 * new_Ja * t_new(1) * t_new(2)^2;
sa3 = sa2 + v2 * t_new(3) + 1/3 * new_Ja * t_new(3)^3;  %这里论文中有错误，在t(2)或者t(4)为零的情况下有问题
ss4 = sa3 + v4 * t_new(4);
sd5 = ss4 + v4 * t_new(5) - 1/6 * new_Jd * t_new(5)^3; %这里论文中有错误，在t(2)或者t(4)为零的情况下有问题
sd6 = sd5 + v5 * t_new(6) - 1/2 * new_Jd * t_new(5) * t_new(6)^2;
sd7 = sd6 + v6 * t_new(7) - 1/2 * new_Jd * t_new(5) * t_new(7) ^ 2 + 1/6 * new_Jd * t_new(7)^3