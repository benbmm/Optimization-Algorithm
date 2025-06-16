%% Peaks Function Optimization - Part (b)(ii)
% 比較不同PopulationSize和Reproduction Options
% 包括：EliteCount, CrossoverFraction, MutationFcn
% 目標函數: f(x,y) = a(1-x²)e^(-x²-(y+1)²) - b(x/5-x³-y⁵)e^(-x²-y²) - e^(-(x+1)²-y²)/3

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
lb = [-3, -3];  % Ω₁: -3 ≤ x,y ≤ 3
ub = [3, 3];
nonlcon = @(vars) deal(vars(1)^2 + vars(2)^2 - 16, []); % Ω₂: x² + y² ≤ 16

%% (ii) 比較不同PopulationSize和Reproduction Options

fprintf('=== Part (b)(ii): 比較PopulationSize和Reproduction Options ===\n\n');

%% 1. PopulationSize 影響分析

fprintf('1. PopulationSize 影響分析\n');
fprintf('%s\n', repmat('=', 1, 50));

population_sizes = [20, 50, 100, 200];
pop_results = zeros(length(population_sizes), 4); % [最優x, 最優y, 最大值, 迭代次數]

fprintf('%-15s %-12s %-12s %-12s %-12s\n', 'PopulationSize', '最優x', '最優y', '最大值', '迭代次數');
fprintf('%s\n', repmat('-', 1, 65));

for i = 1:length(population_sizes)
    options = optimoptions('ga', ...
        'PopulationSize', population_sizes(i), ...
        'MaxGenerations', 100, ...
        'Display', 'off');
    
    [x_opt, fval_opt, ~, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    
    pop_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations];
    
    fprintf('%-15d %-12.6f %-12.6f %-12.6f %-12d\n', ...
        population_sizes(i), x_opt(1), x_opt(2), -fval_opt, output.generations);
end

%% 2. EliteCount 影響分析

fprintf('\n2. EliteCount 影響分析\n');
fprintf('%s\n', repmat('=', 1, 50));

elite_counts = [2, 5, 10, 15];  % 精英個體數量
elite_results = zeros(length(elite_counts), 4);

fprintf('%-12s %-12s %-12s %-12s %-12s\n', 'EliteCount', '最優x', '最優y', '最大值', '迭代次數');
fprintf('%s\n', repmat('-', 1, 62));

for i = 1:length(elite_counts)
    options = optimoptions('ga', ...
        'PopulationSize', 50, ...
        'EliteCount', elite_counts(i), ...
        'MaxGenerations', 100, ...
        'Display', 'off');
    
    [x_opt, fval_opt, ~, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    
    elite_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations];
    
    fprintf('%-12d %-12.6f %-12.6f %-12.6f %-12d\n', ...
        elite_counts(i), x_opt(1), x_opt(2), -fval_opt, output.generations);
end

%% 3. CrossoverFraction 影響分析

fprintf('\n3. CrossoverFraction 影響分析\n');
fprintf('%s\n', repmat('=', 1, 50));

crossover_fractions = [0.5, 0.7, 0.8, 0.9];
crossover_results = zeros(length(crossover_fractions), 4);

fprintf('%-18s %-12s %-12s %-12s %-12s\n', 'CrossoverFraction', '最優x', '最優y', '最大值', '迭代次數');
fprintf('%s\n', repmat('-', 1, 68));

for i = 1:length(crossover_fractions)
    options = optimoptions('ga', ...
        'PopulationSize', 50, ...
        'CrossoverFraction', crossover_fractions(i), ...
        'MaxGenerations', 100, ...
        'Display', 'off');
    
    [x_opt, fval_opt, ~, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    
    crossover_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations];
    
    fprintf('%-18.1f %-12.6f %-12.6f %-12.6f %-12d\n', ...
        crossover_fractions(i), x_opt(1), x_opt(2), -fval_opt, output.generations);
end

%% 4. MutationFcn 影響分析（針對約束優化使用適當的突變函數）

fprintf('\n4. MutationFcn 影響分析\n');
fprintf('%s\n', repmat('=', 1, 50));

% 使用適合約束優化的突變函數和不同參數
mutation_configs = {
    {@mutationadaptfeasible, 0.01, 'Adaptive Feasible (低率)'};
    {@mutationadaptfeasible, 0.05, 'Adaptive Feasible (中率)'};
    {@mutationadaptfeasible, 0.1, 'Adaptive Feasible (高率)'};
};

