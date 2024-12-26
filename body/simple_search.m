
%% ±©Á¦ËÑË÷
function res = simple_search(data, target)
dist = inf;
res = 0;
for i = 1: size(data, 1)
    dist_temp = sqrt(sum((target - data(i,:)).^2));
    if dist_temp < dist
        dist = dist_temp;
        res = i;
    end
end
res = data(res, :);
return 
end