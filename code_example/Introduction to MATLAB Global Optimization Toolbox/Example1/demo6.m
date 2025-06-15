clc;clear all;

rf2 = @(x)rastriginsfcn(x/10); % objective
x0 = [20,30]; % start point away from the minimum
% Create an optimization problem structure.
problem = createOptimProblem('fmincon','objective',rf2,'x0',x0); 
gs = GlobalSearch;
[xg,fg,flg,og] = run(gs,problem)

% xg is the minimizing point.
% fg is the value of the objective, rf2, at xg.
% flg is the exit flag. An exit flag of 1 indicates all fmincon runs
% converged properly.
% og is the output structure, which describes the GlobalSearch calculations
% leading to the solution.
