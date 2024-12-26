clc;clear ;close all;
im = imread('onecicle.png');

imshow(im);
bw = im2bw(im);

contour = bwperim(bw);
figure

imshow(contour);

