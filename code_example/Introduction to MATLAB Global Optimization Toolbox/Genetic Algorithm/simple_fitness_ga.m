clear all, close all

% Plot the Rosenbrock function
fsurf(@(x,y)log(1 + 100*(x.^2 - y).^2 + (1 - x).^2),[0,2])
title('log(1 + 100*(x(1)^2 - x(2))^2 + (1 - x(1))^2)')
view(-13,78)
hold on
h1 = plot3(1,1,0.1,'r*','MarkerSize',12);
legend(h1,'Minimum','Location','best');
hold off

% Minimize using ga
rng default % For reproducibility
FitnessFunction = @simple_fitness;
numberOfVariables = 2;
lb = [-3,-3];
ub = [3,3];
[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub)