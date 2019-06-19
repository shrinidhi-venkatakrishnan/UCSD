close all;
clear all;
x0=[-10 -20 -30 -40 -50 -60];  %data given for x axis shifts
y0=[-10 -20 -30 -40 -50 -60];  %data given for y axis shifts
f1=[];
f2=[];
length1=size(x0);
length2=size(y0);
k=0.001;                       %spatial frequency

[X,Y] = meshgrid(-100:1:100, -100:1:100);  %to create the initial Fresnel zone plate
        F1= 0.5+0.5*cos(2*pi*k*(X.^2+Y.^2));
        imwrite(F1,'F1.jpg')

     %% shifted image  
 [X1,Y1]=meshgrid(-100:1:100, -100:1:100);  %creating shifted zone plates
         F21=0.5+0.5*cos(2*pi*k*((X1+10).^2+(Y1+10).^2));
         F22=0.5+0.5*cos(2*pi*k*((X1+20).^2+(Y1+20).^2));
         F23=0.5+0.5*cos(2*pi*k*((X1+30).^2+(Y1+30).^2));
         F24=0.5+0.5*cos(2*pi*k*((X1+40).^2+(Y1+40).^2));
         F25=0.5+0.5*cos(2*pi*k*((X1+50).^2+(Y1+50).^2));
         F26=0.5+0.5*cos(2*pi*k*((X1+60).^2+(Y1+60).^2));
        imwrite(F21,'shift1.jpg')
        imwrite(F22,'shift2.jpg')
        imwrite(F23,'shift3.jpg')
        imwrite(F24,'shift4.jpg')
        imwrite(F25,'shift5.jpg')
        imwrite(F26,'shift6.jpg')
        
       %%
       %creating superimposed fresnel zone plates
        S1=(F1.*F21);        
        imwrite(S1,'impose1.jpg')
        
        S2=(F1.*F22);
        imwrite(S2,'impose2.jpg')
        
        S3=(F1.*F23);
       imwrite(S3,'impose3.jpg');
        
        S4=(F1.*F24);
        imwrite(S4,'impose4.jpg')
        
        S5=(F1.*F25);
        imwrite(S5,'impose5.jpg')
        
        S6=(F1.*F26);
        imwrite(S6,'impose6.jpg')
        
        %%
        %%deriving the spatial frequency at each point by taking fft and
        %%fftshift( fftshift is useful for visualizing the Fourier
        %%transform with the zero-frequency component in the middle of the spectrum.)
        S1f=fft2(S1);
        S1f=fftshift(S1f);
        imwrite(S1f,'fft1.jpg')
        S2f=fft2(S2);
        S2f=fftshift(S2f);
        imwrite(S2f,'fft2.jpg')
        S3f=fft2(S3);
        S3f=fftshift(S3f);
        imwrite(S3f,'fft3.jpg')
        S4f=fft2(S4);
        S4f=fftshift(S4f);
        imwrite(S4f,'fft4.jpg')
        S5f=fft2(S5);
        S5f=fftshift(S5f);
        imwrite(S5f,'fft5.jpg')
        S6f=fft2(S6);
        S6f=fftshift(S6f);
        imwrite(S6f,'fft6.jpg')

        S=[S1f;S2f;S3f;S4f;S5f;S6f];
        
        %% moire
        m=1;
        n=201;
        for i=1:6
        u=round(2*k*(x0(i))*201);   %finding the coordinates of the frequency by the formula
        v=round(2*k*(x0(i))*201);
        Ss=S(m:n,:);         %matrices of fft matrices
        m=m+201;
        if n<=201*6
        n=n+201;
        freq1=Ss(101-u,101-v); %calculating freq1
        freq2=Ss(101+v,101+u);%calculating corresponding symmetrical frequency
        
        mat=zeros(201,201);
        mat(101-u,101-v)=abs(freq1); %adding only those two frequencies to a null matrix
        mat(101+u,101+u)=abs(freq2);
        matfinal1=(mat-min(mat(:)))/(max(mat(:)-min(mat(:)))); %normalisation
        filename = sprintf('frequency%d.jpg', i) ;
        imwrite(matfinal1, filename, 'jpg') ;       %writing in a file
        
        matfinal11=ifft2(ifftshift(matfinal1)); %inverse fft to get recovered moire pattern
        matfinal11=(matfinal11-min(matfinal11(:)))/(max(matfinal11(:)-min(matfinal11(:))));
        filename = sprintf('moire%d.jpg', i) ;
        imwrite(matfinal11, filename, 'jpg') ;       %writing in a file
        end
        end
        
      