mutation_results = zeros(length(mutation_configs), 4);

fprintf('%-25s %-12s %-12s %-12s %-12s\n', 'MutationFcn', '最優x', '最優y', '最大值', '迭代次數');
fprintf('%s\n', repmat('-', 1, 75));

for i = 1:length(mutation_configs)
    config = mutation_configs{i};
    options = optimoptions('ga', ...
        'PopulationSize', 50, ...
        'MutationFcn', {config{1}, config{2}}, ...
        'MaxGenerations', 100, ...
        'Display', 'off');
    
    [x_opt, fval_opt, ~, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    
    mutation_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations];
    
    fprintf('%-25s %-12.6f %-12.6f %-12.6f %-12d\n', ...
        config{3}, x_opt(1), x_opt(2), -fval_opt, output.generations);
end

%% 5. 組合參數優化

fprintf('\n5. 最佳參數組合搜尋\n');
fprintf('%s\n', repmat('=', 1, 50));

% 基於前面的分析結果，測試幾種組合
combinations = {
    struct('PopSize', 50, 'Elite', 5, 'Crossover', 0.8, 'MutationRate', 0.05, 'Name', '標準組合');
    struct('PopSize', 100, 'Elite', 10, 'Crossover', 0.7, 'MutationRate', 0.01, 'Name', '大族群組合');
    struct('PopSize', 50, 'Elite', 2, 'Crossover', 0.9, 'MutationRate', 0.1, 'Name', '高交叉組合');
    struct('PopSize', 200, 'Elite', 15, 'Crossover', 0.8, 'MutationRate', 0.05, 'Name', '強化搜索組合');
};

combo_results = zeros(length(combinations), 5); % 增加一列記錄函數評估次數

fprintf('%-18s %-12s %-12s %-12s %-12s %-15s\n', ...
    '參數組合', '最優x', '最優y', '最大值', '迭代次數', '函數評估次數');
fprintf('%s\n', repmat('-', 1, 85));

for i = 1:length(combinations)
    combo = combinations{i};
    
    options = optimoptions('ga', ...
        'PopulationSize', combo.PopSize, ...
        'EliteCount', combo.Elite, ...
        'CrossoverFraction', combo.Crossover, ...
        'MutationFcn', {@mutationadaptfeasible, combo.MutationRate}, ...
        'MaxGenerations', 100, ...
        'Display', 'off');
    
    [x_opt, fval_opt, ~, output] = ga(objective, 2, [], [], [], [], ...
        lb, ub, nonlcon, options);
    
    combo_results(i, :) = [x_opt(1), x_opt(2), -fval_opt, output.generations, output.funccount];
    
    fprintf('%-18s %-12.6f %-12.6f %-12.6f %-12d %-15d\n', ...
        combo.Name, x_opt(1), x_opt(2), -fval_opt, output.generations, output.funccount);
end

%% 視覺化結果

