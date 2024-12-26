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

[hpts, lpts, ~, ~] = split_lines( pts );

[p1, p2, ~, ~] = split_lines( lpts );

[p3, p4, ~, ~] = split_lines( p1 );

[p5, p6, ~, ~] = split_lines( p3 );

figure(1);
plot_lines(p3);
% hold on
% plot([value,value], [-30,30]);

figure(2);
plot_lines(p5);

figure(3);
plot_lines(p6);






    
    