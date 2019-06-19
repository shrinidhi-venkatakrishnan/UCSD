clc;
x = dec2bin(0:1:2^10-1)-'0';   %generate random binary number
z=128;                         %given value of z
alpha=0.2;                     %given
wt=[];
cpt=[];
new_sample=[];
coeff=(1-alpha)/(1+alpha);  

for i=1:1024
    
    wt(1,i)=coeff*(alpha^(abs(z - i + 1)));   %to calculate the weight based on the formula
end

num = 0.0;
den = 0.0;
loc = 2;                    % loc value can be 2,4,6,8,10
iteration=100000;             %number of random samples
ANS=[];
for i=1:iteration
    randind = randi([1, 1024]); %generate a random number
    b = x(randind, :);          %convert it to corresponding binary from x

    if b(1,10-loc+1)==1         %if the bit in the desired position is 1
        I=1;                    %set I as 1
    else
        I=0;
    end
    anss=[];
    p = wt(1, randind);         %to compute the numerator and denominator using the formulae
    pi = p * I;
    num = num + pi;
    den = den + p;
    ans = num / den;
    ANS=[ANS, ans];              % to append the answers
  %     disp(ans);
end

plot(1:iteration,ANS);
xlabel('iterations');
ylabel(', P(Bi = 1|Z = 128)');
title('i=2,P(Bi = 1|Z = 128)=0.1955 @10^5 iteration');
% plotting iteration vs P(Bi = 1|Z = 128)
