%% 
clc;
close all;
clear all;

[cfa,info]=read_dng('lab1.dng');                  %READ THE IMAGE  
subplot(3,1,1)
imshow(cfa,[])                                    %PLOTTING THE COLOR FILTER ARRAY
title('cfa');
%%
cfalin2=(cfa-info.black)/(info.white-info.black); % LINEARISATION
cfalin=im2uint8(cfalin2);                         %CONVERSION TO UNSIGNED INTEGER
subplot(3,1,2)
imshow(cfalin)                                    %PLOTTING CFA AFTER LINEARISATION
title('Linearized image')

%%
J = im2double(demosaic(cfalin,'gbrg'));           %DEMOSAICING USING BAYER PATTERN AND CONERTING INTO DOUBLE
subplot(3,1,3)
imshow(J)                                         %PLOTTING AFTER DEMOSAICING
title('Demosaic image');
%%
load('colorchecker.txt');                         %LOADING THE DATA GIVEN
load('patch_coor.txt');
%%
j=1;
X=[];
final=[];
  
for i=1:4:93
    % EXTRACTING THE COORDINATES OF THE FOUR POINT 
    c1=patch_coor(i,1);                    
    c2=patch_coor(i+1,1);
    c3=patch_coor(i+2,1);
    c4=patch_coor(i+3,1);
    
    r1=patch_coor(i,2);
    r2=patch_coor(i+1,2);
    r3=patch_coor(i+2,2);
    r4=patch_coor(i+3,2);
    
    % RED COLOR EXTRACTION FROM THE FOUR POINTS
    red1=J(r1,c1,1);
    red2=J(r2,c2,1);
    red3=J(r3,c3,1);
    red4=J(r4,c4,1);
    r= (red1+red2+red3+red4)/4;    %RED MEAN
    R = reshape(r,[],1);           %FORMING A COLUMN VECTOR

   % GREEN COLOR EXTRACTION FROM THE FOUR POINTS
    g1=J(r1,c1,2);
    g2=J(r2,c2,2);
    g3=J(r3,c3,2);
    g4=J(r4,c4,2);
    g= (g1+g2+g3+g4)/4;   %GREEN MEAN
    G = reshape(g,[],1);  %FORMING A COLUMN VECTOR

    % BLUE COLOR EXTRACTION FROM THE FOUR POINTS
    b1=J(r1,c1,3);
    b2=J(r2,c2,3);
    b3=J(r3,c3,3);
    b4=J(r4,c4,3);
    b= (b1+b2+b3+b4)/4;     %BLUE MEAN
    B = reshape(b,[],1);    %FORMING A COLUMN VECTOR

    
    X = [R, G, B];         
    final=vertcat(final,X); %CONCATENATION OF THE FINAL RGB VALUES
     
 end

Y=colorchecker./255;                                   %MAKING THE COLORCHECKER VALUES FROM 0 TO 1

ans1=inv(transpose(final)*final)*transpose(final)*Y;   %CONVERSION MATRIX FORMULA
%%
[rowf,colf]=size(J);
a=[];
R=[];
for i=1:1:2704 
    for j=1:1:4064
         a=[J(i,j,1);J(i,j,2);J(i,j,3)];
         a=double(a);
         R= transpose(ans1)*(a);   %FORMULAE FOR SRGB FROM DEVICE RGB
         
          FFF(i,j,1)=R(1,1);
          FFF(i,j,2)=R(2,1);
          FFF(i,j,3)=R(3,1);       %RESULTANT MATRIX AFTER PROPER CONCATENATION
    end
end

figure()
imshow((FFF.^(1/2.2)));            % GAMMA CORRECTION
title('RESULTANT sRGB IMAGE');

    
    


