function imdata = transfer_lines2imfigure1( lines_pts, fiber_dis )
%PLOT_FIBER_NET 此处显示有关此函数的摘要
%   此处显示详细说明
    n = size(lines_pts,1);
    maxx = max(lines_pts(:,1)) + fiber_dis;
    minx = min(lines_pts(:,1)) - fiber_dis;
    maxy = max(lines_pts(:,2)) + fiber_dis;
    miny = min(lines_pts(:,2)) - fiber_dis;

    nx = ceil((maxx - minx)/fiber_dis) + 1;
    ny = ceil((maxy - miny)/fiber_dis) + 1;
    x_fiber = linspace(minx, maxx, nx);
    y_fiber = linspace(miny, maxy, ny);
    imdata = false(nx + 1,ny + 1);
    
    for linenum = 1:n-1
        pts = lines_pts(linenum:linenum+1,:);

        %保证线段是从左至右的
        if pts(1,1) > pts(2,1)
            p = pts(2,:);
            pts(2,:) = pts(1,:);
            pts(1,:) = p;
        end

        px1 = pts(1,1);
        px2 = pts(2,1);
        py1 = pts(1,2);
        py2 = pts(2,2);

        kx1 = findspannew(x_fiber , px1);
        kx2 = findspannew(x_fiber, px2);
        ky1 = findspannew(y_fiber , py1);
        ky2 = findspannew(y_fiber, py2);

        %% 把曲线分成6中情况
        if kx1 == kx2   
            if ky2 > ky1
                if abs(y_fiber(ky2) - py2) < 1e-6
                    imdata(kx1, ky1:ky2-1) = true;
                else
                    imdata(kx1, ky1:ky2) = true;
                end
            else
                if abs(y_fiber(ky1) - py1) < 1e-6
                    imdata(kx1, ky2:ky1-1) = true;
                else
                    imdata(kx1, ky2:ky1) = true;
                end
            end
        elseif ky1 == ky2   
            if abs(x_fiber(kx2) - px2) < 1e-6
                imdata(kx1:kx2-1, ky1) = true;
            else
                imdata(kx1:kx2, ky1) = true;
            end
        elseif (ky2 > ky1) && (ky2 - ky1) <= (kx2 - kx1)    %% 线段与X轴的夹角 0-45度
             beginx = kx1;  
             for i = ky1+1 : ky2
                ky = y_fiber(i);
                kx = (ky - py1)/(py2 - py1) * (px2 - px1) + px1;
                findkx = findspannew(x_fiber , kx);
                if abs(x_fiber(findkx) - kx) > 1e-6
                    endx = findkx + 1;
                else
                    endx = findkx;
                end        
                beginy = i - 1;
                endy = i;
                imdata(beginx:endx-1, beginy) = true;
                beginx = findkx;    
                if i== ky2 && abs(y_fiber(ky2) - py2) > 1e-6
                    if abs(x_fiber(kx2) - px2) > 1e-6
                        imdata(beginx:kx2, endy) = true;
                    else
                        imdata(beginx:kx2-1, endy) = true;
                    end
                end 
             end  
        elseif (ky2 > ky1) && (ky2 - ky1) >= (kx2 - kx1)    %% 线段与X轴的夹角 45-90度
            beginy = ky1;
            for i = kx1 + 1: kx2
                kx = x_fiber(i);
                ky = (kx - px1)*(py2 - py1)/(px2 - px1) + py1;
                findky = findspannew(y_fiber , ky);
                beginx = i - 1;
%                 endx = i;
                if abs(y_fiber(findky) - ky) > 1e-6
                    imdata(beginx, beginy:findky) = true;
                else
                    imdata(beginx, beginy:findky-1) = true;
                end
                beginy = findky;
                %需要把结尾补全
                if i == kx2 && abs(x_fiber(kx2) - px2) > 1e-6
                    if abs(y_fiber(ky2) - py2) > 1e-6
                        imdata(kx2, beginy:ky2) = true;
                    else
                        imdata(kx2, beginy:ky2-1) = true;
                    end
                end  
            end
        elseif (ky2 < ky1) && (ky1 - ky2) <= (kx2 - kx1)    %% 线段与X轴的夹角 0-负45度

             if abs(x_fiber(kx2) - px2) > 1e-6
                 endx = kx2 + 1;
             else
                 endx = kx2;
             end
             for i = ky2+1 : ky1
                ky = y_fiber(i);
                kx = px2 - (ky - py2)/(py1 - py2) * (px2 - px1);
                beginx = findspannew(x_fiber , kx);     
                beginy = i - 1;
                endy = i;
                imdata(beginx: endx-1, beginy) = true;
                endx = beginx + 1;
                if i== ky1 && abs(y_fiber(ky1) - py1) > 1e-6
                    imdata(kx1: beginx , endy) = true;
                end
             end    
        else  %% 线段与X轴的夹角 负45-负90度
            if abs(y_fiber(ky1) - py1) > 1e-6   
                endy = ky1 + 1;
            else
                endy = ky1;
            end
            for i = kx1 + 1: kx2
                kx = x_fiber(i);
                ky = (px2 - kx)*(py1 - py2)/(px2 - px1) + py2;
                findky = findspannew(y_fiber , ky);
                beginx = i - 1;
%                 endx = i;
                beginy = findky;
                imdata(beginx, beginy:endy-1) = true; 
                if abs(y_fiber(findky) - ky) > 1e-6
                    endy = beginy + 1;
                else
                    endy = beginy;
                end
                %需要把结尾补全
                if i == kx2 && abs(x_fiber(kx2) - px2) > 1e-6
                    if abs(y_fiber(ky2) - py2) > 1e-6
                        imdata(kx2, ky2:endy-1) = true;
                    else
                        imdata(kx2, ky2+1:endy-1) = true;
                    end
                end  
            end
        end
    end
end

