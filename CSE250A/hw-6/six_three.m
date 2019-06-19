clear all;
close all;
spect_y=dlmread('spectY.txt');  %reading files
spect_x=dlmread('spectX.txt');
p=[];
count=0;
countz=[];
L=[];


for j=1:23               %checking the number of ones in each column
    count=0;
    for i=1:267    
       if(spect_x(i,j))==1
           count=count+1;
       end
    end
       countz=[countz count];
end

p=ones(267,23)*(1/23);    %initialising a p matrix to all ones
ITER=256;


lkinit=0;
ptt=ones(267,1);
for i=1:267
    for j=1:23
        ptt(i,1)=ptt(i,1)*(1-p(i,j))^spect_x(i,j); %noisy or
    end
end

lkinit=0;
for i=1:267
lkinit=log((1-spect_y(i,1))*(ptt(i,1))+(spect_y(i,1))*(1-ptt(i,1)))+lkinit; %0th iteration
end
lkinit=lkinit/267;
MIST=[];



for k=1:ITER
n=[];
d=ones(267,1);
prod=ones(267,23);
for i=1:267
    for j=1:23        %steps for posterior prob calculation
        n(i,j)=spect_y(i)*spect_x(i,j)*p(i,j);
        d(i)=d(i)*(1-p(i,j))^(spect_x(i,j));
    end
end

for i=1:267
    for j=1:23
        prod(i,j)=n(i,j)/(1-d(i));%posterior probability
    end
end
mistakes=0;

for i=1:267                          %to find the mistakes
    if((spect_y(i)==1 && (1-d(i)<=0.5))||(spect_y(i)==0&& (1-d(i)>=0.5)))
        mistakes=mistakes+1;
    end
end
MIST=[MIST mistakes];

% disp(k)
%%
%updation
new=zeros(1,23);
for j=1:23
    for i=1:267
        new(1,j)=prod(i,j)+new(1,j);  
    end
    new(1,j)=(1/countz(1,j))*new(1,j);   
end

p=repmat(new,[267 1]);

%%
%log likelihood
lk=0;
ptt=ones(267,1);
for i=1:267
    for j=1:23
        ptt(i,1)=ptt(i,1)*(1-p(i,j))^spect_x(i,j); %noisy or
    end
end
% 
lk=0;
for i=1:267
lk=log((1-spect_y(i,1))*(ptt(i,1))+(spect_y(i,1))*(1-ptt(i,1)))+lk; %log likelihood calculations
end
lk=lk/267;
L=[L lk];
p=repmat(new,[267 1]);
end       
Lfinal=[lkinit L];      %appending all the values of likelihood
MIST=[MIST mistakes];   %appending all the mistakes
disp('iterations maximum likelihood  mistakes')
ANS0=[0 Lfinal(1) MIST(1)];
ANS1=[1 Lfinal(2) MIST(2)];
ANS2=[2 Lfinal(3) MIST(3)];
ANS4=[4 Lfinal(5) MIST(5)];
ANS8=[8 Lfinal(9) MIST(9)];
ANS16=[16 Lfinal(17) MIST(17)];
ANS32=[32 Lfinal(33) MIST(33)];
ANS64=[64 Lfinal(65) MIST(65)];
ANS128=[128 Lfinal(129) MIST(129)];
ANS256=[256 Lfinal(257) MIST(257)];
disp(ANS0)
disp(ANS1)
disp(ANS2)
disp(ANS4)
disp(ANS8)
disp(ANS16)
disp(ANS32)
disp(ANS64)
disp(ANS128)
disp(ANS256)


