clear all, close all

options(1)=1;
[x,y]=ga(16,20,'fit_func2',options);
f='f_peaks';
xrange=[-3,3];
yrange=[-3,3];
L=length(x);
x1=bin2dec(x(1:L/2),xrange);
x2=bin2dec(x(L/2+1:L),yrange);
disp('GA Solution:');
disp([x1,x2]);
disp('Objective function value:');
disp(y);