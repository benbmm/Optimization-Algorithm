clear all, close all

% Custom output plot function
% Create pswplotranges.m

% Objective function
% Create multirosenbrock.m

% Run the problem with 4 variables with lower and upper bounds
fun = @multirosenbrock;
nvar = 4; % A 4-D problem
lb = -10*ones(nvar,1); % Bounds to help the solver converge
ub = -lb;

% Set options to use the output function.
options = optimoptions(@particleswarm,'OutputFcn',@pswplotranges);

% Set the random number generator to get reproducible output. Then call the solver.
rng default % For reproducibility
[x,fval,eflag] = particleswarm(fun,nvar,lb,ub,options)