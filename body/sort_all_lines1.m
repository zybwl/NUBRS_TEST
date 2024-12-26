function  lastpts = sort_all_lines1( pts , max_error)

% max_error = 0.1;
x = pts(:,1);  y = pts(:,2);

[newx , ix] = sort(x);
[newy,  iy] = sort(y);
n = size(pts,1)/2;
occupy = zeros(1,2*n);
cc = 0;
%% 找到某个点附近可连接的点
while (~isempty(find(occupy == 0)))
    k = 1;
    while(occupy(k) ~= 0)
        k = k+1;
    end
%     cc = length(find(occupy == 0))
    if k == 351
        kk = 1;
    end
%     
    if mod(k,2) == 0
        twink = k - 1;
    else
        twink = k + 1;
    end
    
    find_pts = pts(k,:);
    k1 = findspanindex(newx, find_pts(1), max_error);
    k2 = findspanindex(newy, find_pts(2), max_error); 
    min_length = 100;
    last_index = 0;
    %% 优先找没有被占据的地方
    for i = 1:length(k1)
        findindex = ix(k1(i));
        if findindex == k || findindex == twink %|| occupy(findindex) > 0
            continue;
        end
        L = norm(pts(findindex,:) - find_pts);
        if L < min_length
            if occupy(findindex) > 0 &&  occupy(findindex) < 10000
                if L < norm(pts(occupy(findindex),:) - pts(findindex,:))
                    min_length = L;
                    last_index = findindex;
                end
            else
                min_length = L;
                last_index = findindex;
            end
        end
    end

    for i = 1:length(k2)
        findindex = iy(k2(i));
        if findindex == k || findindex == twink %|| occupy(findindex) > 0
            continue;
        end
        L = norm(pts(findindex,:) - find_pts);
        if L < min_length
            
            if occupy(findindex) > 0 &&  occupy(findindex) < 10000
                if L < norm(pts(occupy(findindex),:) - pts(findindex,:))
                    min_length = L;
                    last_index = findindex;
                end
            else
                min_length = L;
                last_index = findindex;   
            end
        end
    end  
    %如果找不到，则设定一个不存在的标号，等待被替换
    if last_index == 0 || min_length > max_error
%         kk = 1;
%         new_pts = [];
        occupy(k) = 10000;
        continue;
%         return;
    end
    if occupy(last_index) > 0
        wrong_num = occupy(last_index) ;
        if wrong_num < 10000
            occupy(wrong_num) = 0; 
        end
    end
        
    %% 如果找不到,则被占据的数据中必然存在错误数据
    if last_index == 0 || min_length > 10
        kkk = 1;
        new_pts = [];
        return;
%         for i = 1:length(k1)
%             findindex = ix(k1(i));
%             if occupy(findindex) > 0
%                 L = norm(pts(findindex,:) - find_pts);
%                 if L < min_length
%                     min_length = L;
%                     last_index = findindex;
%                 end 
%             end
%         end
%         for i = 1:length(k2)
%             findindex = iy(k2(i));
%             if occupy(findindex) > 0
%                 L = norm(pts(findindex,:) - find_pts);
%                 if L < min_length
%                     min_length = L;
%                     last_index = findindex;
%                 end 
%             end
%         end   
%         wrong_num = occupy(last_index) ;
%         occupy(wrong_num) = 0;    
    end
    occupy(last_index) = k;
    occupy(k) = last_index;  

end

unoccupy_array = find(occupy == 10000);

if ~isempty(unoccupy_array)
    return;
end
% for i = 1:2:length(unoccupy_array)
%     firstindex = unoccupy_array(i);
%     secondindex = unoccupy_array(i+1);
%     occupy(firstindex) = secondindex;
%     occupy(secondindex) = firstindex;   
% end

begin_index = 2;
new_pts(1,:) = pts(1,:);
kkk = 2;
begin_flag  = 1;
while (begin_index ~= 2 || begin_flag > 0)
    begin_flag = 0;
    now_index = occupy(begin_index);
    if now_index == 10000 || begin_index == 10000
        kk = 1;
    end
    new_pts(kkk,:) = (pts(now_index,:) + pts(begin_index,:))/2;
    if mod(now_index,2) == 0
        next_index = now_index - 1;
    else
        next_index = now_index + 1;
    end
    kkk = kkk + 1;
    begin_index = next_index;
end

validindex = true(1, size(new_pts,1));
treshold = cos(170/180*pi);
for i = 2: size(new_pts,1) - 1
    v1 = new_pts(i,1:2) - new_pts(i-1,1:2);
    v2 = new_pts(i+1,1:2) - new_pts(i,1:2);
    v3 = (v1(1)*v2(1) + v1(2) * v2(2))/norm(v1)/norm(v2);
    if v3 < treshold
        validindex(i) = false;
    end 
end
lastpts = new_pts(validindex, :);
% plot(new_pts(:,1), new_pts(:,2) , '-r');