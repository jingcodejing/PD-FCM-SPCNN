I=imread('E:\论文\PCNN\图片\3.1.jpg');  
figure   
 imshow(I);title('yuan')  
  
  
[ca,ch,cv,cd]=dwt2(I,'db1');  
X=imadjust(uint8(ca),[],[],1.5);  
xx=idwt2(uint8(X),ch,cv,cd,'db1');  
figure   
imshow(uint8(xx));  
% imwrite(uint8(xx),'E:\论文\PCNN\图片\3.2.jpg'); 
