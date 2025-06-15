% Create options for fmincon to use the 'optimplotfvalconstr' plot function and to return
% iterative display.
options = optimoptions('fmincon',...
    'PlotFcn','optimplotfvalconstr',...
    'Display','iter');

% Create the initial point.
x0 = [0 0];

% Create empty entries for the constraints that this example does not use.
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];

% Solve the problem
[x,fval] = fmincon(@rosenbrock1,x0,A,b,Aeq,beq,lb,ub,@unitdisk,options)