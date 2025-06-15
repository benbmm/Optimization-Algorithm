clc;clear all;

rng default % for reproducibility
lb = [-70,-70];
ub = [130,130];
rf2 = @(x)rastriginsfcn(x/10); % objective
opts = optimoptions('surrogateopt','PlotFcn',[]);
[xsur,fsur,flgsur,osur] = surrogateopt(rf2,lb,ub,opts)

% xsur is the minimizing point.
% fsur is the value of the objective, rf2, at xsur.
% flgsur is the exit flag. An exit flag of 0 indicates that surrogateopt
% halted because it ran out of function evaluations or time.
% osur is the output structure, which describes the surrogateopt calculations
% leading to the solution.
