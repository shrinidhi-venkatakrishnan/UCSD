%% 1

figure(1);
imshow(image);
title('original image')
%% 2
mag_res=abs(fftshift(fft2(image)));
F = 20*log10(mag_res); 
% F = mat2gray(F);
figure(2)
imshow(F,[]);colorbar();
title('magnitude response');
%% 3a, b
figure();
for i=1:4
subplot(2,2,i)   
imshow(real(filters(:,:,i)))
str = sprintf('real part filter at %d orientation', orientations(i));
title(str);
end

figure();
for i=1:4
subplot(2,2,i)   
imshow(imag(filters(:,:,i)))
str = sprintf('img part filter at %d orientation', orientations(i));
title(str);
end
%% 3c
b=[];
figure();
for i=1:4
b=abs(fftshift(fft2(filters(:,:,i))));
b=(20*log10(b)); 
subplot(2,2,i);
imshow(b,[]);
str = sprintf('mag res of filters at %d orientation', orientations(i));
title(str);
end
%% 3d

figure();
fil_img=zeros(350,932,4);
for i=1:4
    fil_img(:,:,i)=abs(conv2(image,filters(:,:,i),'same'));
    subplot(2,2,i);
    imshow(fil_img(:,:,i))
    str = sprintf('mag of filtered img at %d ', orientations(i));
    title(str);
end
%% 4
figure();
FINAL_IMG=fil_img(:,:,1)+fil_img(:,:,2)+fil_img(:,:,3)+fil_img(:,:,4);
imagesc(((FINAL_IMG)));
colormap gray
title('final image');

%% 5
mag_res_final=abs(fftshift(fft2(FINAL_IMG)));
F_FINAL = 20*log10(mag_res_final); 
% F = mat2gray(F);
figure()
imshow(F_FINAL,[]); colorbar;
title('magnitude response final');

    
    
