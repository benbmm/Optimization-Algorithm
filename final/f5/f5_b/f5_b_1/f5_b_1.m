%% Peaks Function Optimization - Part (b)(i)
% 使用遺傳演算法比較不同Selection Options
% 目標函數: f(x,y) = a(1-x²)e^(-x²-(y+1)²) - b(x/5-x³-y⁵)e^(-x²-y²) - e^(-(x+1)²-y²)/3
% 約束條件: Ω = Ω₁ ∩ Ω₂

clear; clc; close all;

%% 設定參數
a = 3;
b = 10;

%% 定義目標函數
peaks_func = @(x,y) a*(1-x.^2).*exp(-x.^2-(y+1).^2) - ...
                    b.*(x/5-x.^3-y.^5).*exp(-x.^2-y.^2) - ...
                    exp(-(x+1).^2-y.^2)/3;

% 目標函數（用於最大化，所以取負值進行最小化）
objective = @(vars) -peaks_func(vars(1), vars(2));

%% 約束條件設定
% Ω = Ω₁ ∩ Ω₂
% 線性約束 Ω₁: -3 ≤ x,y ≤ 3
lb = [-3, -3];
ub = [3, 3];

% 非線性約束 Ω₂: x² + y² ≤ 16
nonlcon = @(vars) deal(vars(1)^2 + vars(2)^2 - 16, []);

%% (i) 比較不同Selection Options

fprintf('=== Part (b)(i): 比較不同Selection Options ===\n');
fprintf('測試四種選擇策略的性能差異\n\n');

% 四種選擇方法 (使用正確的函數句柄格式)
selection_methods = {@selectionstochunif, @selectionremainder, @selectionroulette, @selectiontournament};
selection_names = {'隨機均勻抽樣', '餘數隨機抽樣', '輪盤賭選擇', '錦標賽選擇'};
selection_results = cell(length(selection_methods), 1);

% 儲存結果用於比較
all_results = zeros(length(selection_methods), 5); % [最優x, 最優y, 最大值, 迭代次數, 函數評估次數]

fprintf('開始測試各種選擇策略...\n');
fprintf('%-20s %-15s %-15s %-12s %-12s %-15s\n', ...
    '選擇方法', '最優x', '最優y', '最大值', '迭代次數', '函數評估次數');
fprintf('%s\n', repmat('-', 1, 90));

for i = 1:length(selection_methods)
    fprintf('正在測試: %s...\n', selection_names{i});
    
    % 設定遺傳演算法選項
    options = optimoptions('ga', ...
        'SelectionFcn', selection_methods{i}, ...
        'PopulationSize', 50, ...
        'MaxGenerations', 100, ...
        'PlotFcn', {@gaplotbestf}, ...  % 只顯示最佳適應度圖
        'Display', 'off', ...  % 關閉詳細輸出
        'UseParallel', false);
    
    % 執行優化
    tic;
    [x_opt, fval_opt, exitflag, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    elapsed_time = toc;
    
    % 儲存結果
    selection_results{i} = struct(...
        'method', func2str(selection_methods{i}), ...
        'name', selection_names{i}, ...
        'x', x_opt, ...
        'fval', -fval_opt, ...  % 轉回最大值
        'output', output, ...
        'time', elapsed_time);
    
    % 記錄結果矩陣
    all_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations, output.funccount];
    
    % 輸出結果
    fprintf('%-20s %-15.6f %-15.6f %-12.6f %-12d %-15d\n', ...
        selection_names{i}, x_opt(1), x_opt(2), -fval_opt, ...
        output.generations, output.funccount);
end

%% 結果分析和比較

fprintf('\n=== 詳細結果分析 ===\n');

% 找出最佳結果
[best_fval, best_idx] = max(all_results(:, 3));
best_method = selection_names{best_idx};

fprintf('最佳結果來自: %s\n', best_method);
fprintf('最優解: x* = (%.6f, %.6f)\n', all_results(best_idx, 1), all_results(best_idx, 2));
fprintf('最大函數值: f* = %.6f\n', best_fval);

% 計算統計信息
fprintf('\n=== 各方法統計比較 ===\n');
fprintf('函數值統計:\n');
fprintf('  平均值: %.6f\n', mean(all_results(:, 3)));
fprintf('  標準差: %.6f\n', std(all_results(:, 3)));
fprintf('  最大值: %.6f (%s)\n', max(all_results(:, 3)), selection_names{best_idx});
fprintf('  最小值: %.6f (%s)\n', min(all_results(:, 3)), ...
    selection_names{all_results(:, 3) == min(all_results(:, 3))});