% 圖1: 參數影響分析
figure(1);
subplot(2, 2, 1);
plot(population_sizes, pop_results(:, 3), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
title('PopulationSize 對最優值的影響');
xlabel('Population Size');
ylabel('最大函數值');
grid on;

subplot(2, 2, 2);
plot(elite_counts, elite_results(:, 3), 'gs-', 'LineWidth', 2, 'MarkerSize', 8);
title('EliteCount 對最優值的影響');
xlabel('Elite Count');
ylabel('最大函數值');
grid on;

subplot(2, 2, 3);
plot(crossover_fractions, crossover_results(:, 3), 'b^-', 'LineWidth', 2, 'MarkerSize', 8);
title('CrossoverFraction 對最優值的影響');
xlabel('Crossover Fraction');
ylabel('最大函數值');
grid on;

subplot(2, 2, 4);
bar(mutation_results(:, 3));
mutation_labels = {'低突變率', '中突變率', '高突變率'};
set(gca, 'XTickLabel', mutation_labels);
title('MutationRate 對最優值的影響');
ylabel('最大函數值');
grid on;

% 圖2: 參數組合比較
figure(2);
combo_names = cell(length(combinations), 1);
for i = 1:length(combinations)
    combo_names{i} = combinations{i}.Name;
end
bar(combo_results(:, 3));
set(gca, 'XTickLabel', combo_names);
title('不同參數組合的性能比較');
ylabel('最大函數值');
% 標記數值
for i = 1:length(combinations)
    text(i, combo_results(i, 3) + 0.01, sprintf('%.4f', combo_results(i, 3)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end
grid on;

% 圖3: 效率 vs 性能分析
figure(3);
scatter(combo_results(:, 5), combo_results(:, 3), 100, 'filled');
xlabel('函數評估次數');
ylabel('最大函數值');
title('計算效率 vs 優化性能');
% 標記點
for i = 1:length(combinations)
    text(combo_results(i, 5) + 500, combo_results(i, 3), combo_names{i}, ...
        'FontSize', 9);
end
grid on;

%% 熱圖分析：PopulationSize vs CrossoverFraction

fprintf('\n6. PopulationSize vs CrossoverFraction 熱圖分析\n');
fprintf('%s\n', repmat('=', 1, 50));

pop_sizes_grid = [20, 50, 100];
cross_fractions_grid = [0.6, 0.8, 0.9];
heatmap_results = zeros(length(pop_sizes_grid), length(cross_fractions_grid));

for i = 1:length(pop_sizes_grid)
    for j = 1:length(cross_fractions_grid)
        options = optimoptions('ga', ...
            'PopulationSize', pop_sizes_grid(i), ...
            'CrossoverFraction', cross_fractions_grid(j), ...
            'MaxGenerations', 100, ...
            'Display', 'off');
        
        [~, fval_opt] = ga(objective, 2, [], [], [], [], ...
            lb, ub, nonlcon, options);
        
        heatmap_results(i, j) = -fval_opt;
    end
end

figure(4);
imagesc(cross_fractions_grid, pop_sizes_grid, heatmap_results);
colorbar;
colormap(jet);
title('PopulationSize vs CrossoverFraction 熱圖');
xlabel('CrossoverFraction');
ylabel('PopulationSize');
% 添加數值標籤
for i = 1:length(pop_sizes_grid)
    for j = 1:length(cross_fractions_grid)
        text(cross_fractions_grid(j), pop_sizes_grid(i), ...
            sprintf('%.3f', heatmap_results(i, j)), ...
            'HorizontalAlignment', 'center', 'Color', 'white', 'FontWeight', 'bold');
    end
end

%% 總結和建議

fprintf('\n=== 總結和建議 ===\n');

% 找出最佳組合
[best_combo_val, best_combo_idx] = max(combo_results(:, 3));
best_combo = combinations{best_combo_idx};

fprintf('最佳參數組合: %s\n', best_combo.Name);
fprintf('  PopulationSize: %d\n', best_combo.PopSize);
fprintf('  EliteCount: %d\n', best_combo.Elite);
fprintf('  CrossoverFraction: %.1f\n', best_combo.Crossover);
fprintf('  MutationRate: %.2f\n', best_combo.MutationRate);
fprintf('  最優函數值: %.6f\n', best_combo_val);

fprintf('\n參數影響分析:\n');
fprintf('1. PopulationSize: 較大的族群通常能找到更好的解，但計算成本增加\n');
fprintf('2. EliteCount: 適中的精英數量有助於保持優秀個體\n');
fprintf('3. CrossoverFraction: 0.7-0.8 範圍通常效果較好\n');
fprintf('4. MutationRate: 適中的突變率(0.05)在約束優化中表現較好\n');

% 效率分析
[min_funccount, min_idx] = min(combo_results(:, 5));
fprintf('\n效率最高組合: %s (函數評估次數: %d)\n', ...
    combinations{min_idx}.Name, min_funccount);

%% 統計分析
fprintf('\n=== 統計分析 ===\n');
fprintf('所有測試中:\n');
all_values = [pop_results(:,3); elite_results(:,3); crossover_results(:,3); mutation_results(:,3); combo_results(:,3)];
fprintf('  最大函數值: %.6f\n', max(all_values));
fprintf('  最小函數值: %.6f\n', min(all_values));
fprintf('  平均函數值: %.6f\n', mean(all_values));
fprintf('  標準差: %.6f\n', std(all_values));

% 參數穩定性分析
fprintf('\n參數穩定性分析:\n');
fprintf('  PopulationSize 穩定性: %.6f (標準差)\n', std(pop_results(:,3)));
fprintf('  EliteCount 穩定性: %.6f (標準差)\n', std(elite_results(:,3)));
fprintf('  CrossoverFraction 穩定性: %.6f (標準差)\n', std(crossover_results(:,3)));
fprintf('  MutationRate 穩定性: %.6f (標準差)\n', std(mutation_results(:,3)));