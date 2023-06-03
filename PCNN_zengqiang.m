%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I 原始图像 img1原始图像 img2原始图像归一化以后的图像 Idiffusion 输出图像
     
clc ;clear all;close all;
tic;
img=imread('E:\论文\PCNN\图片\对比\2\2-yuan.jpg');
figure,imshow(img);
ISSIM=im2double(img);
for j=17;
for k=1:3;
I=img(:,:,k);
[m,n]=size(I);

img1=im2double(I);
I1=double(img1);
I1=(I1-min(min(I1)))./(max(max(I1))-min(min(I1)));
minI1=min(min(I1));
maxI1=max(max(I1));
I2=(I1+1/255)/(maxI1+1/255);
minI2=min(min(I2));
t=11;                                   
th1=(1/(1-t))*log(min(min(I2)));        
th2=exp(-th1);                           
ve=(((1-exp(-th1*3)))./(1-th2))*th2;     
B=th2^2/4;
W=[0 1 0;
   1 0 1;
   0 1 0];
%^^^^^^^^^^^^^^^^^^
M=W;     Y=zeros(m,n);     F=Y;      L=Y;       U=Y;      E=Y;
%^^^^^^^^^^^^^^^^^^
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                                                     % (第三次设置预定迭代次数的位置）
Yzong=0;
Ienhance=zeros(m,n);
for i=1:t
   K=conv2(Y,M,'same');
   F=I2;
   if (i==2)
       for i1=1:m
           for j1=1:n
               if (i1==1 || i1==m || j1==1 || j1==n)
                   U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+1.33*B*K(i1,j1));
                   if(i1==1 && j1==1 || i1==1 && j1==n || i1==m && j1==1 || i1==m && j1==n)
                       U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+2*B*K(i1,j1));
                   end
               else
                   U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+B*K(i1,j1));  
               end
           end
       end
   else
        U=U*th2+F.*(1+B*K);
   end
   Y=double(U>E);
   E=th2*E+ve*Y*((th2^(-t)/(1-th2))^(sqrt(log2(i))));    % (第四次设置预定迭代次数的位置）
   UUU{1,i}=U;
   EEE{1,i}=E;         
   YYY{1,i}=Y;
   Ienhance=Y*(i-1)+Ienhance;
end
   Ienhan=t-Ienhance;                                                       % (第四次设置预定迭代次数的位置）
   Ienhan=(Ienhan-(min(min(Ienhan))))./((max(max(Ienhan)))-(min(min(Ienhan))));
   Izong=I1+0.5*Ienhan;                                                       % 关键算法1
   Izong=(Izong-(min(min(Izong))))./((max(max(Izong)))-(min(min(Izong))));        % 将整个图像增强结果归一化
   Ienzong{1,k}=Izong;
end
   toc;
   timezong(15)=toc;
   Ienzong=cat(3,Ienzong{1,1},Ienzong{1,2},Ienzong{1,3});
   Izongzeng=Ienzong;
end
figure,imshow(Izongzeng,[]);
%figure,imshow(ISSIM,[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imm=Izongzeng;
% imm=ISSIM;
Ymulzong=[];                                              % 神经元点火的总数
Iquan1=[];                                                % 量化图像的原始数值
Iquansim1=[];                                             % 量化图像的化简数值
Valuesep11=[];                                            % 化简数值与原始数值的对应矩阵（其中化简数值用行坐标表示，原始数值用行坐标对应的矩阵值表示）
Iimm=imm(:,:,3);                           %（关键点）
[m,n]=size(Iimm);
I1=double(Iimm);
I1=(I1-min(min(I1)))./(max(max(I1))-min(min(I1)));    % 采用特殊方法对图像进行归一化
minI1=min(min(I1));
maxI1=max(max(I1));
I2=(I1+1/255)/(maxI1+1/255);
minI2=min(min(I2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FCMSPCNN参数设置
t=11;                                   %(改改改） % 设定参数th2（alpha）(第一次设置预定迭代次数的位置）
th1=(1/(1-t))*log(min(min(I2)));        % 设定参数th2（alpha）(第二次设置预定迭代次数的位置）
th2=exp(-th1);                           
ve=(((1-exp(-th1*3)))./(1-th2))*th2;    % 设定参数th2（alpha）(第三次设置预定迭代次数的位置）
B=th2^2/4;
W=[0 1 0;
   1 0 1;
   0 1 0];
%^^^^^^^^^^^^^^^^^^
M=W;     Y=zeros(m,n);     F=Y;      L=Y;       U=Y;      E=Y;                                                                   
Yzong=0;
Ymul=zeros(m,n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FCMSPCNN模型实现
for i=1:t
   K=conv2(Y,M,'same');
   F=I2;
   if (i==2)
       for i1=1:m
           for j1=1:n
               if (i1==1 || i1==m || j1==1 || j1==n)
                   U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+1.33*B*K(i1,j1));
                   if(i1==1 && j1==1 || i1==1 && j1==n || i1==m && j1==1 || i1==m && j1==n)       % 第二次迭代参数Wijkl的设置方法
                       U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+2*B*K(i1,j1));
                   end
               else
                   U(i1,j1)=U(i1,j1)*th2+F(i1,j1).*(1+B*K(i1,j1));  
               end
           end
       end
   else
        U=U*th2+F.*(1+B*K);
   end
   Y=double(U>E);
   E=th2*E+ve*Y*((th2^(-t)/(1-th2))^(sqrt(log2(i))));    % (第四次设置预定迭代次数的位置）
   UUU{1,i}=U;                                           % 保存内部活动项的所有信息
   EEE{1,i}=E;                                           % 保存动态阈值的所有信息
   YYY{1,i}=Y;                                           % 保存每次迭代神经元点火的所有信息
 
   %if(i>1)
   %Yzong=Yzong+sum(sum(YYY{1,i}));
   %Yfire(j,k)=Yzong;                                     % 记录神经元在每个通道内的点火总数
end
  figure,imshow(YYY{1,11},[]);  
  imwrite(Izongzeng,'E:\论文\PCNN\图片\对比\2\1.1.jpg');
  
