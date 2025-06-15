clear all, close all

% 設定隨機種子以獲得可重現的結果
% rng(14, 'twister')

% 定義 sawtooth 函數
sawtooth = @(x, y) sawtooth_func(x, y);

% 創建 GlobalSearch 求解器對象
gs = GlobalSearch;

% 設定 fmincon 選項
opts = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'iter');

% 定義目標函數
objective = @(x) sawtooth(x(1), x(2));

% 創建優化問題結構
problem = createOptimProblem('fmincon', ...
    'x0', [100, -50], ...           % 起始點
    'objective', objective, ...      % 目標函數
    'lb', [-100, -100], ...         % 下界
    'ub', [100, 100], ...           % 上界
    'options', opts);               % 求解器選項

% 運行 GlobalSearch
fprintf('正在運行 GlobalSearch...\n');
[xming, fming, flagg, outptg, manyminsg] = run(gs, problem);

% 顯示結果
fprintf('\n=== GlobalSearch 結果 ===\n');
fprintf('全域最小值點: x = %.6f, y = %.6f\n', xming(1), xming(2));
fprintf('全域最小值: f = %.6f\n', fming);
fprintf('退出標誌: %d\n', flagg);
fprintf('函數評估次數: %d\n', outptg.funcCount);

% 檢查多個解
fprintf('\n找到的所有局部最小值:\n');
for i = 1:length(manyminsg)
    fprintf('解 %d: x = [%.4f, %.4f], f = %.6f\n', ...
        i, manyminsg(i).X(1), manyminsg(i).X(2), manyminsg(i).Fval);
end

% 繪製函數值分佈直方圖
figure(2)
histogram([manyminsg.Fval], 10)
xlabel('函數值', 'FontSize', 12)
ylabel('頻次', 'FontSize', 12)
title('GlobalSearch 找到的局部最小值分佈', 'FontSize', 14)
grid on

% 在原函數圖上標記找到的最小值點
figure(3)
x = linspace(-100, 100, 200);
y = linspace(-100, 100, 200);
[X, Y] = meshgrid(x, y);
Z = sawtooth(X, Y);

contour(X, Y, Z, 20)
hold on
plot(xming(1), xming(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'red')
for i = 1:min(5, length(manyminsg))  % 只顯示前5個解以避免圖形過於雜亂
    plot(manyminsg(i).X(1), manyminsg(i).X(2), 'bo', 'MarkerSize', 6)
end
xlabel('x', 'FontSize', 12)
ylabel('y', 'FontSize', 12)
title('等高線圖與找到的最小值點', 'FontSize', 14)
legend('等高線', '全域最小值', '局部最小值', 'Location', 'best')
grid on
hold off

% sawtooth 函數定義
function f = sawtooth_func(x, y)
    % 極坐標函數 f(r,θ) = -g(r)h(θ)
    % 輸入: x, y - 直角坐標
    % 輸出: f - 函數值
    
    % 轉換為極坐標
    [t, r] = cart2pol(x, y);  % t = θ, r = r
    
    % 定義 h(θ) = 2 + cos(θ) + cos(2θ - 1/2)/2
    h = 2 + cos(t) + cos(2*t - 1/2)/2;
    
    % 定義 g(r) = [sin(r) - sin(2r)/2 + sin(3r)/3 - sin(4r)/4 + 4] * r²/(r+1)
    g = (sin(r) - sin(2*r)/2 + sin(3*r)/3 - sin(4*r)/4 + 4) .* (r.^2) ./ (r + 1);
    
    % 計算 f = -g(r)h(θ)
    f = g .* h;
end