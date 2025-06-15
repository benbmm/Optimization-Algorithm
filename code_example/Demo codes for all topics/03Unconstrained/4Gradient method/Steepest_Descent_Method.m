format short % Display output upto 4 digits
clear all;clc;

syms x1 x2
% Define Objective fuction
f1 = x1-x2+2*x1^2+2*x1*x2+x2^2;
fx = inline(f1); % Convert to function
fobj=@(x) fx(x(:,1),x(:,2));

% Plot the level set of the objective function
X = [-3:0.125:2]';
Y = [-1:0.125:4]';
[x1,x2]=meshgrid(X',Y') ;
func = x1-x2+2.*x1.^2+2.*x1.*x2+x2.^2;
levels = exp(-1:2);
contour(X,Y,func,levels,'k--')
xlabel('x_1')
ylabel('x_2')
title('Level set of the objective function')

% Gradient of f
grad = gradient(f1); % Compute gradient
G = inline(grad); % Convert to function
gradx=@(x) G(x(:,1),x(:,2));

% Hessian Matrix
H1 = hessian(f1); % Compute Hessian
Hx = inline(H1); % Convvert to function
x0 = [1 1]; % Set initial vector
maxiter = 4; % Set maximum iteration
tol = 1e-3; % maximum tolerance
iter = 0; % initial counter
X = []; % initial vector array
while norm(gradx(x0))>tol && iter<maxiter
    X = [X;x0]; % Save all vectors
    S = -gradx(x0); % Compute Gradient at X
    H = Hx(x0); % Compute Hessian at X
    lam = S'*S./(S'*H*S); % Compute Lambda
    Xnew = x0+lam.*S'; % Update X
    x0 = Xnew; % Save new X
    iter = iter+1; % Update iteration
end

% Print the solution
fprintf('Optimal Solution x = [%f, %f]\n',x0(1), x0(2));
fprintf('Optimal value f(x) = %f\n',fobj(x0));