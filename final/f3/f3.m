function multi_op_modified
%MULTI_OP_MODIFIED, illustrates multi-objective optimization with new problem.

clear all, close all
clc
disp (' ')
disp ('This is a demo illustrating multi-objective optimization.')
disp ('Modified for the new problem:')
disp ('min [-(x1² + 2x2), 2x1 + x2²]')
disp ('subject to: 1 ≤ x1 ≤ 7, 4 ≤ x2 ≤ 10')
disp ('------------------------------------------------------------')
disp ('Select the population size denoted POPSIZE, for example, 50.')
disp (' ')
POPSIZE = input('Population size POPSIZE = ');
disp ('------------------------------------------------------------')
disp ('Select the number of iterations denoted NUMITER; e.g., 10.')
disp (' ')
NUMITER = input('Number of iterations NUMITER = ');
disp (' ')
disp ('------------------------------------------------------------')

% Main
for i = 1:NUMITER
    fprintf('Working on Iteration %.0f...\n', i)
    xmat = genxmat(POPSIZE);
    
    if i ~= 1
        for j = 1:length(xR)
            xmat = [xmat; xR{j}];
        end
    end
    
    [xR, fR] = Select_P(xmat);
    fprintf('Number of Pareto solutions: %.0f\n', length(fR))
end

disp (' ')
disp ('------------------------------------------------------------')

fprintf(' Pareto solutions \n')
celldisp(xR)
disp (' ')
disp ('------------------------------------------------------------')

fprintf(' Objective vector values \n')
celldisp(fR)

% Plot Pareto front
figure(1)
hold on

% Plot all solutions from the last generation
all_f1 = [];
all_f2 = [];
for k = 1:size(xmat, 1)
    temp_f = evalfcn(xmat(k, :));
    all_f1 = [all_f1 temp_f(1)];
    all_f2 = [all_f2 temp_f(2)];
end

% Plot all solutions as blue dots
plot(all_f1, all_f2, 'bo', 'MarkerSize', 6, 'LineWidth', 1)

% Plot Pareto optimal solutions as red circles with different style
pareto_f1 = [];
pareto_f2 = [];
for i = 1:length(fR)
    pareto_f1 = [pareto_f1 fR{i}(1)];
    pareto_f2 = [pareto_f2 fR{i}(2)];
end

plot(pareto_f1, pareto_f2, 'ro', 'MarkerSize', 8, 'LineWidth', 2, 'MarkerFaceColor', 'red')

xlabel('f_1 = -(x_1² + 2x_2)', 'Fontsize', 16)
ylabel('f_2 = 2x_1 + x_2²', 'Fontsize', 16)
title('Pareto optimal front', 'Fontsize', 16)
legend('All solutions', 'Pareto optimal solutions', 'Location', 'best')
set(gca, 'Fontsize', 16)
grid on
hold off

% Extract decision variables for plotting
for i = 1:length(xR)
    xx(i) = xR{i}(1);
    yy(i) = xR{i}(2);
end
XX = [xx; yy];

% Plot Pareto optimal solutions in decision space
figure(2)
axis([0 8 3 11])
hold on

for i = 1:size(XX, 2)
    plot(XX(1, i), XX(2, i), 'marker', 'o', 'markersize', 8, 'Color', 'red', 'LineWidth', 2)
end

xlabel('x_1', 'Fontsize', 16)
ylabel('x_2', 'Fontsize', 16)
title('Pareto optimal solutions', 'Fontsize', 16)
set(gca, 'Fontsize', 16)
grid on
hold off

% Plot level sets and constraints
figure(3)
axis([0 8 3 11])
hold on

% Draw constraint boundaries
h1 = plot([1 7], [4 4], 'k-', 'LineWidth', 3); % x2 = 4
plot([7 7], [4 10], 'k-', 'LineWidth', 3) % x1 = 7
plot([1 7], [10 10], 'k-', 'LineWidth', 3) % x2 = 10
plot([1 1], [4 10], 'k-', 'LineWidth', 3) % x1 = 1

