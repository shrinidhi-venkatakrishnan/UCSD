%% ECE 253 Lab 3 Homework
%Shrinidhi Venkatakrishnan, A53272432
close all;
clc;
IMAGE=im2double(imread('slant_edge.tif'));  %reading an image
[row,col]=size(IMAGE);
[Gx,Gy] = imgradientxy(IMAGE,'central');    %finding the central gradient
MEAN=mean(IMAGE,'all');                     %mean   
XVAL=[];
YVAL=[];
for r=1:row
    XX=[];
    for c=1:col
        if(Gx(r,c)>(MEAN/2))                %finding the pixel intensity greater than half the mean value
            XX=[XX c];                      %appending index position
        end
    end
    YY=mean(XX);
    XVAL=[XVAL YY];
    
end
for i=1:col
    YVAL(i)=i;
end
%%
A=[];
B=[];
coefficients = polyfit(YVAL,XVAL, 1);        %polyfit formula
a = coefficients (1);                        %line parameters
b = coefficients (2);                        %line parameters
x=(a)*YVAL+b;
figure();
imshow(IMAGE)
h=line(x,YVAL,'Color','red');
imwrite(IMAGE,'superimposed image.jpg')
title('superimposed image');
%%
xf=[];
xif=[];
for i=1:64
    for j=1:64                   %projection formulae
        xf=a*YVAL(1,i);
        xif(i,j)=round(4*(j-xf));
    end
end
binv=zeros(1,300);
binc=zeros(1,300);
for i=1:64                        %binning formulae
    for j=1:64
        binv(1,xif(i,j))=binv(1,xif(i,j))+IMAGE(i,j);
        binc(1,xif(i,j))=binc(1,xif(i,j))+1;
    end
end
bin_avg=zeros(1,300);
for i =1:300
    if binc(1,i)~=0
    bin_avg(1,i)=binv(1,i)/binc(1,i);        %bin average formula
    end
end
bin_avg(284:300)=bin_avg(283); %interpolation
bin_avg(1:3)=bin_avg(4);       %interpolation
plot(bin_avg);
axis tight
title('bin average');
ylabel('esf')
xlabel('pixel');
%%    
lin=[];
for i=2:299           %line spread function
    lin(i)=(bin_avg(i+1)-bin_avg(i-1))/2;
end
figure()
plot(lin);
axis tight;
title('line spread function');
xlabel('pixels');
ylabel('line spread function');
%%
winvec = hamming(length(length(lin)),'periodic');  %smoothening
xdft = (fft2(lin'.*winvec));    %fft to get spatial frequency response
figure();
length1=299;
xx=1:1:length1/2;
xx=xx/(length1/4);
xdft=(xdft-min(xdft))/((max(xdft)-min(xdft))); %normalisation
plot(xx(1,:),abs(xdft(1:length(xx)))) %plotting the spatial frequency response
title('cycles per pixel vs sfr');
xlabel('cycles per pixel')
ylabel('sfr');
%%
sfr_2=abs(xdft(1:149,1));
rayop2=interp1((sfr_2(:,1)),xx(1,:),0.1,'previous');%interpolate to get value of 0.1
disp('the nyquist frequency is 0.5 or the sampling resolution is 64*0.5*2=64pixels ');
disp('the rayleigh scattering is ');
disp(rayop2);
