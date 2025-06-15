options = optimoptions(@ga,'UseVectorized',true);
VFitnessFunction = @(x) vectorized_fitness(x,100,1);
[x,fval] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options)

% Comparison of execution time
tic
[x,fval] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);
v = toc;
tic
[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub);
nv = toc;
fprintf('Using vectorization took %f seconds. No vectorization took %f seconds.\n',v,nv)