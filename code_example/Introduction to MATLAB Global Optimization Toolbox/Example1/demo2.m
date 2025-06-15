clc;clear all;

rf2 = @(x)rastriginsfcn(x/10); % objective
x0 = [20,30]; % start point away from the minimum
[xp,fp,flp,op] = patternsearch(rf2,x0)

% xp is the minimizing point.
% fp is the value of the objective, rf2, at xp.
% flp is the exit flag. An exit flag of 1 indicates xp is a local minimum.
% op is the output structure, which describes the patternsearch
% calculations leading to the solution.
