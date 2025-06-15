clc;clear all;

rng default % for reproducibility
rf2 = @(x)rastriginsfcn(x/10); % objective
x0 = [20,30]; % start point away from the minimum
initpop = 10*randn(20,2) + repmat(x0,20,1);
opts = optimoptions('ga','InitialPopulationMatrix',initpop);
[xga,fga,flga,oga] = ga(rf2,2,[],[],[],[],[],[],[],opts)

% xga is the minimizing point.
% fga is the value of the objective, rf2, at xga.
% flga is the exit flag. An exit flag of 0 indicates that ga reached a
% function evaluation limit or an iteration limit. In this case, ga reached
% an iteration limit.
% oga is the output structure, which describes the ga calculations leading
% to the solution.
