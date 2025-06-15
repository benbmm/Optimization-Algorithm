% Define Rosenbrock function 
rosenbrock = @(x)100*(x(:,2) - x(:,1).^2).^2 + (1 - x(:,1)).^2;

% The nonlinear constraint function is in the disk.m file

% Define optimization variable
x = optimvar( 'x' ,1,2);

% Convert both functions to their respective optimization expressions 
rosenexpr = fcn2optimexpr(rosenbrock,x);
radsqexpr = fcn2optimexpr(@disk,x);

% Create an optimization problem using these converted optimization
% expressions
convprob = optimproblem('Objective',rosenexpr,'Constraints',radsqexpr <= 1);

% View the problem
show(convprob)

% Solve the problem
x0.x = [0 0];
[sol,fval,exitflag,output] = solve(convprob,x0)