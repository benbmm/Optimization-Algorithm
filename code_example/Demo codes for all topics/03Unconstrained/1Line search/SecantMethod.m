%The Secant Method
clc;close all;clear all;

syms x;
% Enter the Function here
f=x*exp(x)-1;

% plot the function
t=0:0.01:10;
v=zeros(1,length(t));

for i=1:length(t)
    v(i)=vpa(subs(f,x,t(i)));
end
plot(t,v)

% Set the precision
n=input('Enter the number of decimal places:');
epsilon = 5*10^-(n+1)

% Select the initial two points
x0 = input('Enter the 1st approximation:');
x1 = input('Enter the 2nd approximation:');
for i=1:100
 f0=vpa(subs(f,x,x0)); %Calculating the value of function at x0
    f1=vpa(subs(f,x,x1)); %Calculating the value of function at x1
y=x1-((x1-x0)/(f1-f0))*f1; %[x0,x1] is the interval of the root
err=abs(y-x1);
if err<epsilon %checking the amount of error at each iteration
break
end
x0=x1;
x1=y;
end
y = y - rem(y,10^-n); %Displaying upto required decimal places
fprintf('The Root is : %f \n',y);
fprintf('No. of Iterations : %d\n',i);