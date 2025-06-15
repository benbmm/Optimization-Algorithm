format short;
clc; clear all;
syms x1 x2

% Define Objective function
f1 = 4*x1^2 + x1*x2 + 3*x2^2 + 2*x1 + x2 + 1;
fx = matlabFunction(f1, 'Vars', [x1, x2]); % Convert to function
fobj = @(x) fx(x(1), x(2));

% Plot the level set of the objective function
figure(1);
X = -4:0.1:2;
Y = -3:0.1:3;
[X1, X2] = meshgrid(X, Y);
Z = 4*X1.^2 + X1.*X2 + 3*X2.^2 + 2*X1 + X2 + 1;

% Plot contour
contour(X, Y, Z, 20, 'LineWidth', 1);
xlabel('x_1', 'FontSize', 12);
ylabel('x_2', 'FontSize', 12);
title('Level Sets of f(x_1, x_2) = 4x_1^2 + x_1x_2 + 3x_2^2 + 2x_1 + x_2 + 1', 'FontSize', 12);
colorbar;
grid on;
hold on;

% Compute the gradient of f
gradient_f = gradient(f1, [x1, x2]);
% Convert symbolic gradient to function handle
gradient_x1 = matlabFunction(gradient_f(1), 'Vars', [x1, x2]);
gradient_x2 = matlabFunction(gradient_f(2), 'Vars', [x1, x2]);
% Function to compute gradient at point x
gradf = @(x) [gradient_x1(x(1), x(2)); gradient_x2(x(1), x(2))];

% Compute the Hessian matrix (constant for quadratic function)
H = double(hessian(f1, [x1, x2]));

% Parameters for conjugate gradient method
x0 = [1; 1];     % Initial point (column vector)
maxiter = 10;    % Maximum number of iterations
tol = 1e-6;      % Tolerance for convergence
iter = 1;        % Iteration counter
X_history = x0'; % Save iteration history (as row for plotting)
f_history = fobj(x0); % Save function values

% Display header
fprintf('Conjugate Gradient Method for minimizing f(x₁, x₂) = 4x₁² + x₁x₂ + 3x₂² + 2x₁ + x₂ + 1\n');
fprintf('-----------------------------------------------------------------------\n');
fprintf('Iter\t   x₁\t\t   x₂\t\t   f(x)\t\t ||∇f||\n');
fprintf('-----------------------------------------------------------------------\n');
fprintf('%3d\t%10.6f\t%10.6f\t%10.6f\t%10.6f\n', 0, x0(1), x0(2), fobj(x0), norm(gradf(x0)));

% Initial gradient and search direction
g0 = gradf(x0);
d0 = -g0;  % Initial search direction is negative gradient

% Main loop of conjugate gradient method
while (norm(g0) > tol) && (iter <= maxiter)
    % Compute step size (exact line search for quadratic functions)
    alpha = -(g0' * d0) / (d0' * H * d0);
    
    % Update position
    x_new = x0 + alpha * d0;
    
    % Compute new gradient
    g_new = gradf(x_new);
    
    % Compute beta using Fletcher-Reeves formula
    beta = (g_new' * g_new) / (g0' * g0);
    
    % Update search direction
    d_new = -g_new + beta * d0;
    
    % Update current point and gradient for next iteration
    x0 = x_new;
    g0 = g_new;
    d0 = d_new;
    
    % Save history
    X_history = [X_history; x0'];
    f_history = [f_history; fobj(x0)];
    
    % Display iteration information
    fprintf('%3d\t%10.6f\t%10.6f\t%10.6f\t%10.6f\n', iter, x0(1), x0(2), fobj(x0), norm(g0));
    
    % Update iteration counter
    iter = iter + 1;
end

% Display result
fprintf('-----------------------------------------------------------------------\n');
if norm(g0) <= tol
    fprintf('Converged to optimal solution!\n');
else
    fprintf('Maximum iterations reached.\n');
end
fprintf('Optimal solution: x* = [%f, %f]\n', x0(1), x0(2));
fprintf('Optimal value: f(x*) = %f\n', fobj(x0));
fprintf('Gradient norm at solution: ||∇f(x*)|| = %e\n', norm(gradf(x0)));

% Calculate analytical solution for verification
% For quadratic functions, we can compute exact solution by setting gradient to zero
fprintf('\nVerification with analytical solution:\n');
% Solve 8*x1 + x2 + 2 = 0 and x1 + 6*x2 + 1 = 0
A = [8, 1; 1, 6];
b = [-2; -1];
x_analytical = A\b;
fprintf('Analytical solution: x* = [%f, %f]\n', x_analytical(1), x_analytical(2));
fprintf('Analytical optimal value: f(x*) = %f\n', fobj(x_analytical));

% Plot the optimization path
plot(X_history(:,1), X_history(:,2), 'ro-', 'LineWidth', 1.5, 'MarkerSize', 8);
plot(x0(1), x0(2), 'g*', 'LineWidth', 2, 'MarkerSize', 12);
plot(x_analytical(1), x_analytical(2), 'b*', 'LineWidth', 2, 'MarkerSize', 12);
legend('Level Sets', 'Optimization Path', 'Final Point (CG)', 'Analytical Solution', 'Location', 'best');

% 3D surface plot
figure(2);
surf(X1, X2, Z, 'FaceAlpha', 0.8);
hold on;
for i = 1:size(X_history, 1)
    plot3(X_history(i,1), X_history(i,2), fobj([X_history(i,1); X_history(i,2)]), 'r.', 'MarkerSize', 20);
    if i < size(X_history, 1)
        plot3([X_history(i,1), X_history(i+1,1)], [X_history(i,2), X_history(i+1,2)], ...
              [fobj([X_history(i,1); X_history(i,2)]), fobj([X_history(i+1,1); X_history(i+1,2)])], 'r-', 'LineWidth', 2);
    end
end
plot3(x0(1), x0(2), fobj(x0), 'g*', 'LineWidth', 2, 'MarkerSize', 12);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x_1, x_2)');
title('3D Surface Plot with Optimization Path');
colorbar;
grid on;
view(40, 30);