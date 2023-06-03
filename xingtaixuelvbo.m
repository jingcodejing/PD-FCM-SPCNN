close all;
clc;  
clear; 
tic
A=imread('E:\论文\PCNN\图片\对比\2\1.5.jpg');   %更改图片名即可   
% I1=rgb2gray(A); %把 RGB 图像转化成灰度图像
thresh = graythresh(A);     %自动确定二值化阈值 最大类间
I2=im2bw(A); %对图像二值化
 
figure('name','二值化处理');
subplot(1,3,1);  
imshow(A);    %显示原图
title('原图'); 
% subplot(1,3,2);  
% % imshow(I1);    %显示灰度图像
% title('灰度图'); 
% subplot(1,3,3);
% imshow(I2);    %显示二值化图像
% title('二值化'); 
 
 
% imdilate()膨胀
% SE=[0 1 0 1
%     1 1 1 1
%     0 1 0 1];
% SE=[0 1
%     0 0];
SE=[1 0 1
    0 1 0
    1 0 1];
SE4=[1 1
    1 1]

SE2=[0 1 1
    0 1 1
    0 1 0]
SE3=[1 1 1 0 0 0 0 0 0 0 0
    1 1 1 0 0 0 1 1 0 0 0
    1 1 1 0 0 1 1 1 1 0 0
    0 0 0 0 0 0 1 1 0 0 0
    0 0 0 0 0 1 1 1 1 0 0
    0 0 1 0 0 1 1 1 0 0 0
    0 1 1 1 0 1 0 0 0 0 0
    0 1 1 1 1 1 1 0 0 0 0
    0 1 1 1 1 1 0 0 1 1 1
    0 0 1 0 1 0 0 0 1 1 1
    0 0 0 0 0 0 0 0 1 1 1]
    
   
DI=imdilate(I2,SE3);%使用结构元素SE对图像I2进行一次膨胀
 
%imerode()腐蚀
%strel函数的功能是运用各种形状和大小构造结构元素
SE1=strel('disk',3);%这里是创建一个半径为3的平坦型圆盘结构元素
ER=imerode(I2,SE3);

% imopen()开运算
OP=imopen(I2,SE1);%直接开运算
 
%imclose()闭运算
CL1=imdilate(imclose(I2,SE),SE);%直接闭运算
% CL=imclose(OP,SE1);%直接闭运算
CL2=imdilate(imclose(I2,SE4),SE);
CL3=imdilate(imclose(I2,SE2),SE3);
CL4=(2/3)*CL1+(1/3)*CL2;
 
% figure('name','形态学滤波');
% subplot(2,2,1);  
%  imshow(DI);    %显示二值化图像的膨胀处理图像
%  title('膨胀图像'); 
%  subplot(2,2,2);  
% % imwrite(DI,'E:\论文\PCNN\图片\4.6.jpg'); 
% imshow(ER);    %显示二值化图像的腐蚀处理图像
% title('腐蚀图像'); 
% % imwrite(ER,'D:\weizhishibie\青海湖\XINGTAIXUE3.png');
% subplot(2,2,3);  
% imshow(OP);    %显示二值化图像的开运算处理图像
% title('开运算图像'); 
% subplot(2,2,4);  
imshow(CL2);    %显示二值化图像的开运算处理图像
title('闭运算图像');
imwrite(CL2,'E:\论文\PCNN\图片\对比\2\1.7.jpg')
 
 
 
% %imnoise()噪声
% I3=imnoise(A,'salt & pepper',0.1);%椒盐噪声
% I4=imnoise(A,'gaussian',0.02);    %高斯噪声
%  
% %中值滤波去椒盐噪声
% I5=medfilt2(I3,[4,4]); %4×4 中值滤波
%  
% %高斯低通滤波去高斯噪声
% sigma=1.6;
% gausFilter=fspecial('gaussian',[3,3],sigma);
% I6=imfilter(I4,gausFilter,'replicate');
%  
% figure('name','图像滤波去噪');
% subplot(2,2,1);
% imshow(I3);
% title('加入噪声密度：0.1的椒盐噪声');
%  
% subplot(2,2,2);
% imshow(I4);
% title('加入噪声密度：0.02的高斯噪声');
%  
% subplot(2,2,3);
% imshow(I5);
% title('中值滤波-椒盐');
%  
% subplot(2,2,4);
% imshow(I6);
% title('高斯低通滤波-高斯');
toc