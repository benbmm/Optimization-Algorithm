%% ROSENBROCK1(x) expects a two-element vector and returns a scalar
% The output is the Rosenbrock function, which has a minimum at
% (1,1) of value 0, and is strictly positive everywhere else.

function f = rosenbrock1(x)
f = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;