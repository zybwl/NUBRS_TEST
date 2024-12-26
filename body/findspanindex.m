function findarray = findspanindex( KntVect, findvalue, maxerror )
%FINDSPANINDEX 此处显示有关此函数的摘要
%   此处显示详细说明
n = length(KntVect);
if n <= 1
    findarray = 1;
    return;
end
   
low = 1; 
high = n;
mid = floor((low + high)/2);
if abs(findvalue  - KntVect(end)) < 1e-6
    mid = n;
else
    while(findvalue < KntVect(mid) ||...
            findvalue >= KntVect(mid + 1))
        if(findvalue < KntVect(mid))
            high = mid;
        else
            low = mid;
        end
        mid = floor((low + high) / 2);
    end
end
index = mid;
pre_value = KntVect(index);
findarray = index;

if index > 1
%     pre_value = KntVect(index - 1);
%     findarray = index - 1;
    for i = index - 1: -1 : 1 
        now_value = KntVect(i); 
        if abs(now_value - pre_value) < maxerror
            findarray = [i, findarray];
        else
            break;
        end
    end
end

if index < n
    for i = index + 1: n 
        now_value = KntVect(i); 
        if abs(now_value - pre_value) < maxerror
            findarray = [findarray,i ];
        else
            break;
        end
    end
end

end

