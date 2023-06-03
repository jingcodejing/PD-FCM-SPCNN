% 参数设置
clc;clear;close all;
f1 =1;
f2 =1;
t = -0.28;                                   %(改改改） % 设定参数th2（alpha）(第一次设置预定迭代次数的位置）
file1 = 'JPEGImages - 光照';
% file2 = '000';
x1 = 1; x2 =416;%宽
y1 = 1; y2 = 416; %长
for fi=f1:f2
    file3 = num2str(fi,'%03d');
    filename1 = ['E:\实验\data\',file3,'.png'];
    filename2 = ['E:\workspace\python\conv_lstm\data\input\img\11\',file3,'.png'];  
 
    img = imread(filename1);
    img = img(x1:x2,y1:y2,1:3);
    thresh1=graythresh(img(:,:,3));   %thresh1=0.5216
    thresh1 = thresh1-t;
    tu2 = im2bw(img(:,:,2),thresh1);
    img_invert = imcomplement(tu2);
    imshow(img_invert);
    %imwrite(img_invert, filename2);
end