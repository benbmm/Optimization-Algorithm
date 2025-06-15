function y=fit_func1(binchrom);
%1-D fitness function

f='f_manymax';
range=[-10,10];
x=bin2dec(binchrom,range);
y=feval(f,x);