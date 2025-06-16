% 全域最佳化問題：使用遺傳演算法找到函數的全域最大值
% 參數設定
a = 3;
b = 10;

% 定義目標函數（需要最大化，但ga函數是最小化，所以取負值）
objective_function = @(x) -peaks_function(x(1), x(2), a, b);

% 定義約束條件（不等式約束 g(x) <= 0）
nonlinear_constraint = @(x) constraint_function(x);

% 設定變數範圍（基於兩個約束集合的交集）
lb = [-3, -3];  % 下界
ub = [3, 3];    % 上界

% 遺傳演算法參數設定
options = optimoptions('ga', ...
    'Display', 'iter', ...              % 顯示迭代過程
    'MaxGenerations', 100, ...          % 最大世代數
    'PopulationSize', 50, ...           % 族群大小
    'CrossoverFraction', 0.8, ...       % 交配比例
    'MutationFcn', @mutationadaptfeasible, ... % 突變函數
    'SelectionFcn', @selectiontournament, ...  % 選擇函數
    'PlotFcn', {@gaplotbestf, @gaplotbestindiv, @gaplotdistance}, ... % 繪圖函數
    'OutputFcn', @output_function, ...   % 輸出函數記錄進度
    'InitialPopulationRange', [lb; ub]); % 初始族群範圍

% 建立用於儲存結果的全域變數
global iteration_data;
iteration_data.x = [];
iteration_data.fval = [];
iteration_data.generation = [];
iteration_data.population_history = {};  % 儲存每代族群
iteration_data.scores_history = {};      % 儲存每代分數

% 執行遺傳演算法
[x_optimal, fval_optimal, exitflag, output, population, scores] = ...
    ga(objective_function, 2, [], [], [], [], lb, ub, nonlinear_constraint, options);

% 顯示結果
fprintf('\n=== 最佳化結果 ===\n');
fprintf('最佳解: x = %.6f, y = %.6f\n', x_optimal(1), x_optimal(2));
fprintf('最大值: f = %.6f\n', -fval_optimal);
fprintf('世代數: %d\n', output.generations);
fprintf('函數評估次數: %d\n', output.funccount);
fprintf('結束原因: %s\n', output.message);

% 顯示每一代的最佳解
fprintf('\n=== 每一代最佳解 ===\n');
fprintf('世代\t   x座標\t   y座標\t   目標函數值\n');
fprintf('----\t---------\t---------\t-----------\n');
for i = 1:length(iteration_data.generation)
    gen = iteration_data.generation(i);
    x_best = iteration_data.x(i, 1);
    y_best = iteration_data.x(i, 2);
    f_best = -iteration_data.fval(i);
    fprintf('%3d\t%9.6f\t%9.6f\t%11.6f\n', gen, x_best, y_best, f_best);
end

% 繪製等高線圖和最佳化進度
figure('Position', [100, 100, 1200, 400]);

% 子圖1: 等高線圖顯示約束區域和最佳解
subplot(1, 3, 1);
x_range = linspace(-4, 4, 100);
y_range = linspace(-4, 4, 100);
[X, Y] = meshgrid(x_range, y_range);
Z = peaks_function(X, Y, a, b);

% 繪製等高線
contour(X, Y, Z, 20, 'LineWidth', 1);
hold on;

% 繪製約束區域
theta = linspace(0, 2*pi, 100);
x_circle = 4 * cos(theta);  % 圓形約束邊界
y_circle = 4 * sin(theta);
plot(x_circle, y_circle, 'r--', 'LineWidth', 2, 'DisplayName', 'x²+y²≤16');

% 繪製方形約束邊界
rectangle('Position', [-3, -3, 6, 6], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 2);

% 標記最佳解
plot(x_optimal(1), x_optimal(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'red', ...
     'DisplayName', sprintf('最佳解 (%.3f, %.3f)', x_optimal(1), x_optimal(2)));

xlabel('x');
ylabel('y');
title('目標函數等高線圖與約束區域');
legend('Location', 'best');
grid on;
axis equal;
xlim([-4, 4]);
ylim([-4, 4]);

% 子圖2: 最佳化進度（目標函數值）
subplot(1, 3, 2);
if ~isempty(iteration_data.generation)
    plot(iteration_data.generation, -iteration_data.fval, 'b-o', 'LineWidth', 2);
    xlabel('世代數');
    ylabel('目標函數值');
    title('最佳化進度');
    grid on;
end

% 子圖3: 特定世代的族群分佈
subplot(1, 3, 3);
contour(X, Y, Z, 15, 'LineWidth', 0.5);
hold on;

% 繪製約束邊界
plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);
rectangle('Position', [-3, -3, 6, 6], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 1.5);

