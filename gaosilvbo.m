close all;
clc;  
clear; 
img=imread('E:\论文\PCNN\图片\对比\2\1.2.jpg');
a=img;
% imshow(img);
[m n]=size(img);
img=double(img);
w1=[0.3162    0.4000    0.5099    0.6324    0.7616
   0.3162    0.2000    0.1414    0.2000    0.3162    
   0.2828    0.1414         0    0.1414    0.2828    
   0.3162    0.2000    0.1414    0.2000    0.3162    
   0.4000    0.3162    0.2828    0.3162    0.4000]
%高斯滤波
w2=fspecial('gaussian',[5,5]);    %[ 5 5 ]是模板尺寸，默认是[ 3 3 ]  模板即上文所提的模板
w=w1*w2.'
img=imfilter(img,w);
figure;
% subplot(1,2,1);imshow(a);title('原图');
% subplot(1,2,2);imshow(uint8(img));title('高斯滤波');

imshow(uint8(img));
imwrite(uint8(img),'E:\论文\PCNN\图片\对比\2\1.3.jpg')

