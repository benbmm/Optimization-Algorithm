clear all

% Combine variables into one vector
variables = {'I1','I2','HE1','HE2','LE1','LE2','C','BF1',...
    'BF2','HPS','MPS','LPS','P1','P2','PP','EP'};

N = length(variables); 
% create variables for indexing 
for v = 1:N 
   eval([variables{v},' = ', num2str(v),';']); 
end

% Create the lower bound vector lb as a vector of 0, then add the four other lower bounds.
lb = zeros(size(variables));
lb([P1,P2,MPS,LPS]) = ...
    [2500,3000,271536,100623];

% Create the upper bound vector as a vector of Inf, then add the six upper bounds.
ub = Inf(size(variables));
ub([P1,P2,I1,I2,C,LE2]) = ...
   [6250,9000,192000,244000,62000,142000];

% Write linear inequality constraints
A = zeros(3,16);
A(1,I1) = 1; A(1,HE1) = -1; b(1) = 132000;
A(2,EP) = -1; A(2,PP) = -1; b(2) = -12000;
A(3,[P1,P2,PP]) = [-1,-1,-1];
b(3) = -24550;

% Write linear equality constraints
Aeq = zeros(8,16); beq = zeros(8,1);
Aeq(1,[LE2,HE2,I2]) = [1,1,-1];
Aeq(2,[LE1,LE2,BF2,LPS]) = [1,1,1,-1];
Aeq(3,[I1,I2,BF1,HPS]) = [1,1,1,-1];
Aeq(4,[C,MPS,LPS,HPS]) = [1,1,1,-1];
Aeq(5,[LE1,HE1,C,I1]) = [1,1,1,-1];
Aeq(6,[HE1,HE2,BF1,BF2,MPS]) = [1,1,1,-1,-1];
Aeq(7,[HE1,LE1,C,P1,I1]) = [1267.8,1251.4,192,3413,-1359.8];
Aeq(8,[HE2,LE2,P2,I2]) = [1267.8,1251.4,3413,-1359.8];

% Write the objective
f = zeros(size(variables));
f([HPS PP EP]) = [0.002614 0.0239 0.009825];

% Solve the problem
options = optimoptions('linprog','Algorithm','dual-simplex');
[x fval] = linprog(f,A,b,Aeq,beq,lb,ub,options);
for d = 1:N
  fprintf('%12.2f \t%s\n',x(d),variables{d}) 
end
fval

