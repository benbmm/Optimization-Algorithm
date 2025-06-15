clear all; clc; close all;

%% Generate data points (t_i, y_i) with noise as per the problem statement
rng('default'); % Set random number generator to default for reproducibility
t = 0:0.25:10;  % Time points from 0 to 10 with step 0.25
y = 3*sin(2*t+0.5) + rand(1,length(t))*1; % Data with noise

% Plot the generated data
figure(1);
plot(t, y, 'ko', 'MarkerSize', 8);
title('Generated Data Points with Noise');
xlabel('t');
ylabel('y');
grid on;

%% Using lsqcurvefit to fit a sinusoidal function
% Define the sinusoidal model function: y = A*sin(ω*t + φ)
% Parameters: [A, ω, φ]
sinusoidal_model = @(params, t) params(1) * sin(params(2) * t + params(3));

% Initial parameter guess
initial_params = [1, 1, 1]; % [A, ω, φ]

% Set options for Levenberg-Marquardt algorithm
options = optimoptions('lsqcurvefit', ...
                     'Display', 'iter', ...
                     'MaxIterations', 1000, ...
                     'FunctionTolerance', 1e-8, ...
                     'StepTolerance', 1e-8);

% Perform the curve fitting
[fitted_params, resnorm, residual, exitflag, output] = lsqcurvefit(sinusoidal_model, ...
                                                   initial_params, ...
                                                   t, ...
                                                   y, ...
                                                   [], [], ... % No bounds
                                                   options);

% Extract the fitted parameters
A_fit = fitted_params(1);
omega_fit = fitted_params(2);
phi_fit = fitted_params(3);

% Display the results
fprintf('\nFitting Results:\n');
fprintf('Amplitude (A): %.4f\n', A_fit);
fprintf('Angular Frequency (ω): %.4f\n', omega_fit);
fprintf('Phase (φ): %.4f\n', phi_fit);
fprintf('Final residual norm: %.6f\n', resnorm);
fprintf('Number of iterations: %d\n', output.iterations);
fprintf('Number of function evaluations: %d\n', output.funcCount);
fprintf('Exitflag: %d\n', exitflag);

% Generate smooth curve with fitted parameters for visualization
t_fine = linspace(min(t), max(t), 500);
y_fitted = sinusoidal_model(fitted_params, t_fine);

% Plot the results
figure(2);
plot(t, y, 'ko', 'MarkerSize', 8, 'DisplayName', 'Data Points');
hold on;
plot(t_fine, y_fitted, 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted Curve');
grid on;
legend('Location', 'best');
title('Sinusoidal Curve Fitting with lsqcurvefit (Levenberg-Marquardt)');
xlabel('t');
ylabel('y');

% Plot residuals
figure(3);
plot(t, residual, 'bo', 'MarkerSize', 6);
hold on;
plot([min(t), max(t)], [0, 0], 'k--');
grid on;
title('Residuals (Difference between fitted curve and data)');
xlabel('t');
ylabel('Residual');

% Display theoretical vs fitted function
fprintf('\nTheoretical function: y = 3*sin(2*t + 0.5) + noise\n');
fprintf('Fitted function:     y = %.4f*sin(%.4f*t + %.4f)\n', A_fit, omega_fit, phi_fit);

% Calculate goodness of fit metrics
SSE = sum(residual.^2);                % Sum of squared errors
SST = sum((y - mean(y)).^2);           % Total sum of squares
R_squared = 1 - SSE/SST;               % R-squared value
RMSE = sqrt(mean(residual.^2));        % Root mean square error

fprintf('\nGoodness of Fit Metrics:\n');
fprintf('R-squared: %.4f\n', R_squared);
fprintf('RMSE: %.4f\n', RMSE);
fprintf('SSE: %.4f\n', SSE);

% Additional visualization: Parameter comparison
figure(4);
bar([3, 2, 0.5; A_fit, omega_fit, phi_fit]');
set(gca, 'XTickLabel', {'Amplitude (A)', 'Frequency (ω)', 'Phase (φ)'});
legend('Theoretical', 'Fitted');
title('Comparison of Theoretical and Fitted Parameters');
grid on;