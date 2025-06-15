clear all, clc

% Define the functions and their derivatives
y1 = @(x) (x-1).^2 - 1;     % y₁ = (x-1)² - 1
dy1 = @(x) 2.*(x-1);        % Derivative of y₁

y2 = @(x) cos(2*x);         % y₂ = cos(2x)
dy2 = @(x) -2*sin(2*x);     % Derivative of y₂

% Set the interval for search
x = 0:0.01:3;

% Plot both functions to visualize the intersection points
figure;
hold on;
plot(x, y1(x), 'LineWidth', 1.5);
plot(x, y2(x), 'LineWidth', 1.5);
hold off;
grid on;
title('Functions y₁ = (x-1)² - 1 and y₂ = cos(2x)', 'FontSize', 14);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
legend('y₁ = (x-1)² - 1', 'y₂ = cos(2x)', 'Location', 'best');

% Visual inspection shows there are two intersection points in [0,3]
% Let's find both using Newton's method with different initial guesses

% Find the intersection point
initial_guess1 = 0.5;  % Initial guess based on visual inspection
intersection1 = newtons_method(@(x) y2(x) - y1(x), @(x) dy2(x) - dy1(x), initial_guess1);

% Display results
fprintf('First intersection point: x = %.8f, y = %.8f\n', intersection1, y1(intersection1));

% Plot the result with intersection points marked
figure;
hold on;
plot(x, y1(x), 'LineWidth', 1.5);
plot(x, y2(x), 'LineWidth', 1.5);
plot(intersection1, y1(intersection1), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
text(intersection1 + 0.1, y1(intersection1), ['(' num2str(intersection1, '%.4f') ', ' num2str(y1(intersection1), '%.4f') ')']);
hold off;
grid on;
title('Intersection of y₁ = (x-1)² - 1 and y₂ = cos(2x)', 'FontSize', 14);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
legend('y₁ = (x-1)² - 1', 'y₂ = cos(2x)', 'Intersection Points', 'Location', 'best');

% Newton's Method Implementation
function root = newtons_method(f, df, x0)
    % Set parameters
    TOL = 1e-10;       % Tolerance for convergence
    max_iter = 100;    % Maximum number of iterations
    
    % Initialize
    x_old = x0;
    err = 2*TOL;       % Set initial error to enter the loop
    iter = 0;          % Iteration counter
    
    % Display header for iteration progress
    fprintf('\nNewton''s Method starting with x0 = %.4f\n', x0);
    fprintf('Iteration\t   x_n\t\t   f(x_n)\t\t   Error\n');
    fprintf('----------------------------------------------------------\n');
    
    % Newton's Method iteration
    while (err > TOL) && (iter < max_iter)
        % Compute function value and derivative at current point
        f_val = f(x_old);
        df_val = df(x_old);
        
        % Check if derivative is close to zero to avoid division by zero
        if abs(df_val) < 1e-10
            warning('Derivative is close to zero. Method may not converge.');
            df_val = sign(df_val) * 1e-10;  % Assign a small non-zero value
        end
        
        % Update estimate of root using Newton's formula
        x_new = x_old - f_val / df_val;
        
        % Calculate error
        err = abs(x_new - x_old);
        
        % Display current iteration information
        fprintf('%5d\t\t%10.8f\t%10.8f\t%10.8e\n', iter, x_old, f_val, err);
        
        % Update for next iteration
        x_old = x_new;
        iter = iter + 1;
    end
    
    % Check if maximum iterations reached
    if iter >= max_iter
        warning('Maximum number of iterations reached. Solution may not be accurate.');
    end
    
    % Display final result
    fprintf('----------------------------------------------------------\n');
    fprintf('Converged to root x = %.10f after %d iterations\n', x_old, iter);
    fprintf('Function value at root f(x) = %.10e\n', f(x_old));
    
    % Return the root
    root = x_old;
end