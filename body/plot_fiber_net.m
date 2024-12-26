function plot_fiber_net( pts, x_fiber, y_fiber )
%PLOT_FIBER_NET 此处显示有关此函数的摘要
%   此处显示详细说明

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
    
    reverse_flag = false;
    if py1 > py2
        reverse_flag = true;
        py = py1;
        py1 = py2;
        py2 = py;
    end
    kx1 = findspannew(x_fiber , px1);
    kx2 = findspannew(x_fiber, px2);
    ky1 = findspannew(y_fiber , py1);
    ky2 = findspannew(y_fiber, py2);
    kminx = x_fiber(kx1);
    kmaxx = x_fiber(kx2);
    kminy = y_fiber(ky1);
    kmaxy = y_fiber(ky2);
    
       %查询是不是X值相同
    if kx1 == kx2
        x = [x_fiber(kx1),  x_fiber(kx1+1) , x_fiber(kx1+1)  , x_fiber(kx1)];
        if abs(kmaxy - py2) < 1e-6
            y = [y_fiber(ky1),  y_fiber(kx1), y_fiber(ky2) , y_fiber(ky2)];
        else
            y = [y_fiber(ky1),  y_fiber(ky1), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)];
        end
        fill( x ,  y , 'y' )
        return;
    end
    
    %%查询是不是Y值相同
    if ky1 == ky2
        if abs(kmaxx - px2) < 1e-6
            x = [x_fiber(kx1),  x_fiber(kx2) , x_fiber(kx2)  , x_fiber(kx1)];
        else
            x = [x_fiber(kx1),  x_fiber(kx2+1) , x_fiber(kx2+1)  , x_fiber(kx1)];
        end
        y = [y_fiber(ky1),  y_fiber(ky1), y_fiber(ky1 + 1) , y_fiber(ky1 + 1)];
        fill( x ,  y , 'y' )
        return;
    end

    if (kmaxx - kminx) < (kmaxy - kminy)
        isxdirection = true;
    else
        isxdirection = false;
    end

    kx_first = kx1;
    ky_first = ky1;
    if kx2 < length(x_fiber)
        kx_end = kx2 + 1;
    else
        kx_end = kx2;
    end
    if ky2 < length(x_fiber)
         ky_end = ky2 + 1;
    else
         ky_end = ky2;
    end

    if isxdirection
        for i = kx1+1 : kx2
            kx = x_fiber(i);
            ky = (kx - px1)*(py2 - py1)/(px2 - px1) + py1;
            k1 = findspannew(y_fiber , ky);
            x = [x_fiber(kx_first),  x_fiber(kx_first+1) , x_fiber(kx_first+1)  , x_fiber(kx_first)];
            y = [y_fiber(ky_first),  y_fiber(ky_first), y_fiber(k1 + 1) , y_fiber(k1 + 1)];
            kx_first = kx_first;
            ky_first = k1 + 1;
            fill( x ,  y , 'y' )
            if i== kx2
                 x = [x_fiber(kx_first),  x_fiber(kx_first) , x_fiber(kx_first)  , x_fiber(kx_first)];
                 y = [y_fiber(ky_first),  y_fiber(ky_first), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)]; 
                 fill( x ,  y , 'y' )
            end 
        end
    else
        for i = ky1+1 : ky2
            ky = y_fiber(i);
            if reverse_flag
                kx = px2 - (ky - py1)/(py2 - py1) * (px2 - px1);
            else
                kx = (ky - py1)/(py2 - py1) * (px2 - px1) + px1;
            end
            k1 = findspannew(x_fiber , kx);
            if reverse_flag
                x = [x_fiber(k1),  x_fiber(kx_end) , x_fiber(kx_end)  , x_fiber(k1)];
            else
                x = [x_fiber(kx_first),  x_fiber(k1+1) , x_fiber(k1+1)  , x_fiber(kx_first)];
            end

            y = [y_fiber(ky_first),  y_fiber(ky_first), y_fiber(ky_first + 1) , y_fiber(ky_first + 1)];
            if reverse_flag
                kx_end = k1 + 1;
            else
                kx_first = k1;
            end
            ky_first = ky_first + 1;     
            fill( x ,  y , 'y' )
            if i== ky2 && abs(kmaxy - py2) > 1e-6
                 x = [x_fiber(kx_first),  x_fiber(kx2+1) , x_fiber(kx2+1)  , x_fiber(kx_first)];
                 y = [y_fiber(ky_first),  y_fiber(ky_first), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)]; 
                 fill( x ,  y , 'y' )
            end 
        end
    end


end

