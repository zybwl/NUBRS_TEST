function index = find_critical_index(curvature , threshold)

n = length(curvature);
vip_point_index = curvature > threshold;
kk = abs(diff(vip_point_index));
slope_index = find( kk > 0) ;
if vip_point_index(1) == true && vip_point_index(n) == true
    slope_index = [slope_index(end)  slope_index(1: end-1)];
elseif vip_point_index(1) == true && vip_point_index(n) ~= true
    slope_index = [1 slope_index];
elseif vip_point_index(1) ~= true && vip_point_index(n) == true
    slope_index = [slope_index n];
end

sn = floor(length(slope_index)/2);
index = zeros(1,sn);
for i = 1:sn
    begin_index = slope_index(2*i -1);
    end_index = slope_index(2*i);
    if begin_index > end_index
        find_index = [begin_index + 1:n  1:end_index];
    else
        find_index = begin_index + 1:end_index;
    end
    [~, I] = max(curvature(find_index));
    out_index = I + begin_index - 1;
    if out_index > n
        out_index = out_index - n;
    end
    index(i) = out_index;
end

if index(1) ~= 1
    index = [1 index];
elseif index(end) ~= n
    index = [index n];
end