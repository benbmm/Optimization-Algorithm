function [ output_args ] = nm_simplex( input_args )
%Nelder-Mead simplex method
%Based on the program by the Spring 2007 ECE580 student, Hengzhou Ding

disp ('We minimize a function using the Nelder-Mead method.')
disp ('There are two initial conditions.')
disp ('You can enter your own starting point.')
disp ('---------------------------------------------')

% disp(’Select one of the starting points’)
% disp (’[0.55;0.7] or [-0.9;-0.5]’)
% x0=input(’’)
disp (' ')
clear
close all;

disp('Select one of the starting points, or enter your own point')
disp('[0.55;0.7] or [-0.9;-0.5]')
disp('(Copy one of the above points and paste it at the prompt)')
x0=input('')

hold on
axis square
%Plot the contours of the objective function
[X1,X2]=meshgrid(-1:0.01:1);
Y=(X2-X1).^4+12.*X1.*X2-X1+X2-3;
[C,h] = contour(X1,X2,Y,20);
clabel(C,h);

% Initialize all parameters
lambda=0.1;
rho=1;
chi=2;
gamma=1/2;
sigma=1/2;
e1=[1 0]';
e2=[0 1]';
%x0=[0.55 0.7]’;
%x0=[-0.9 -0.5]’;

% Plot initial point and initialize the simplex
plot(x0(1),x0(2),'--*');
x(:,3)=x0;
x(:,1)=x0+lambda*e1;
x(:,2)=x0+lambda*e2;

while 1
% Check the size of simplex for stopping criterion
simpsize=norm(x(:,1)-x(:,2))+norm(x(:,2)-x(:,3))+norm(x(:,3)-x(:,1));
if(simpsize<1e-6)
break;
end
lastpt=x(:,3);
% Sort the simplex
x=sort_points(x,3);
% Reflection
centro=1/2*(x(:,1)+x(:,2));
xr=centro+rho*(centro-x(:,3));
% Accept condition
if(obj_fun(xr)>=obj_fun(x(:,1)) && obj_fun(xr)<obj_fun(x(:,2)))
x(:,3)=xr;
% Expand condition
elseif(obj_fun(xr)<obj_fun(x(:,1)))
xe=centro+rho*chi*(centro-x(:,3));
if(obj_fun(xe)<obj_fun(xr))
x(:,3)=xe;
else
x(:,3)=xr;
end

% Outside contraction or shrink
elseif(obj_fun(xr)>=obj_fun(x(:,2)) && obj_fun(xr)<obj_fun(x(:,3)))
xc=centro+gamma*rho*(centro-x(:,3));
if(obj_fun(xc)<obj_fun(x(:,3)))
x(:,3)=xc;
else
x=shrink(x,sigma);
end
% Inside contraction or shrink
else
xcc=centro-gamma*(centro-x(:,3));
if(obj_fun(xcc)<obj_fun(x(:,3)))
x(:,3)=xcc;
else
x=shrink(x,sigma);
end
end
% Plot the new point and connect
plot([lastpt(1),x(1,3)],[lastpt(2),x(2,3)],'--*');
end
% Output the final simplex (minimizer)
x(:,1)

% obj_fun
function y = obj_fun(x)
y=(x(1)-x(2))^4+12*x(1)*x(2)-x(1)+x(2)-3;

% sort_points
function y = sort_points(x,N)
for i=1:(N-1)
for j=1:(N-i)
if(obj_fun(x(:,j))>obj_fun(x(:,j+1)))
tmp=x(:,j);
x(:,j)=x(:,j+1);
x(:,j+1)=tmp;
end
end
end
y=x;

% shrink
function y = shrink(x,sigma)
x(:,2)=x(:,1)+sigma*(x(:,2)-x(:,1));
x(:,3)=x(:,1)+sigma*(x(:,3)-x(:,1));
y=x;