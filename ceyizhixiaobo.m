% A=imread('E:\论文\PCNN\图片\4.1.jpg');
% A=rgb2gray(A)
% [C,S]=wavedec2(A,2,'db1')
% D=uint8(appcoef2(C,S,'db1',1));%提取低频分量
% H=uint8(detcoef2('h',C,S,1));
% figure,imshow(D),title('低频分量');
% figure,imshow(H),title('高频分量');
% X=wrcoef2('all',C,S,'db1')
% figure,imshow(X),title('重构');
A=imread('E:\论文\PCNN\图片\4.2.jpg')
w1=[0.4000    0.3162   0.2828    0.3162    0.400
   0.3162    0.2000    0.1414    0.2000    0.3162    
   0.2828    0.1414         0    0.1414    0.2828    
   0.3162    0.2000    0.1414    0.2000    0.3162    
   0.4000    0.3162    0.2828    0.3162    0.4000]
%高斯滤波
w2=fspecial('gaussian',[5,5]);    %[ 5 5 ]是模板尺寸，默认是[ 3 3 ]  模板即上文所提的模板
w=w1.'*w2;%矩阵权重分配
D=imfilter(A,w);
figure,imshow(D);
% imwrite(D,'E:\论文\PCNN\图片\D.jpg')
% imwrite(D,'E:\论文\PCNN\图片\xtxb.jpg')
% a=uint8(wrcoef2('all',C,H,'db1',0));
% figure,imshow(a),title('0层重构');
% a1=uint8(wrcoef2('all',C,S,'db1',1));
% figure,imshow(a1),title('1层重构');
% a2=uint8(wrcoef2('all',C,S,'db1',2));
% figure,imshow(a2),title('2层重构');
