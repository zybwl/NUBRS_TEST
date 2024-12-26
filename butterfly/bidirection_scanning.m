
function  v = bidirection_scanning(v,s)

N = max(size(v));
TOL = 0.001;
Acc = 1000;
Ja = 10000;
Vmax = 100;

% backward_scanning
for i=N:-1:2  
    v_s = v(i);
    L = s(i-1);
    v1 = newton_iteration(Ja ,Acc, v_s, L, TOL); 
    v2=Vmax;
    v3=v(i-1);  
    new_v=[v1 v2 v3];
    v(i-1)=min(new_v);
end

% forward_scanning
for i=1:N-1 
    v_s = v(i);
    L = s(i);
    v1 = newton_iteration(Ja ,Acc, v_s, L, TOL); 
    v2=Vmax;
    v3=v(i+1);  
    new_v=[v1 v2 v3];
    v(i+1)=min(new_v);
end

