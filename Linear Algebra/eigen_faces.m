clc;
close all;
clear all;
I_vect=zeros(193*162,190);
M = 190; % number of images
for n=1:M
  img = imread(strcat(num2str(n),'a','.jpg')); %read image
  img = im2double((img)); % convert image to double precision
  [row,col] = size(img); % get number of rows and columns in image
  I_vect(:,n) = img(:); % convert image to vector and store as column in matrix I_vect
end
I_mean = mean(I_vect,2);
phi = I_vect-repmat(I_mean,1,M);
cov=(phi*phi')/190;
cov2=(phi'*phi)/190;
%%
[vector value]=eig(cov2); %to get the eigen value and eigen vector
vector_needed=phi*vector;
 
for i=1:size(vector_needed,2)         %access each column
   kk=vector_needed(:,i);
   temp=norm(kk);
   vector_needed(:,i)=vector_needed(:,i)./temp; %normalising ui such that its norm is equal to one
end 
 
value_1d=[];
for i=1:190
        maxz=max(value(i,:));
        value_1d=[value_1d maxz];
end
value_sort=sort(value_1d,'descend');
indexx=[];
num=input('enter k value');
for i=1:num
    [random,result] = find(value_1d==value_sort(1,i));
    indexx=[indexx result];
end
uj=[];
for j=1:num
    eigen_vector=vector_needed(:,indexx(j));
    uj=[uj eigen_vector];
end
omg=[];
for i=1:num
    omega=uj(:,i)'*phi(:,i);
    omg=[omg omega];
end
omg=omg';
 

%%RECONSTRUCTION
img = im2double((imread('198a.jpg'))); 
% img=imrotate(img,180);
% test=rgb2gray(im2double(imread('carz.jpg')));
% img=imcrop(test,[0.5 149.5 600 305]);
% img=imresize(img,[193,162]);
I_test = img(:); 
I_test = I_test-I_mean; % subtract mean images
I_test_weights = zeros(num,1); %calculate weights of test image
I_test_weights=uj’*I_test;
I_reconstruct = I_mean + uj*I_test_weights;   %offset by mean scaling and summation
I_reconstruct = reshape(I_reconstruct, row,col); %reshape reconstructed test image
 
figure();
subplot(1,2,1);
imshow(img);
title('Original test image');
subplot(1,2,2)
imshow(I_reconstruct,[]);
title('Reconstructed test image');

