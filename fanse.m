clear all;
close all;
clc;  
clear; 
I = imread('E:\论文\PCNN\图片\对比\1\3-grow.jpg');
figure, imshow(I);
I_reverse = imcomplement(I);
figure, imshow(I_reverse);
imwrite(I_reverse,'E:\论文\PCNN\图片\对比\1\3-grow.jpg')