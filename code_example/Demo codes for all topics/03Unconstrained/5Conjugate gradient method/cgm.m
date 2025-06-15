format short;
clc;clear clear;

syms x1 x2
% Define Objective function
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
Hx = inline(H1); % Convert to funtion
x0 = [1 1]; % Set in  itial vector
maxiter = 4; % Set maximum iteration
tol = 1e-3; % maximum tolerance
iter = 1; % initial counter
X = []; % initial empty array
S = 0; % initial Search Direction
Gpr = -gradx(x0); % Compute initial gradient Fi-1
while norm(gradx(x0))>tol && iter<maxiter
    X = [X;x0]; % Save all vectors
    Gi = -gradx(x0); % Compute Gradient at X
    H = Hx(x0); % Compute Hessian at X
    bet = norm(Gi).^2./norm(Gpr).^2;
    S = Gi + bet.*S; % Compute direction "S"
    lam = Gi'*Gi./(S'*H*S); % Compute Lambda
    Xnew = x0+lam.*S'; % Update X
    x0 = Xnew; % Save new X
    Gpr = Gi; % Update gradient Fi-1
    iter = iter+1; % Update iteration
end

% Print the solution
fprintf('Optimal Solution x = [%f, %f]\n',x0(1), x0(2));
fprintf('Optimal value f(x) = %f\n',fobj(x0));