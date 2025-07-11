clear all, close all

% % Set the random stream to get exactly the same output
% rng(14,'twister')
% Create solver object
ms = MultiStart;

% Create problem structure
opts = optimoptions(@fmincon,'Algorithm','interior-point');
sixmin = @(x)(4*x(1)^2 - 2.1*x(1)^4 + x(1)^6/3 ...
    + x(1)*x(2) - 4*x(2)^2 + 4*x(2)^4);
problem = createOptimProblem('fmincon','x0',[-1,2],...
    'objective',sixmin,'lb',[-3,-3],'ub',[3,3],...
    'options',opts);

% Run the solver
[xminm,fminm,flagm,outptm,manyminsm] = run(ms,problem,50)

% Inspect multiple solutions
manyminsm.Fval
manyminsm(1).X0
histogram([manyminsm.Fval],10)