fprintf('\n迭代次數統計:\n');
fprintf('  平均迭代次數: %.1f\n', mean(all_results(:, 4)));
fprintf('  函數評估次數平均: %.1f\n', mean(all_results(:, 5)));

%% 視覺化比較結果

% 1. 最優函數值比較
figure(1);
bar(all_results(:, 3));
set(gca, 'XTickLabel', selection_names);
title('不同Selection Options的最優函數值比較', 'FontSize', 14);
ylabel('最大函數值', 'FontSize', 12);
xlabel('選擇方法', 'FontSize', 12);
grid on;
% 標記數值
for i = 1:length(selection_methods)
    text(i, all_results(i, 3) + 0.1, sprintf('%.4f', all_results(i, 3)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end

% 2. 收斂性能比較
figure(2);
subplot(2, 1, 1);
bar(all_results(:, 4));
set(gca, 'XTickLabel', selection_names);
title('迭代次數比較', 'FontSize', 12);
ylabel('迭代次數', 'FontSize', 10);
grid on;

subplot(2, 1, 2);
bar(all_results(:, 5));
set(gca, 'XTickLabel', selection_names);
title('函數評估次數比較', 'FontSize', 12);
ylabel('函數評估次數', 'FontSize', 10);
xlabel('選擇方法', 'FontSize', 12);
grid on;

% 3. 最優解位置比較
figure(3);
% 繪製等高線圖作為背景
[X, Y] = meshgrid(-3:0.2:3, -3:0.2:3);
Z = peaks_func(X, Y);
% 應用約束條件
constraint_mask = X.^2 + Y.^2 <= 16;
Z(~constraint_mask) = NaN;

contour(X, Y, Z, 15);
hold on;

% 繪製約束邊界
theta = 0:0.01:2*pi;
x_circle = 4*cos(theta);
y_circle = 4*sin(theta);
plot(x_circle, y_circle, 'k--', 'LineWidth', 2, 'DisplayName', '約束邊界 (x²+y²≤16)');

% 標記各方法找到的最優解
colors = ['ro'; 'gs'; 'b^'; 'md'];
for i = 1:length(selection_methods)
    plot(all_results(i, 1), all_results(i, 2), colors(i,:), 'MarkerSize', 10, ...
        'MarkerFaceColor', colors(i,1), 'DisplayName', selection_names{i});
end

title('不同Selection Options找到的最優解位置', 'FontSize', 14);
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
legend('Location', 'best');
grid on;
colorbar;
hold off;

%% 性能評估和建議

fprintf('\n=== 性能評估和建議 ===\n');

% 計算性能指標
performance_score = zeros(length(selection_methods), 1);
for i = 1:length(selection_methods)
    % 綜合評分 = 函數值權重 * 正規化函數值 + 效率權重 * (1 - 正規化迭代次數)
    norm_fval = (all_results(i, 3) - min(all_results(:, 3))) / ...
                (max(all_results(:, 3)) - min(all_results(:, 3)));
    norm_iter = (all_results(i, 4) - min(all_results(:, 4))) / ...
                (max(all_results(:, 4)) - min(all_results(:, 4)));
    
    performance_score(i) = 0.7 * norm_fval + 0.3 * (1 - norm_iter);
end

[~, best_performance_idx] = max(performance_score);

fprintf('綜合性能排名 (考慮函數值和收斂速度):\n');
[sorted_scores, sorted_idx] = sort(performance_score, 'descend');
for i = 1:length(selection_methods)
    idx = sorted_idx(i);
    fprintf('%d. %s (評分: %.3f)\n', i, selection_names{idx}, sorted_scores(i));
end

fprintf('\n建議:\n');
fprintf('- 追求最高函數值: 選擇 %s\n', best_method);
fprintf('- 綜合性能最佳: 選擇 %s\n', selection_names{best_performance_idx});

% 約束條件檢查
fprintf('\n=== 約束條件檢查 ===\n');
for i = 1:length(selection_methods)
    x_val = all_results(i, 1);
    y_val = all_results(i, 2);
    constraint_value = x_val^2 + y_val^2;
    
    fprintf('%s: x²+y² = %.6f ≤ 16? %s\n', ...
        selection_names{i}, constraint_value, ...
        string(constraint_value <= 16));
end