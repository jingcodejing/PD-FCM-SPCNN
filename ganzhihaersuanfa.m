clc;clear;
img1=imread('E:\论文\PCNN\图片\对比\2\18-pcnn.jpg');
img2=imread('E:\论文\PCNN\图片\对比\2\18-shou.jpg');

figure('NumberTitle','off','Name','原始图像');
subplot(1,2,1);imshow(img1);
subplot(1,2,2);imshow(img2);

figure('NumberTitle','off','Name','256级灰度图像');
img11=rgb2gray(img1);
img21=rgb2gray(img2);
subplot(1,2,1);imshow(img11);
subplot(1,2,2);imshow(img21);

figure('NumberTitle','off','Name','缩放32*32图像');
img12=imresize(img11,[32,32]);
img22=imresize(img21,[32,32]);
subplot(1,2,1);imshow(img12);
subplot(1,2,2);imshow(img22);

imgdct1=dct2(img12);    %计算二维dct
imgdct2=dct2(img22);
imgdct11=imgdct1(1:8,1:8);  %截取左上角8*8
imgdct21=imgdct2(1:8,1:8);
mean1=sum(imgdct11(:))/64;  %计算均值
mean2=sum(imgdct21(:))/64;
imghash1=zeros(8,8);
imghash2=zeros(8,8);
for i=1:8   %遍历生成hash指纹
    for j=1:8
        if(imgdct11(i,j)>=mean1)
            imghash1(i,j)=1;end
        if(imgdct21(i,j)>=mean2)
            imghash2(i,j)=1;end
    end
end
cyjz=xor(imghash1,imghash2);    %求异或
hanming=sum(cyjz(:));   %求汉明距离
similarity=(64-hanming)/64;
figure('NumberTitle','off','Name','phash指纹图');
subplot(1,2,1);imshow(imghash1);
subplot(1,2,2);imshow(imghash2);
title(['与前者相似度为',num2str(100*similarity),'%']);