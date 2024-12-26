function [ ptsh, ptsl , index, checkvalue] = split_lines( line_pts )
%CALC_SPREAD 此处显示有关此函数的摘要
%   此处显示详细说明
    maxval  = -1000 * ones(1,4);
    minval = 1000 * ones(1,4);
    n = floor(size(line_pts,1)/2);
    save_value = zeros(4,n);
    for i = 1:2
        for j = 1:n
            oneline_pts = line_pts(2*j-1:2*j,i);
            minvalue = min(oneline_pts);
            maxvalue = max(oneline_pts);
            if minvalue < minval(2*i - 1)
                minval(2*i - 1) = minvalue;
            end
            if minvalue > maxval(2*i - 1)
                maxval(2*i - 1) = minvalue;
            end
            if maxvalue < minval(2*i)
                minval(2*i) = maxvalue;
            end
            if maxvalue > maxval(2*i)
                maxval(2*i) = maxvalue;
            end    
            save_value(2*i-1:2*i,j) = [minvalue;maxvalue];
        end
    end
    [~, index] = max(abs(maxval - minval));
    checkarray= save_value(index, :);
    kk = sort(checkarray); 
    checkvalue = (kk(floor(n/2)) + kk(floor(n/2) + 1))/2;      
%     checkvalue = kk(ceil(n/2));
%     if mod(index,2) == 0
        hindex = find(checkarray > checkvalue);
        lindex = find(checkarray <= checkvalue);
%     else
%         hindex = find(checkarray >= checkvalue);
%         lindex = find(checkarray < checkvalue);
%     end
    hflag = zeros(1,2*length(hindex));
    for i = 1:length(hindex)
        hflag(2*i-1:2*i) = [2*hindex(i)-1, 2*hindex(i)];
    end
    lflag = zeros(1,2*length(lindex));
    for i = 1:length(lindex)
        lflag(2*i-1:2*i) = [2*lindex(i)-1, 2*lindex(i)];
    end
    
    ptsh = line_pts(hflag,:);
    ptsl = line_pts(lflag,:);

end

