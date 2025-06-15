clear all, close all

% 定義目標函數 f(x,y) = sawtoothxy(x,y)
function f = sawtoothxy(x,y)
    % 將直角坐標轉換為極坐標
    [t,r] = cart2pol(x,y);
    
    % 填入g(r)的計算
    g = sin(r) - sin(2*r)/2 + sin(3*r)/3 - sin(4*r)/4 + r^2/(r+1);
    
    % 填入h(θ)的計算  
    h = 2 + cos(t) + cos(2*t - 1)/2;
    
    % 計算目標函數值
    f = g * h;
end

% 創建MultiStart求解器對象
ms = MultiStart;

% 設置優化選項（使用fminunc求解器）
opts = optimoptions(@fminunc,'Algorithm','quasi-newton');

% 創建問題結構
problem = createOptimProblem('fminunc',...
    'x0',[100, -50],...  % 初始點
    'objective',@(x) sawtoothxy(x(1), x(2)),...
    'options',opts);

% 創建自定義起始點
% 10個隨機生成的點
rng(42); % 設置隨機種子以確保可重現性
random_points = -100 + 200*rand(10,2); % 在[-100,100]範圍內生成隨機點

% 10個圍繞[100, -50]中心的點，使用適當的統計方差
center = [100, -50];
variance = 20; % 適當的方差
centered_points = center + variance*randn(10,2);

% 合併所有起始點
start_points = [random_points; centered_points];

% 創建CustomStartPointSet
startpts = CustomStartPointSet(start_points);

% 運行MultiStart優化
[xminm, fminm, flagm, outptm, manyminsm] = run(ms, problem, startpts);

% 顯示結果
fprintf('=== MultiStart 優化結果 ===\n');
fprintf('最佳解: x = %.6f, y = %.6f\n', xminm(1), xminm(2));
fprintf('最小值: f = %.6f\n', fminm);
fprintf('退出標誌: %d\n', flagm);
fprintf('總共找到 %d 個局部最小值\n', length(manyminsm));

% 列出所有找到的局部最小值
fprintf('\n=== 所有局部最小值 ===\n');
fprintf('序號\t   x值\t\t   y值\t\t  函數值\t  退出標誌\n');
fprintf('------------------------------------------------------------\n');
for i = 1:length(manyminsm)
    fprintf('%2d\t%8.4f\t%8.4f\t%10.6f\t\t%d\n', ...
        i, manyminsm(i).X(1), manyminsm(i).X(2), ...
        manyminsm(i).Fval, manyminsm(i).Exitflag);
end

% 創建函數值的直方圖
figure;
histogram([manyminsm.Fval], 10);
title('局部最小值分布直方圖');
xlabel('函數值');
ylabel('頻率');
grid on;

% 顯示收斂的局部最小值（退出標誌 > 0）
converged_solutions = manyminsm([manyminsm.Exitflag] > 0);
if ~isempty(converged_solutions)
    fprintf('\n=== 收斂的局部最小值 ===\n');
    fprintf('共有 %d 個收斂解\n', length(converged_solutions));
    unique_fvals = unique(round([converged_solutions.Fval]*1e6)/1e6);
    fprintf('唯一的函數值: ');
    fprintf('%.6f ', unique_fvals);
    fprintf('\n');
end