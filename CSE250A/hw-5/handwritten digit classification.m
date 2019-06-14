%shrinidhi.v : A53272432
clear all;
close all;
TestSET=[];
dd = 64;
train3=dlmread('new_train3.txt'); %TRAINING DATASET
train5=dlmread('new_train5.txt');
TRAINSET = [train3; train5];      %TOTAL TRAINING DATA
Y=[zeros(size(train3,1),1); ones(size(train5,1),1)];  %Output can be either zero or one
wt=zeros(64,1);  %weights for the 64bits
eta=0.001/1400;
iteration=100000;
%%
%%TRAIN
for i=1:iteration
    p=sigmoid(TRAINSET*wt);  %sigmoid function is called
    L(i)= sum((Y.*log(p))+((1-Y).*log(1-p)));  %log likelihood
    grad = TRAINSET'*(Y-p);      % gradient calculation
    wt=wt+(eta*grad);            %weight updation
end

plot(L)                           %plotting the graph
title('iteration vs log likelihood');
xlabel('iteration')
ylabel('log likelihood');
eightColumnMatrix = vec2mat(wt,8);


%%
%%TEST images

test3=dlmread('new_test3.txt');
test5=dlmread('new_test5.txt');
Testset = [test3; test5];  %test dataset
prod=Testset*wt;           %weight multiplied with testdata
p1=sigmoid(prod);          %sigmoid function
countr=0;                  %counter 
countrr=0;
for i=1:400                
    if p1(i)>0.5
        countr=countr+1;
    end
end
for i=401:800
    if p1(i)<0.5
        countrr=countrr+1;
    end
end
ERROR=(countrr+countr)/800;
ERROR=ERROR*100;          %error percentage calculation
print(ERROR);
