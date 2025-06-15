a = 100;
b = 1; % define constant values
FitnessFunction = @(x) parameterized_fitness(x,a,b);
[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub)