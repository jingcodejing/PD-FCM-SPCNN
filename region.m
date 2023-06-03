clear all;
close all;clc;
SrcImage=imread('E:\ÂÛÎÄ\PCNN\Í¼Æ¬\16.4.jpg');
imshow(SrcImage)
grabImage=rgb2gray(SrcImage);
figure,imshow(grabImage),title('grabImage');
rect=[160,293,100,100];
paddingValue=1;%ºÚÉ«Ìî³ä
destImg=ImageCropPadding(SrcImage,rect,paddingValue);
figure,imshow(destImg),title('destImg');
