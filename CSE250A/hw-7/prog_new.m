%cse_250a 7.1
%shrinidhi venkatakrishnan A53272432
A=dlmread('transitionMatrix.txt');   %reading the files
B=dlmread('emissionMatrix.txt');
pi=dlmread('initialStateDistribution.txt');
o=dlmread('observations.txt');

l=zeros(27,325000);                  %log probability 
l(:,1)=log(pi(:,1))+log(B(:,o(1)+1));
T=325000;
ARGIN=zeros(27,325000);
PHI=zeros(27,T);                     %phi matrix
for t=1:T-1
    for j=1:27
        l(j,t+1)=max(l(:,t)+log(A(:,j)))+log(B(j,o(t+1)+1));
        ARGIN=(l(:,t)+log(A(:,j)));
        [value,phi]=max(ARGIN);      %index of the maximum value
        PHI(j,t+1)= phi;             %phi matrix
    end
end
%%
stfinal=zeros(1,T);
[value2, sT] = max(l(:,T));  %index of the maximum value of the Tth column
stfinal(1,T)=sT;
for p=T-1:-1:1
sT=PHI(stfinal(1,p+1),p+1);  %st state prediction from phi matrix
stfinal(1,p)=sT;
end
STFINAL=[];
STFINAL(1,1)=20;
for j=2:T                    %if the values are repeating make it as one value
    if(stfinal(j)-stfinal(j-1))==0
        continue;
    else
        STFINAL=[STFINAL stfinal(j)];
    end
end
plot(stfinal);                %plotting hidden state vs time
title('most likely sequence of hidden states versus time');
xlabel('time');
ylabel('most likely state');
Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
letters=Alphabet(STFINAL)

    
        


