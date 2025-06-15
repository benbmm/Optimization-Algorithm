clear all

% Method 1: Create optimization variable for each problem variable
P1 = optimvar('P1','LowerBound',2500,'UpperBound',6250);
P2 = optimvar('P2','LowerBound',3000,'UpperBound',9000);
I1 = optimvar('I1','LowerBound',0,'UpperBound',192000);
I2 = optimvar('I2','LowerBound',0,'UpperBound',244000);
C = optimvar('C','LowerBound',0,'UpperBound',62000);
LE1 = optimvar('LE1','LowerBound',0);
LE2 = optimvar('LE2','LowerBound',0,'UpperBound',142000);
HE1 = optimvar('HE1','LowerBound',0);
HE2 = optimvar('HE2','LowerBound',0);
HPS = optimvar('HPS','LowerBound',0);
MPS = optimvar('MPS','LowerBound',271536);
LPS = optimvar('LPS','LowerBound',100623);
BF1 = optimvar('BF1','LowerBound',0);
BF2 = optimvar('BF2','LowerBound',0);
EP = optimvar('EP','LowerBound',0);
PP = optimvar('PP','LowerBound',0);

% Create problem and objective
linprob = optimproblem('Objective',0.002614*HPS + 0.0239*PP + 0.009825*EP);

% Create these inequality constraints and include them in the problem.
% The problem expressions contain three linear inequalities:
linprob.Constraints.cons1 = I1 - HE1 <= 132000;
linprob.Constraints.cons2 = EP + PP >= 12000;
linprob.Constraints.cons3 = P1 + P2 + PP >= 24550;

% The problem has eight linear equalities
linprob.Constraints.econs1 = LE2 + HE2 == I2;
linprob.Constraints.econs2 = LE1 + LE2 + BF2 == LPS;
linprob.Constraints.econs3 = I1 + I2 + BF1 == HPS;
linprob.Constraints.econs4 = C + MPS + LPS == HPS;
linprob.Constraints.econs5 = LE1 + HE1 + C == I1;
linprob.Constraints.econs6 = HE1 + HE2 + BF1 == BF2 + MPS;
linprob.Constraints.econs7 = 1267.8*HE1 + 1251.4*LE1 + 192*C + 3413*P1 == 1359.8*I1;
linprob.Constraints.econs8 = 1267.8*HE2 + 1251.4*LE2 + 3413*P2 == 1359.8*I2;

% Solve the problem
linsol = solve(linprob);

% Examine the solution
evaluate(linprob.Objective,linsol) % 
tbl = struct2table(linsol)
vars = {'P1','P2','I1','I2','C','LE1','LE2','HE1','HE2',...
'HPS','MPS','LPS','BF1','BF2','EP','PP'};
outputvars = stack(tbl,vars,'NewDataVariableName','Amt','IndexVariableName','Var')