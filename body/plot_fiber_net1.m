function plot_fiber_net1( pts, x_fiber, y_fiber )
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
    
    kx1 = findspannew(x_fiber , px1);
    kx2 = findspannew(x_fiber, px2);
    ky1 = findspannew(y_fiber , py1);
    ky2 = findspannew(y_fiber, py2);
%     a = [x_fiber(kx1) x_fiber(kx2)  y_fiber(ky1), y_fiber(ky2)];
%     b = [px1, px2, py1, py2];
    
    %% 把曲线分成6中情况
    if kx1 == kx2
        x = [x_fiber(kx1),  x_fiber(kx1+1) , x_fiber(kx1+1)  , x_fiber(kx1)];
        if ky2 > ky1
            if abs(y_fiber(ky2) - py2) < 1e-6
                y = [y_fiber(ky1),  y_fiber(ky1), y_fiber(ky2) , y_fiber(ky2)];
            else
                y = [y_fiber(ky1),  y_fiber(ky1), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)];
            end
        else
            if abs(y_fiber(ky1) - py1) < 1e-6
                 y = [y_fiber(ky2),  y_fiber(ky2), y_fiber(ky1) , y_fiber(ky1)];
            else
                y = [y_fiber(ky2),  y_fiber(ky2), y_fiber(ky1 + 1) , y_fiber(ky1 + 1)];
            end
        end
        fill( x ,  y , 'y' )
        hold on
        return;
    elseif ky1 == ky2
        if abs(x_fiber(kx2) - px2) < 1e-6
            x = [x_fiber(kx1),  x_fiber(kx2) , x_fiber(kx2)  , x_fiber(kx1)];
        else
            x = [x_fiber(kx1),  x_fiber(kx2+1) , x_fiber(kx2+1)  , x_fiber(kx1)];
        end
        y = [y_fiber(ky1),  y_fiber(ky1), y_fiber(ky1 + 1) , y_fiber(ky1 + 1)];
        fill( x ,  y , 'y' )
        hold on
        return;
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
            x = [x_fiber(beginx),  x_fiber(endx) , x_fiber(endx)  , x_fiber(beginx)];
            y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(endy) , y_fiber(endy)];
            fill( x ,  y , 'y' )
            hold on
            beginx = findkx;    
            if i== ky2 && abs(y_fiber(ky2) - py2) > 1e-6
                if abs(x_fiber(kx2) - px2) > 1e-6
                    x = [x_fiber(beginx),  x_fiber(kx2+1) , x_fiber(kx2+1)  , x_fiber(beginx)];
                else
                    x = [x_fiber(beginx),  x_fiber(kx2) , x_fiber(kx2)  , x_fiber(beginx)];
                end
                 y = [y_fiber(endy),  y_fiber(endy), y_fiber(endy + 1) , y_fiber(endy + 1)]; 
                 fill( x ,  y , 'y' )
                 hold on
            end 
         end  
    elseif (ky2 > ky1) && (ky2 - ky1) >= (kx2 - kx1)    %% 线段与X轴的夹角 45-90度
        beginy = ky1;
        for i = kx1 + 1: kx2
            kx = x_fiber(i);
            ky = (kx - px1)*(py2 - py1)/(px2 - px1) + py1;
            findky = findspannew(y_fiber , ky);
            beginx = i - 1;
            endx = i;
            x = [x_fiber(beginx),  x_fiber(endx) , x_fiber(endx)  , x_fiber(beginx)];
            if abs(y_fiber(findky) - ky) > 1e-6
                y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(findky + 1) , y_fiber(findky + 1)];
            else
                y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(findky) , y_fiber(findky)];
            end
            fill( x ,  y , 'y' );
            hold on
            beginy = findky;
            %需要把结尾补全
            if i == kx2 && abs(x_fiber(kx2) - px2) > 1e-6
                x = [x_fiber(kx2) , x_fiber(kx2 + 1)  , x_fiber(kx2 + 1),  x_fiber(kx2)];
                if abs(y_fiber(ky2) - py2) > 1e-6
                    y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)];
                else
                    y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(ky2) , y_fiber(ky2)];
                end
                fill( x ,  y , 'y' );
                hold on
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
            x = [x_fiber(beginx),  x_fiber(endx) , x_fiber(endx)  , x_fiber(beginx)];
            y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(endy) , y_fiber(endy)];
            fill( x ,  y , 'y' )
            hold on  
            endx = beginx + 1;
            if i== ky1 && abs(y_fiber(ky1) - py1) > 1e-6
                x = [x_fiber(kx1),  x_fiber(beginx + 1) , x_fiber(beginx + 1)  , x_fiber(kx1)];
                y = [y_fiber(endy),  y_fiber(endy), y_fiber(endy + 1) , y_fiber(endy + 1)]; 
                fill( x ,  y , 'y' )   
                hold on
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
            endx = i;
            beginy = findky;
            x = [x_fiber(beginx),  x_fiber(endx) , x_fiber(endx)  , x_fiber(beginx)];
            y = [y_fiber(beginy),  y_fiber(beginy), y_fiber(endy) , y_fiber(endy)];
            fill( x ,  y , 'y' );
            hold on
            if abs(y_fiber(findky) - ky) > 1e-6
                endy = beginy + 1;
            else
                endy = beginy;
            end
            %需要把结尾补全
            if i == kx2 && abs(x_fiber(kx2) - px2) > 1e-6
                x = [x_fiber(kx2) , x_fiber(kx2 + 1)  , x_fiber(kx2 + 1),  x_fiber(kx2)];
                if abs(y_fiber(ky2) - py2) > 1e-6
                    y = [y_fiber(ky2) , y_fiber(ky2) , y_fiber(endy),  y_fiber(endy)];
                else
                    y = [y_fiber(ky2 + 1) , y_fiber(ky2 + 1) , y_fiber(endy),  y_fiber(endy)];
                end
                fill( x ,  y , 'y' );
                hold on
            end  
        end
    end

end

