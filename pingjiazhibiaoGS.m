clc;clear;
img1=imread('E:\论文\PCNN\图片\对比\2\21-shou.jpg'); %读取图片
img2=imread('E:\论文\PCNN\图片\对比\2\21-pcnn.jpg');

figure('NumberTitle','off','Name','原始图像');
subplot(1,2,1);imshow(img1);    %显示原始图像
subplot(1,2,2);imshow(img2);

figure('NumberTitle','off','Name','匹配图像尺寸');
[a1,b1]=size(img1);[a2,b2]=size(img2);

a=min(a1,a2);b=min(b1,b2);
img11=imresize(img1,[a,b/3]);   %因为包含RGB3个通道，所以除3
img21=imresize(img2,[a,b/3]);
subplot(1,2,1);imshow(img11);   %显示匹配尺寸之后的图像
subplot(1,2,2);imshow(img21);

figure('NumberTitle','off','Name','灰度分布图');
[hd1,x1]=imhist(img11);
[hd2,x2]=imhist(img21);
plot(hd1,'color',[1 0 0]);hold on;
plot(hd2,'color',[0 1 0]);legend('hd1','hd2');

figure('NumberTitle','off','Name','归一化灰度分布图及相似度');
hd11=hd1/(a*b);
hd21=hd2/(a*b);
plot(hd11,'color',[1 0 0]);hold on;
plot(hd21,'color',[0 1 0]);legend('hd11','hd21');
d=0;
for i=1:256
    d=d+sqrt(hd11(i)*hd21(i));  %算巴氏距离的公式
end
title(['相似度为',num2str(100*d),'%']);
