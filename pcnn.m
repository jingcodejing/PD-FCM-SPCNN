
function [Out,count]=pcnn(X)
figure(1);
imshow(X); 
X=double(X);
% 设定权值
% Weight=[0.3 0.4 0.3;0.3 0 0.3;0.3 0.4 0.3]; 
Weight=[0.07 0.1 0.07;0.1 0 0.1;0.07 0.1 0.07];
WeightLI2=[-0.03 -0.03 -0.03;-0.03 0 -0.03;-0.03 -0.03 -0.03];
d=1/(1+sum(sum(WeightLI2)));
WeightLI=[-0.03 -0.03 -0.03;-0.03 0.5 -0.03;-0.03 -0.03 -0.03];
d1=1/(sum(sum(WeightLI)));
%%%%%%%%%%%%%%%%%%
Beta=0.4;  
Yuzhi=245;
%衰减系数
Decay=0.3;   
[a,b]=size(X);
V_T=0.2;
%门限值
Threshold=zeros(a,b);  
S=zeros(a+2,b+2);
Y=zeros(a,b);
%点火频率
Firate=zeros(a,b); 
n=1;
%统计循环次数
count=0; 
Tempu1=zeros(a,b); 
Tempu2=zeros(a+2,b+2); 
%%%%%%%%%%%%%%%%%%
Out=zeros(a,b);
Out=uint8(Out);
%图像特征增强
for i=1:a
for j=1:b
 if(i==1|j==1|i==a|j==b)
  Out(i,j)=X(i,j);
 else  
  H=[X(i-1,j-1)  X(i-1,j) X(i-1,j+1);
     X(i,j-1)   X(i,j)   X(i,j+1);
    X(i+1,j-1) X(i+1,j) X(i+1,j+1)]; 
 temp=d1*sum(sum(H.*WeightLI));
 Out(i,j)=temp;
 end
 end
end
figure(2);
imshow(Out); 
%%%%%%%%%%%%%%%%%%%
for count=1:30 
 for i0=2:a+1
    for i1=2:b+1
         V=[S(i0-1,i1-1)  S(i0-1,i1) S(i0-1,i1+1);
             S(i0,i1-1)   S(i0,i1)   S(i0,i1+1);
             S(i0+1,i1-1) S(i0+1,i1) S(i0+1,i1+1)];
           L=sum(sum(V.*Weight)); %L连接输入，L=∑W*V
           V2=[Tempu2(i0-1,i1-1)  Tempu2(i0-1,i1) Tempu2(i0-1,i1+1);
               Tempu2(i0,i1-1)   Tempu2(i0,i1)   Tempu2(i0,i1+1);
               Tempu2(i0+1,i1-1) Tempu2(i0+1,i1) Tempu2(i0+1,i1+1)];
           F=X(i0-1,i1-1)+sum(sum(V2.*WeightLI2)); %F反馈输入，F(n)=X(n-1)+∑W2*V2
%保证侧抑制图像无能量损失
F=d*F; 
U=double(F)*(1+Beta*double(L));                          
Tempu1(i0-1,i1-1)=U;
    if U>=Threshold(i0-1,i1-1)|Threshold(i0-1,i1-1)<60
      T(i0-1,i1-1)=1;
      Threshold(i0-1,i1-1)=Yuzhi;
       %点火后一直置为1
Y(i0-1,i1-1)=1;    
     else
        T(i0-1,i1-1)=0;
        Y(i0-1,i1-1)=0;
                 end
            end
         end
   Threshold=exp(-Decay)*Threshold+V_T*Y;
   %被**过的像素不再参与迭代过程
     if n==1
        S=zeros(a+2,b+2);
        else
        S=Bianhuan(T);
     end
     n=n+1;
     count=count+1; 
    figure(3);
    imshow(Y);
end
%  imwrite(Y,'E:\论文\PCNN\图片\10.4.jpg');

