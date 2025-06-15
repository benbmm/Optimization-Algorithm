clc;clear all;

rng default % for reproducibility
rf2 = @(x)rastriginsfcn(x/10); % objective
x0 = [20,30]; % start point away from the minimum
initpop = 10*randn(20,2) + repmat(x0,20,1);
opts = optimoptions('particleswarm','InitialSwarmMatrix',initpop);
[xpso,fpso,flgpso,opso] = particleswarm(rf2,2,[],[],opts)

% xpso is the minimizing point.
% fpso is the value of the objective, rf2, at xpso.
% flgpso is the exit flag. An exit flag of 1 indicates xpso is a local minimum.
% opso is the output structure, which describes the particleswarm calculations
% leading to the solution.
