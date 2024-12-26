function index = findspannew( KntVect, findvalue)
%FINDSPANINDEX 此处显示有关此函数的摘要
%   此处显示详细说明
n = length(KntVect);
if n <= 1 || findvalue < KntVect(1)
    index = 1;
    return;
end

if findvalue >= KntVect(end)
    index = n - 1;
    return;
end
   
low = 1; 
high = n;
mid = floor((low + high)/2);
while(findvalue < KntVect(mid) ||...
        findvalue >= KntVect(mid + 1))
    if(findvalue < KntVect(mid))
        high = mid;
    else
        low = mid;
    end
    mid = floor((low + high) / 2);
end
if abs(findvalue - KntVect(mid + 1)) < 1e-6
    index = mid + 1;
else
    index = mid;
end


