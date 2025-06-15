clear all

% Method 2:  Create one optimization variable and indices
vars = {'P1','P2','I1','I2','C','LE1','LE2','HE1','HE2',...
    'HPS','MPS','LPS','BF1','BF2','EP','PP'};
x = optimvar('x',vars,'LowerBound',0);

% Set variable bounds
x('P1').LowerBound = 2500;
x('P2').LowerBound = 3000;
x('MPS').LowerBound = 271536;
x('LPS').LowerBound = 100623;
x('P1').UpperBound = 6250;
x('P2').UpperBound = 9000;
x('I1').UpperBound = 192000;
x('I2').UpperBound = 244000;
x('C').UpperBound = 62000;
x('LE2').UpperBound = 142000;

% Create the problem
linprob = optimproblem('Objective',0.002614*x('HPS') + 0.0239*x('PP') + 0.009825*x('EP'));

% Create the linear constraints
linprob.Constraints.cons1 = x('I1') - x('HE1') <= 132000;
linprob.Constraints.cons2 = x('EP') + x('PP') >= 12000;
linprob.Constraints.cons3 = x('P1') + x('P2') + x('PP') >= 24550;
linprob.Constraints.econs1 = x('LE2') + x('HE2') == x('I2');
linprob.Constraints.econs2 = x('LE1') + x('LE2') + x('BF2') == x('LPS');
linprob.Constraints.econs3 = x('I1') + x('I2') + x('BF1') == x('HPS');
linprob.Constraints.econs4 = x('C') + x('MPS') + x('LPS') == x('HPS');
linprob.Constraints.econs5 = x('LE1') + x('HE1') + x('C') == x('I1');
linprob.Constraints.econs6 = x('HE1') + x('HE2') + x('BF1') == x('BF2') + x('MPS');
linprob.Constraints.econs7 = 1267.8*x('HE1') + 1251.4*x('LE1') + 192*x('C') + 3413*x('P1') == 1359.8*x('I1');
linprob.Constraints.econs8 = 1267.8*x('HE2') + 1251.4*x('LE2') + 3413*x('P2') == 1359.8*x('I2');

% Solve the problem
[linsol,fval] = solve(linprob);

% Examine the solution
tbl = table(vars',linsol.x')