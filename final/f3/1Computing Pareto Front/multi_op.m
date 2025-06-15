function multi_op
%MULTI_OP, illustrates multi-objective optimization.

clear all, close all
clc
disp (' ')
disp ('This is a demo illustrating multi-objective optimization.')
disp ('The numerical example is a modification of the example')
disp ('from the 2002 book by A. Osyczka,')
disp ('Example 5.1 on pages 101--105')
disp ('------------------------------------------------------------')
disp ('Select the population size denoted POPSIZE, for example, 50.')
disp (' ')
POPSIZE=input('Population size POPSIZE = ');
disp ('------------------------------------------------------------')
disp ('Select the number of iterations denoted NUMITER; e.g., 10.')
disp (' ')
NUMITER=input('Number of iterations NUMITER = ');
disp (' ')
disp ('------------------------------------------------------------')

% Main
for i = 1:NUMITER
fprintf('Working on Iteration %.0f...\n',i)
xmat = genxmat(POPSIZE);

if i~=1
for j = 1:length(xR)
    xmat = [xmat;xR{j}];

end

end

[xR,fR] = Select_P(xmat);
fprintf('Number of Pareto solutions: %.0f\n',length(fR))

end
disp (' ')
disp ('------------------------------------------------------------')

fprintf(' Pareto solutions \n')
celldisp(xR)
disp (' ')
disp ('------------------------------------------------------------')

fprintf(' Objective vector values \n')
celldisp(fR)
xlabel('f_1','Fontsize',16)
ylabel('f_2','Fontsize',16)
title('Pareto optimal front','Fontsize',16)
set(gca,'Fontsize',16)
grid

for i=1:length(xR)
xx(i)=xR{i}(1);
yy(i)=xR{i}(2);
end
XX=[xx; yy];

figure %
axis([1 7 5 10]) %
hold on %

for i=1:size(XX,2) %
plot(XX(1,i),XX(2,i),'marker','o','markersize',6) %
end %

xlabel('x_1','Fontsize',16) %
ylabel('x_2','Fontsize',16) %
title('Pareto optimal solutions','Fontsize',16) %
set(gca,'Fontsize',16) %
grid %
hold off %

figure
axis([-2 10 2 13]) %
hold on %
plot([2 6],[5 5],'marker','o','markersize',6) %
plot([6 6],[5 9],'marker','o','markersize',6) %
plot([2 6],[9 9],'marker','o','markersize',6) %
plot([2 2],[5 9],'marker','o','markersize',6) %

for i=1:size(XX,2) %
plot(XX(1,i),XX(2,i),'marker','x','markersize',10) %
end %

x1=-2:.2:10; %
x2=2:.2:13; %
[X1, X2]=meshgrid(x1,x2); %
Z1=-X1.^2 - X2; %
v=[0 -5 -7 -10 -15 -20 -30 -40 -60]; %
cs1=contour(X1,X2,Z1,v); %
clabel(cs1) %
Z2=X1+X2.^2; %
v2=[20 25 35 40 60 80 100 120]; %
cs2=contour(X1,X2,Z2,v2); %
clabel(cs2) %
xlabel('x_1','Fontsize',16) %
ylabel('x_2','Fontsize',16) %
title('Level sets of f_1 and f_2, and Pareto optimal points','Fontsize',16) %
set(gca,'Fontsize',16) %
grid %
hold off %

function xmat0 = genxmat(POPSIZE) %
xmat0 = rand(POPSIZE,2); %
xmat0(:,1) = xmat0(:,1)*4+2; %
xmat0(:,2) = xmat0(:,2)*4+5; %

function [xR,fR] = Select_P(xmat)

% Declaration
J = size(xmat,1);

% Init
Rset = [1];
j = 1;
isstep7 = 0;

% Step 1
x{1} = xmat(1,:);
f{1} = evalfcn(x{1});

% Step 2
while j < J
j = j+1;

% Step 3
r = 1;
rdel = [];
q = 0;
R = length(Rset);

for k = 1:size(xmat,1)
x{k} = xmat(k,:);
f{k} = evalfcn(x{k});
end

% Step 4
while 1
%for r=1:R
if all(f{j}<f{Rset(r)})
q = q+1;
rdel = [rdel r];

else

% Step 5
if all(f{j}>=f{Rset(r)})
break
end

end

% Step 6
r=r+1;
if r > R
isstep7 = 1;
break
end

end

% Step 7
if isstep7 == 1
isstep7 = 0;
if (q~=0)
Rset(rdel) =[];
Rset = [Rset j];
else

%Step 8
Rset = [Rset j];

end

end

for k = 1:size(xmat,1)
x{k} = xmat(k,:);
f{k} = evalfcn(x{k});
end

R = length(Rset);

end

% Return the Pareto solution.
for i = 1:length(Rset)
xR{i} = x{Rset(i)};
fR{i} = f{Rset(i)};
end

x1 = [];
y1 = [];
x2 = [];
y2 = [];
for k = 1:size(xmat,1)
if ismember(k,Rset)
x1 = [x1 f{k}(1)];
y1 = [y1 f{k}(2)];
else
x2 = [x2 f{k}(1)];
y2 = [y2 f{k}(2)];
end
end
%newplot
plot(x1,y1,'xr',x2,y2,'.b')
drawnow

function y = f1(x) %
y = -(x(1)^2+x(2)); %

function y = f2(x) %
y = x(1)+x(2)^2; %

function y = evalfcn(x) %
y(1) = f1(x); %
y(2) = f2(x); %