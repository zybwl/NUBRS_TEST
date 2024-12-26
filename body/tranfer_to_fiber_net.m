clc;clear;close all;

pts = [
    -6,14,0;
    11,14,0;
    13,15,0;
    25,20,0;
    -17,9,0;
    -9,14,0;
    38,-9,0;
    29,-20,0
    16,-25,0;
    1,-25,0;
    29,-20,0;
    16,-25,0;
    38,9,0;
    38,-7,0;
    27,19,0;
    37,9,0;
    -1,-25,0;
    -19,-13,0;
    -19,-12,0;
    -18,8,0;    
    ];

max_error = 5;
x = pts(:,1);  y = pts(:,2);

[newx , ix] = sort(x);
[newy,  iy] = sort(y);
pts = sort_all_lines_new(pts, max_error, newx, ix, newy, iy);
plot(pts(:,1), pts(:,2), '-r');
hold on

fiber_dis = 1;
maxx = max(pts(:,1));
minx = min(pts(:,1));
maxy = max(pts(:,2));
miny = min(pts(:,2));

n = size(pts,1) - 1;
nx = ceil((maxx - minx)/fiber_dis);
ny = ceil((maxy - miny)/fiber_dis);

x_fiber = linspace(minx, maxx, nx);
y_fiber = linspace(miny, maxy, ny);

for kx = x_fiber
    plot([kx kx], [miny maxy],' -b');
%     hold on
end

for ky = y_fiber
    plot([minx maxx], [ky ky],' -k');
%     hold on
end


for k = 5: size(pts,1) - 1
%     k = 9;
    px1 = pts(k,1);
    px2 = pts(k+1,1);
    py1 = pts(k,2);
    py2 = pts(k+1,2);
    reverse_flag = false;
    if px1 > px2
        px = px1;
        px1 = px2;
        px2 = px;
    end
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
%     bb = [kminx, kmaxx, kminy, kmaxy];
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
            if i== ky2 && (ky2 + 1) < length(y_fiber) && (kx2 + 1) < length(x_fiber)
                 x = [x_fiber(kx_first),  x_fiber(kx2+1) , x_fiber(kx2+1)  , x_fiber(kx_first)];
                 y = [y_fiber(ky_first),  y_fiber(ky_first), y_fiber(ky2 + 1) , y_fiber(ky2 + 1)]; 
                 fill( x ,  y , 'y' )
            end 
        end
    end
end

    
    

