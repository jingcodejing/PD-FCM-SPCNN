% 参数设置
I1=imread('E:\weizhishibie\青海湖\z+pcnn.png');
%for j=1:16
tic;
% str1=[Ifile1,num2str(k(j)),'.png'];
%imm=imread(I1); 
imm=I1;
Ymulzong=[];                                              % 神经元点火的总数
Iquan1=[];                                                % 量化图像的原始数值
Iquansim1=[];                                             % 量化图像的化简数值
Valuesep11=[];                                            % 化简数值与原始数值的对应矩阵（其中化简数值用行坐标表示，原始数值用行坐标对应的矩阵值表示）
Iimm=imm(:,:,1);                           %（关键点）
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
t=11;
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

SE=strel('disk',1);      %gai
YYY{1,2}=imopen(YYY{1,2},SE);
YYY{1,2}=imfill(YYY{1,2},'holes');
Ifile2='E:\weizhishibie\青海湖\z+xb+lvbo+pc.png';
str2=[Ifile2,'.png'];
imwrite(YYY{1,2},str2);
str3=[Ifile2,'.tif'];
I=imm(:,:,1);
imwrite(imm,str3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 确定边界的形状
F=I;
YYYedge=bwboundaries(YYY{1,2});
xYYY=YYYedge{1,1}(:,1);
yYYY=YYYedge{1,1}(:,2);
figure,imshow(I,[]);
for i=1:length(xYYY)
hold on;
plot(yYYY(i),xYYY(i),'r.');                                        % 画原始图像的综合区域
%drawnow;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 区域对比度
objectvalue=0;
objectnumber=0;
objectnum=0;
backgroundvalue=0;
backgroundnumber=0;
for k1=1:m
    for l1=1:n
        if(YYY{1,2}(k1,l1)==1)
            objectvalue=objectvalue+I1(k1,l1);
            objectnumber=objectnumber+1;
            objectnum(objectnumber)=I1(k1,l1);
        else    
            backgroundvalue=backgroundvalue+I1(k1,l1);
            backgroundnumber=backgroundnumber+1;
        end    
    end
end    
objectmean=objectvalue/objectnumber;
backgroundmean=backgroundvalue/backgroundnumber;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 区域均匀性
UM=0;
k=1;
for i1=1:m
    for j1=1:n
        if(YYY{1,2}(i1,j1)==1)
            UM=(I1(i1,j1)-objectmean)^2+UM;
        else
            UM=(I1(i1,j1)-backgroundmean)^2+UM;
        end
    end   
end
UMzong(k)=1-(UM/(m*n));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目标区域均值
Omean(k)=objectmean;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目标区域方差
Ostd2(k)=std2(objectnum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 计算手动分割区域的面积和几个评价指标（overlap sen)
imgImanual=zeros(m,n);
imgintersect=zeros(m,n);
str1=[Ifile1,num2str(r(k)),'.png'];
Imanual=imread(str1);
Imanual=Imanual(:,:,1);
for i=1:m
    for j=1:n
        if(Imanual(i,j)==204)
            imgImanual(i,j)=1;
        end
    end
end    
imgImanual=imfill(imgImanual,'holes');
imgImanual=bwlabel(imgImanual,8);
stats=regionprops(imgImanual,'all');
Imanualarea=[stats.Area];                                                  % 获得医师手绘结石的结果
indexImanualarea=find(Imanualarea==max(Imanualarea));
imgImanual=ismember(imgImanual,indexImanualarea);
IPAPCNN=YYY{1,2};
for i=1:m
    for j=1:n
        if(imgImanual(i,j)==1 && IPAPCNN(i,j)==1)
            imgintersect(i,j)=1;                           % 交集的面积
        end
    end
end    
  Overlaparea(k)=sum(sum(imgintersect))/sum(sum(IPAPCNN));
  Searea(k)=sum(sum(imgintersect))/sum(sum(imgImanual));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UMzong(k)
Omean(k)
Ostd2(k)
Overlaparea(k)
Searea(k)
UMzong1=sum(UMzong)/k;
Omeanzong=sum(Omean)/k;
Ostd2zong=sum(Ostd2)/k;
Overlapareazong=sum(Overlaparea)/k;
Seareazong=sum(Searea)/k;
UMzong1
Omeanzong
Ostd2zong
Overlapareazong
Seareazong

  figure,imshow(YYY{1,11},[]);                            %(改改改）
%   imwrite(YYY{1,11},'D:/weizhishibie/img/01/tiqu.jpg');
%Idanchu=YYY{1,2};
%Istr=[Ifile2,num2str(j),'.jpg'];           % 将点火图像储存到文件指定的位置
%imwrite(Idanchu,Istr);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%[Icurow Icucol]=find(Idanchu5==1);
%Icudanu=min(Icurow);                                                       % 得到粗分割胆囊区域的最上边像素的横坐标
%Icudand=max(Icurow);                                                       % 得到粗分割胆囊区域的最下边像素的横坐标
%Icudanl=min(Icucol);                                                       % 得到粗分割胆囊区域的最左边像素的横坐标
%Icudanr=max(Icucol);                                                       % 得到粗分割胆囊区域的最右边像素的横坐标
%Icudanx=max(1,Icudanu-round(m/5));                                        % 得到剪裁图像最上边的坐标
%Icudany=max(1,Icudanl-round(n/5));                                        % 得到剪裁图像最左边的坐标
%xw=Icudand-Icudanx+min(round(m/5),(m-Icudand));                           % 得到剪裁图像的宽
%yl=Icudanr-Icudany+min(round(n/5),(n-Icudanr));                           % 得到剪裁图像的长 

%end


