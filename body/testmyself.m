clc;clear;close all;
[FileName,PathName] = uigetfile('*.igs','Select igs file');
fullfileName = strcat(PathName,FileName); 

sell = getIgsLineCells(fullfileName);

% for i = [6,7]
%     cpts = sell{i}.cpts;
%     kv = sell{i}.kv; 
%     plot_curve( cpts, kv )
% end
i = 4;
cpts1 = sell{i}.cpts;
kv1 = sell{i}.kv; 
plot_curve( cpts1, kv1 )

i = 5;
cpts2 = sell{i}.cpts;
kv2 = sell{i}.kv; 
plot_curve( cpts2, kv2 )

i = 6;
cpts = sell{i}.cpts;
kv = sell{i}.kv; 
plot_curve( cpts, kv )

u_in = [];
[L, uarray] = nurbs_curve_length_array({kv1}, cpts1, 0, 1, u_in);

figure(2);
plot(0:length(kv1)-7, kv1(4:end-3));
hold on

plot((1:length(uarray))*29/63, uarray);

kk = L * uarray;