% Create level sets
x1 = 0:0.2:8;
x2 = 3:0.2:11;
[X1, X2] = meshgrid(x1, x2);

% Level sets for f1 = -(x1² + 2x2)
Z1 = -(X1.^2 + 2*X2);
v1 = [-80 -60 -40 -30 -25 -20 -15 -10 -5];
h2 = contour(X1, X2, Z1, v1, 'b--', 'LineWidth', 1.5);
clabel(h2)

% Level sets for f2 = 2x1 + x2²
Z2 = 2*X1 + X2.^2;
v2 = [20 30 40 50 60 80 100 120 140];
h3 = contour(X1, X2, Z2, v2, 'r:', 'LineWidth', 1.5);
clabel(h3)

% Plot Pareto optimal points
h4 = plot(XX(1, :), XX(2, :), 'rx', 'markersize', 12, 'LineWidth', 3);

xlabel('x_1', 'Fontsize', 16)
ylabel('x_2', 'Fontsize', 16)
title('Level sets of f_1 and f_2, and Pareto optimal points', 'Fontsize', 16)
set(gca, 'Fontsize', 16)
grid on
legend([h1, h4, h2(1), h3(1)], {'Constraints', 'Pareto points', 'f_1 level sets', 'f_2 level sets'}, 'Location', 'best')
hold off

end

function xmat0 = genxmat(POPSIZE)
% Generate random population within constraints: 1 ≤ x1 ≤ 7, 4 ≤ x2 ≤ 10
xmat0 = rand(POPSIZE, 2);
xmat0(:, 1) = xmat0(:, 1) * 6 + 1; % x1 in [1, 7]
xmat0(:, 2) = xmat0(:, 2) * 6 + 4; % x2 in [4, 10]
end

function [xR, fR] = Select_P(xmat)
% Pareto optimal selection using dominance concept

% Declaration
J = size(xmat, 1);

% Init
Rset = [1];
j = 1;
isstep7 = 0;

% Step 1
x{1} = xmat(1, :);
f{1} = evalfcn(x{1});

% Step 2
while j < J
    j = j + 1;
    
    % Step 3
    r = 1;
    rdel = [];
    q = 0;
    R = length(Rset);
    
    for k = 1:size(xmat, 1)
        x{k} = xmat(k, :);
        f{k} = evalfcn(x{k});
    end
    
    % Step 4
    while 1
        if all(f{j} < f{Rset(r)})
            q = q + 1;
            rdel = [rdel r];
        else
            % Step 5
            if all(f{j} >= f{Rset(r)})
                break
            end
        end
        
        % Step 6
        r = r + 1;
        if r > R
            isstep7 = 1;
            break
        end
    end
    
    % Step 7
    if isstep7 == 1
        isstep7 = 0;
        if (q ~= 0)
            Rset(rdel) = [];
            Rset = [Rset j];
        else
            % Step 8
            Rset = [Rset j];
        end
    end
    
    for k = 1:size(xmat, 1)
        x{k} = xmat(k, :);
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
for k = 1:size(xmat, 1)
    if ismember(k, Rset)
        x1 = [x1 f{k}(1)];
        y1 = [y1 f{k}(2)];
    else
        x2 = [x2 f{k}(1)];
        y2 = [y2 f{k}(2)];
    end
end

% Plot current iteration
plot(x1, y1, 'xr', x2, y2, '.b')
drawnow
end

function y = f1(x)
% First objective function: f1 = -(x1² + 2x2)
y = -(x(1)^2 + 2*x(2));
end

function y = f2(x)
% Second objective function: f2 = 2x1 + x2²
y = 2*x(1) + x(2)^2;
end

function y = evalfcn(x)
% Evaluate both objective functions
y(1) = f1(x);
y(2) = f2(x);
end