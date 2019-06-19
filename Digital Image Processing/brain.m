%% SHRINIDHI A53272452
%LAB 4
%%
clc;
close all;
clear all;

img=imread('brain.tif');  %read the input image
[row,col]=size(img);      %get the size of the image
img2=zeros(row,col);      
[counts,binLocations]=imhist(img); %get the number of pixels in each intensity level
pdf=(counts/sum(counts));          %prob that a particular intensity level occurs
figure();
stem(pdf);
title('normalised histogram of the image');
ylabel('number of pixels');
xlabel('0 to 255 gray scale intensity levels');
axis tight;
%%
figure();
cdf1=cumsum(pdf);
stem(cdf1);
title('cumulative distributive function');
xlabel('0 to 255 gray scale intensity levels');
ylabel('sum of counts till that bin');
axis tight;
%%
heq=round(cdf1*255);
stem(heq,pdf);
title('histogram equalisation');
axis tight;
xlabel('0 to 255 gray scale intensity levels');
ylabel('probability');

for i =1:row
    for j=1:col
            img2(i,j)=heq(img(i,j)+1,1);
    end
end
img2=uint8(img2);
imshow(img2);
title('histogram equalised image');
%% for noise removal

heq2=round(cumsum(pdf)*255);
heq2(1:14)=heq2(15);
image_hist=zeros(row,col);
x=0:1:255;
for i= 1:256
    B = img==x(i);
    image_hist(B)= heq2(i);
end
 figure, imshow((image_hist),[]);
 title('Heq image')

