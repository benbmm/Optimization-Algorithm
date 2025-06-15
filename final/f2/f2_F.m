clear, clc

% 螞蟻群演算法參數
Ant = 300; % 螞蟻數量
Times = 80; % 移動次數
Rou = 0.9; % 荷爾蒙發揮係數
P0 = 0.2; % 轉移概率

% 搜索範圍
Lower_1 = -5; % x1 的下界
Upper_1 = 5;  % x1 的上界
Lower_2 = -5; % x2 的下界
Upper_2 = 5;  % x2 的上界

% 初始化螞蟻位置和荷爾蒙
for i = 1:Ant
    X(i,1) = (Lower_1 + (Upper_1 - Lower_1) * rand);
    X(i,2) = (Lower_2 + (Upper_2 - Lower_2) * rand);
    Tau(i) = F_Rastrigin(X(i,1), X(i,2));
end

% 繪圖參數
step = 0.05;
% 修改：使用 Rastrigin 函數
f = '20 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y)';

[x, y] = meshgrid(Lower_1:step:Upper_1, Lower_2:step:Upper_2);
z = eval(f);

% 繪製初始狀態
figure(1);
subplot(1,2,1);
mesh(x, y, z);
hold on;
plot3(X(:,1), X(:,2), Tau, 'k*')
hold on;
text(0.1, 0.8, -0.1, '螞蟻的初始位置分佈');
xlabel('x1');
ylabel('x2');
zlabel('Rastrigin(x1,x2)');
title('螞蟻群演算法 - 初始狀態');

% 螞蟻群演算法主循環
for T = 1:Times
    lamda = 1/T;
    [Tau_Best(T), BestIndex] = max(Tau);
    
    % 計算轉移狀態概率
    for i = 1:Ant
        P(T,i) = (Tau(BestIndex) - Tau(i)) / Tau(BestIndex);
    end
    
    % 螞蟻移動
    for i = 1:Ant
        if P(T,i) < P0 % 局部搜索
            temp1 = X(i,1) + (2*rand - 1) * lamda;
            temp2 = X(i,2) + (2*rand - 1) * lamda;
        else % 全域搜索
            temp1 = X(i,1) + (Upper_1 - Lower_1) * (rand - 0.5);
            temp2 = X(i,2) + (Upper_2 - Lower_2) * (rand - 0.5);
        end
        
        % 越界處理
        if temp1 < Lower_1
            temp1 = Lower_1;
        end
        if temp1 > Upper_1
            temp1 = Upper_1;
        end
        if temp2 < Lower_2
            temp2 = Lower_2;
        end
        if temp2 > Upper_2
            temp2 = Upper_2;
        end
        
        % 更新位置（如果新位置更好）
        if F_Rastrigin(temp1, temp2) > F_Rastrigin(X(i,1), X(i,2))
            X(i,1) = temp1;
            X(i,2) = temp2;
        end
    end
    
    % 更新荷爾蒙
    for i = 1:Ant
        Tau(i) = (1 - Rou) * Tau(i) + F_Rastrigin(X(i,1), X(i,2));
    end
end

% 繪製最終狀態
subplot(1,2,2);
mesh(x, y, z);
hold on;
x_final = X(:,1);
y_final = X(:,2);
z_final = F_Rastrigin(x_final, y_final);
plot3(x_final, y_final, z_final, 'k*');
hold on;
text(0.1, 0.8, -0.1, '螞蟻的最終位置分佈');
xlabel('x1');
ylabel('x2');
zlabel('Rastrigin(x1,x2)');
title('螞蟻群演算法 - 最終狀態');

% 找出最優解
[max_value, max_index] = max(Tau);
maxX1 = X(max_index, 1);
maxX2 = X(max_index, 2);
maxValue = F_Rastrigin(X(max_index, 1), X(max_index, 2));

% 顯示結果
fprintf('螞蟻群演算法結果：\n');
fprintf('最優解：x1 = %.4f, x2 = %.4f\n', maxX1, maxX2);
fprintf('最大值：f(x1,x2) = %.4f\n', maxValue);

% 理論最優解
fprintf('\n理論最優解：\n');
fprintf('最優解：x1 = 0, x2 = 0\n');
fprintf('最大值：f(0,0) = 20\n');

% 繪製收斂曲線
figure(2);
plot(1:Times, Tau_Best, 'b-', 'LineWidth', 2);
xlabel('迭代次數');
ylabel('最佳適應度值');
title('螞蟻群演算法收斂曲線');
grid on;

% Rastrigin 函數定義
function f = F_Rastrigin(x, y)
    % Rastrigin 函數：Ras(x) = 20 + x1² + x2² - 10(cos(2πx1) + cos(2πx2))
    f = 20 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y);
end