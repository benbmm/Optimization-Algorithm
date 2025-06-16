%% Peaks Function Optimization - Part (a)
% 目標函數: f(x,y) = a(1-x²)e^(-x²-(y+1)²) - b(x/5-x³-y⁵)e^(-x²-y²) - e^(-(x+1)²-y²)/3
% 約束條件: Ω₁ = {[x,y]ᵀ : -3≤x,y≤3} 和 Ω₂ = {[x,y]ᵀ : x²+y²≤16}
% Part (a): 繪製目標函數在可行域 Ω₁ 上的圖形 (a=3, b=10)

clear; clc; close all;

%% 設定參數
a = 3;
b = 10;

%% 定義目標函數
peaks_func = @(x,y) a*(1-x.^2).*exp(-x.^2-(y+1).^2) - ...
                    b.*(x/5-x.^3-y.^5).*exp(-x.^2-y.^2) - ...
                    exp(-(x+1).^2-y.^2)/3;

%% 創建網格 (Ω₁: -3≤x,y≤3)
% 使用細密的網格以獲得更好的視覺效果
[X, Y] = meshgrid(-3:0.1:3, -3:0.1:3);
Z = peaks_func(X, Y);

%% 繪製3D表面圖
figure(1);
surf(X, Y, Z);
title('目標函數 f(x,y) 在可行域 Ω₁ 上的圖形 (a=3, b=10)', 'FontSize', 14);
xlabel('x', 'FontSize', 12); 
ylabel('y', 'FontSize', 12); 
zlabel('f(x,y)', 'FontSize', 12);
colorbar;
grid on;

% 設定視角以更好地觀察函數特性
view(45, 30);

% 添加更多的視覺化選項
shading interp;  % 平滑著色
colormap(jet);   % 使用彩虹色彩映射

%% 額外的視覺化：等高線圖
figure(2);
contour(X, Y, Z, 20, 'ShowText', 'on');
title('目標函數 f(x,y) 的等高線圖 (a=3, b=10)', 'FontSize', 14);
xlabel('x', 'FontSize', 12); 
ylabel('y', 'FontSize', 12);
colorbar;
grid on;

% 標記可行域邊界
hold on;
% 繪製 Ω₁ 的邊界 (正方形)
plot([-3, 3, 3, -3, -3], [-3, -3, 3, 3, -3], 'r-', 'LineWidth', 2, 'DisplayName', 'Ω₁ 邊界');
% 繪製 Ω₂ 的邊界 (圓形)
theta = 0:0.01:2*pi;
x_circle = 4*cos(theta);  % √16 = 4
y_circle = 4*sin(theta);
plot(x_circle, y_circle, 'b--', 'LineWidth', 2, 'DisplayName', 'Ω₂ 邊界');
legend('Location', 'best');
hold off;

%% 函數分析
fprintf('=== 目標函數分析 ===\n');
fprintf('函數形式: f(x,y) = a(1-x²)e^(-x²-(y+1)²) - b(x/5-x³-y⁵)e^(-x²-y²) - e^(-(x+1)²-y²)/3\n');
fprintf('參數設定: a = %d, b = %d\n', a, b);
fprintf('可行域 Ω₁: -3 ≤ x,y ≤ 3\n');
fprintf('約束條件 Ω₂: x² + y² ≤ 16\n');

% 計算函數在可行域內的統計信息
fprintf('\n=== 函數統計信息 ===\n');
fprintf('在可行域 Ω₁ 內:\n');
fprintf('  最大值: %.6f\n', max(Z(:)));
fprintf('  最小值: %.6f\n', min(Z(:)));
fprintf('  平均值: %.6f\n', mean(Z(:)));
fprintf('  標準差: %.6f\n', std(Z(:)));

% 找到最大值和最小值的位置
[max_val, max_idx] = max(Z(:));
[max_row, max_col] = ind2sub(size(Z), max_idx);
max_x = X(max_row, max_col);
max_y = Y(max_row, max_col);

[min_val, min_idx] = min(Z(:));
[min_row, min_col] = ind2sub(size(Z), min_idx);
min_x = X(min_row, min_col);
min_y = Y(min_row, min_col);

fprintf('\n最大值位置: (%.2f, %.2f), 函數值: %.6f\n', max_x, max_y, max_val);
fprintf('最小值位置: (%.2f, %.2f), 函數值: %.6f\n', min_x, min_y, min_val);

%% 在等高線圖上標記極值點
figure(2);
hold on;
plot(max_x, max_y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'red', 'DisplayName', '最大值點');
plot(min_x, min_y, 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'blue', 'DisplayName', '最小值點');
legend('Location', 'best');
hold off;