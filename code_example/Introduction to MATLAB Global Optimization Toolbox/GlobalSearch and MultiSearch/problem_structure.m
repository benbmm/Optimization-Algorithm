clear all, close all

sixmin = @(x)(4*x(1)^2 - 2.1*x(1)^4 + x(1)^6/3 ...
    + x(1)*x(2) - 4*x(2)^2 + 4*x(2)^4);

A = [-1,-2];
b = -4;

opts = optimoptions(@fmincon,'Algorithm','interior-point');

problem = createOptimProblem('fmincon', ...
    'x0',[2;3],'objective',sixmin, ...
    'Aineq',A,'bineq',b,'options',opts)

[x,fval,eflag,output] = fmincon(problem);