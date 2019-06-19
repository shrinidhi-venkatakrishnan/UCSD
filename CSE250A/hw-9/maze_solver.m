clear all;
close all;
transmat_1=dlmread('prob_a1.txt');
transmat_2=dlmread('prob_a2.txt');
transmat_3=dlmread('prob_a3.txt');
transmat_4=dlmread('prob_a4.txt');
rewards=dlmread('rewards.txt');

v=zeros(81,1);
action=[1 2 3 4];
initial_policy=ones(81,1);
pp_pi=zeros(81,81);

for j=1:187
 
 
 
% for i=1:81
%     for j=1:81
%     if (initial_policy(i)==1)
%         pp_pi(i,j)=transmat_1(i,j);
%     end
%     if (initial_policy(i)==2)
%         pp_pi(i,j)=transmat_2(i,j);
%     end
%     if (initial_policy(i)==3)
%         pp_pi(i,j)=transmat_3(i,j);
%     end
%     if (initial_policy(i)==4)
%         pp_pi(i,j)=transmat_4(i,j);
%     end
%     end
% end
for i=1:81
    v(i)=inv(eye(81)-(0.99*pp_pi))*rewards(i);
end

for i=1:81
    if(v(i)~=0)
        for row=1:9
            for col=1:9
                if pie(i)==1
                    disp(i);
                    disp('EAST');
                    disp('');
                    end
    if(pie(i)==2)
        disp(i)
        disp('SOUTH');
        disp('');
    end
    if pie(i)==3
        disp(i)
        disp('WEST');
        disp('');
    end
    if pie(i)==4
        disp(i)
        disp('NORTH');
        disp('');
    end
    end
end