% 繪製最終族群
scatter(population(:, 1), population(:, 2), 30, scores, 'filled');
colorbar;
colormap('hot');

% 標記最佳個體
plot(x_optimal(1), x_optimal(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'white', ...
     'MarkerEdgeColor', 'black', 'LineWidth', 2);

xlabel('x');
ylabel('y');
title('最終族群分佈');
xlim([-4, 4]);
ylim([-4, 4]);
axis equal;

% 額外繪製：標記第1、50、100世代的族群位置
if length(iteration_data.generation) >= 3
    figure('Position', [100, 600, 1200, 400]);
    
    % 選擇要繪製的世代（根據實際世代數調整）
    total_generations = length(iteration_data.generation);
    if total_generations >= 100
        generations_to_plot = [1, 50, 100];
    elseif total_generations >= 50
        generations_to_plot = [1, min(50, total_generations), total_generations];
    else
        generations_to_plot = [1, ceil(total_generations/2), total_generations];
    end
    
    for i = 1:length(generations_to_plot)
        subplot(1, 3, i);
        contour(X, Y, Z, 15, 'LineWidth', 0.5);
        hold on;
        
        % 繪製約束邊界
        plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);
        rectangle('Position', [-3, -3, 6, 6], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 1.5);
        
        gen_idx = generations_to_plot(i);
        if gen_idx <= length(iteration_data.population_history) && ...
           ~isempty(iteration_data.population_history{gen_idx})
            % 使用實際記錄的族群資料
            pop_data = iteration_data.population_history{gen_idx};
            scores_data = iteration_data.scores_history{gen_idx};
            scatter(pop_data(:, 1), pop_data(:, 2), 50, scores_data, 'filled');
        else
            % 如果沒有記錄資料，在可行域內生成隨機點作為示例
            n_points = 20;
            sample_x = [];
            sample_y = [];
            count = 0;
            while count < n_points
                x_test = -3 + 6*rand();
                y_test = -3 + 6*rand();
                if x_test^2 + y_test^2 <= 16  % 滿足約束條件
                    sample_x = [sample_x; x_test];
                    sample_y = [sample_y; y_test];
                    count = count + 1;
                end
            end
            scatter(sample_x, sample_y, 50, 'filled');
        end
        
        xlabel('x');
        ylabel('y');
        title(sprintf('第 %d 世代族群分佈', gen_idx));
        xlim([-4, 4]);
        ylim([-4, 4]);
        axis equal;
        grid on;
        
        if i == 1
            colorbar;
        end
    end
end

%% 函數定義

% 目標函數（peaks函數）
function f = peaks_function(x, y, a, b)
    term1 = a * (1 - x.^2) .* exp(-x.^2 - (y+1).^2);
    term2 = -b * (x/5 - x.^3 - y.^5) .* exp(-x.^2 - y.^2);
    term3 = -exp(-(x+1).^2 - y.^2) / 3;
    f = term1 + term2 + term3;
end

% 約束函數
function [c, ceq] = constraint_function(x)
    % 不等式約束: g(x) <= 0
    % 約束1: x^2 + y^2 <= 16 變成 x^2 + y^2 - 16 <= 0
    c(1) = x(1)^2 + x(2)^2 - 16;
    
    % 方形約束 -3 <= x,y <= 3 已經透過邊界條件處理
    
    % 等式約束（無）
    ceq = [];
end

% 輸出函數：記錄最佳化進度
function [state, options, optchanged] = output_function(options, state, flag)
    global iteration_data;
    optchanged = false;
    
    switch flag
        case 'init'
            fprintf('\n=== 遺傳演算法開始執行 ===\n');
            fprintf('初始族群大小: %d\n', length(state.Population));
            
        case 'iter'
            % 記錄當前世代的最佳值
            iteration_data.generation = [iteration_data.generation; state.Generation];
            iteration_data.fval = [iteration_data.fval; state.Best(end)];
            
            % 找到當前世代的最佳個體
            [~, best_idx] = min(state.Score);
            best_individual = state.Population(best_idx, :);
            iteration_data.x = [iteration_data.x; best_individual];
            
            % 儲存整個族群和分數（可選，佔用較多記憶體）
            iteration_data.population_history{state.Generation} = state.Population;
            iteration_data.scores_history{state.Generation} = state.Score;
            
            % 即時輸出當前世代最佳解
            fprintf('世代 %3d: 最佳解 = (%.6f, %.6f), 目標值 = %.6f\n', ...
                    state.Generation, best_individual(1), best_individual(2), -state.Best(end));
                    
        case 'done'
            fprintf('=== 最佳化完成 ===\n');
    end
end