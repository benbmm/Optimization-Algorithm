function y=fit_func2(binchrom);
%2-D fitness function

f='f_peaks';
xrange=[-3,3];
yrange=[-3,3];
L=length(binchrom);
x1=bin2dec(binchrom(1:L/2),xrange);
x2=bin2dec(binchrom(L/2+1:L),yrange);
y=feval(f,[x1,x2]);