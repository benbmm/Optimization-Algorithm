clear all, close all

ObjectiveFunction = @simple_fitness;
nvars = 2;    % Number of variables
LB = [0 0];   % Lower bound
UB = [1 13];  % Upper bound
ConstraintFunction = @simple_constraint;

% The default mutation function mutationgaussian will not satisfy
%the linear constraints and so the mutationadaptfeasible is used instead.
options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible);

% Add visualization
options = optimoptions(options,'PlotFcn',{@gaplotbestf,@gaplotmaxconstr}, ...
    'Display','iter');

% Provide a start point
X0 = [0.5 0.5]; % Start point (row vector)
options.InitialPopulationMatrix = X0;

% Minimizing using ga
[x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB, ...
    ConstraintFunction,options)