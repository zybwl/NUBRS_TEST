function array = find_index(pathParamCells , is_right_clock)

path_num  = length(pathParamCells);
one_nurbs = pathParamCells{1,1};
% 找到跟起点串联在一起的片段
bgn_end_index = zeros(1,path_num);
if is_right_clock
    bgn_end_pts = one_nurbs.cpts(1:3,1)/one_nurbs.cpts(4,1);
    bgn_end_index(1) = -1;
else
    bgn_end_pts = one_nurbs.cpts(1:3,end)/one_nurbs.cpts(4,end);
     bgn_end_index(1) = 1;
end

for i = 2:path_num
    for j = 2:path_num
        is_exist = 0;
        for k = 2:path_num
            if abs(bgn_end_index(k)) == j
                is_exist = 1;
                break;
            end
        end
        if is_exist
            continue;
        end
        one_nurbs = pathParamCells{1,j};
        begin_pts = one_nurbs.cpts(1:3,1)/one_nurbs.cpts(4,1);
        end_pts = one_nurbs.cpts(1:3,end)/one_nurbs.cpts(4,end);
        if norm(begin_pts - bgn_end_pts) < 1e-3
            bgn_end_index(i) = j;
            bgn_end_pts = end_pts;
            break;
        elseif norm(end_pts - bgn_end_pts) < 1e-3
            bgn_end_index(i) = -j;
            bgn_end_pts = begin_pts;
            break;
        else
            continue;
        end
    end 
end
array = bgn_end_index(abs(bgn_end_index) > 0);
    
    