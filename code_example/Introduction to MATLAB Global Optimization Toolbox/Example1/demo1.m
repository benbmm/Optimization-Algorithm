clc;clear all;

rf2 = @(x)rastriginsfcn(x/10); % objective
x0 = [20,30]; % start point away from the minimum
[xf,ff,flf,of] = fminunc(rf2,x0)

% xf is the minimizing point.
% ff is the value of the objective, rf2, at xf.
% flf is the exit flag. An exit flag of 1 indicates xf is a local minimum.
% of is the output structure, which describes the fminunc calculations
% leading to the solution.
