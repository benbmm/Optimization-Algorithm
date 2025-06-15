% Define Problem
x = optimvar( 'x' ,1,2);
obj = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
prob = optimproblem('Objective',obj);
nlcons = x(1)^2 + x(2)^2 <= 1;
prob.Constraints.circlecons = nlcons;
show(prob)

% Solve Problem
x0.x = [0 0];
[sol,fval,exitflag,output] = solve(prob,x0)

% Examine Problem
infeas = output.constrviolation % Check the reported infeasibility in the constrviolation field of the output structure
infeas = infeasibility(nlcons,sol) 
nx = norm(sol.x) % Compute the norm of x to ensure that it is less than or equal to 1