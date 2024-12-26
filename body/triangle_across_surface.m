%% 空间三角形跟平面的相交点

function p = triangle_across_surface(pts, vz)

  p1 = pts(1,:);
  p2 = pts(2,:);
  p3 = pts(3,:);
  p = [];

 if (p1(3) > vz && p2(3) < vz )
%     theta = (p1(3) - vz)/(p1(3) - p2(3));
    a = p1(3) - vz;
    b = vz - p2(3);
    c = a + b;
    p = [p; (a * p2 + b * p1)/c]; 
 elseif (p2(3) > vz  && p1(3) < vz )
%     theta = (p2(3) - vz)/(p2(3) - p1(3));
    a = p2(3) - vz;
    b = vz - p1(3);
    c = a + b;
    p = [p; (a * p1 + b * p2)/c]; 
 end
 
 if (p1(3) > vz && p3(3) < vz )
%     theta = (p1(3) - vz)/(p1(3) - p3(3));
    a = p1(3) - vz;
    b = vz - p3(3);
    c = a + b;
    p = [p; (a * p3 + b * p1)/c]; 
 elseif (p3(3) > vz && p1(3) < vz )
%     theta = (p3(3) - vz)/(p3(3) - p1(3));
    a = p3(3) - vz;
    b = vz - p1(3);
    c = a + b;
    p = [p; (a * p1 + b * p3)/c]; 
 end
 
 if (p2(3) > vz && p3(3) < vz )
%     theta = (p2(3) - vz)/(p2(3) - p3(3));
    a = p2(3) - vz;
    b = vz - p3(3);
    c = a + b;
    p = [p; (a * p3 + b * p2)/c]; 
 elseif (p3(3) > vz && p2(3) < vz)
%     theta = (p3(3) - vz)/(p3(3) - p2(3));
    a = p3(3) - vz;
    b = vz - p2(3);
    c = a + b;
    p = [p; (a * p2 + b * p3)/c]; 
 end
 
 if (abs(p1(3) - vz) < 1e-6 && abs(p2(3) - vz)< 1e-6 )|| (abs(p2(3) - vz) < 1e-6 && abs(p3(3) - vz)< 1e-6 ) || (abs(p1(3) - vz) < 1e-6 && abs(p3(3) - vz)< 1e-6 )
     kk = 1;
 end
 
%  figure(2)
%  plot3([pts(:,1);pts(1,1)], [pts(:,2);pts(1,2)] , [pts(:,3); pts(1,3)]);
%  hold on
%  plot3(p(1,1), p(1,2), p(1,3), '*r');
%  hold on
%  plot3(p(2,1), p(2,2), p(2,3), '*r');
%  hold off

    