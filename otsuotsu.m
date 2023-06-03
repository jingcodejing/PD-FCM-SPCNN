I = imread('E:\论文\PCNN\图片\对比\2\1\00008 4074.jpg');
I = im2double(I);
T = graythresh(I); %获取阈值
J = im2bw(I, T); %图像分割
subplot(121),imshow(I);
subplot(122),imshow(J);
imwrite(J,'E:\论文\PCNN\图片\对比\2\21-otsu.jpg')
