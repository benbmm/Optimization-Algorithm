function main()
    % 初始點
    x0 = [0, 0];
    
    % 定義 fmincon 的選項
    options = optimoptions('fmincon', 'Display', 'iter', ...
                          'Algorithm', 'interior-point', ...
                          'SpecifyObjectiveGradient', true, ...
                          'SpecifyConstraintGradient', true);
    
    % 定義邊界（本題沒有明確邊界，設為空）
    lb = [];
    ub = [];
    
    % 定義線性約束（本題沒有線性約束，設為空）
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % 執行 fmincon
    [x_opt, f_opt] = fmincon(@objective_with_grad, x0, A, b, Aeq, beq, lb, ub, @constraints_with_grad, options);
    
    % 顯示結果
    fprintf('最佳解: x1 = %.6f, x2 = %.6f\n', x_opt(1), x_opt(2));
    fprintf('目標函數值: %.6f\n', f_opt);
    
    % 檢查約束
    [c, ceq] = constraints_with_grad(x_opt);
    fprintf('約束條件 1: %.6f (應該 <= 0)\n', c(1));
    fprintf('約束條件 2: %.6f (應該 <= 0)\n', c(2));
    
    % 可視化最佳解
    visualize_solution(x_opt);
end

function [f, grad] = objective_with_grad(x)
    % 提取變數
    x1 = x(1);
    x2 = x(2);
    
    % 計算指數部分
    exponent = 4*x1^2 + 4*x1*x2 + 2*x2^2 + 2*x2 + 1;
    
    % 目標函數
    f = exp(exponent);
    
    % 目標函數的梯度
    if nargout > 1
        % 關於 x1 的偏導數
        df_dx1 = f * (8*x1 + 4*x2);
        
        % 關於 x2 的偏導數
        df_dx2 = f * (4*x1 + 4*x2 + 2);
        
        grad = [df_dx1; df_dx2];
    end
end

function [c, ceq, gradc, gradceq] = constraints_with_grad(x)
    % 提取變數
    x1 = x(1);
    x2 = x(2);
    
    % 不等式約束 (c <= 0)
    c = [x1*x2 - x1 - x2 + 1.5;   % 第一個約束: x1*x2 - x1 - x2 <= -1.5
         -x1*x2 - 10];            % 第二個約束: -x1*x2 - 10 <= 0
    
    % 無等式約束
    ceq = [];
    
    % 不等式約束的梯度
    if nargout > 2
        % 第一個約束的梯度: d/dx1 = x2-1, d/dx2 = x1-1
        gradc1 = [x2-1; x1-1];
        
        % 第二個約束的梯度: d/dx1 = -x2, d/dx2 = -x1
        gradc2 = [-x2; -x1];
        
        gradc = [gradc1, gradc2];
        gradceq = [];
    end
end

function visualize_solution(x_opt)
    % 建立繪圖網格
    [X1, X2] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
    Z = zeros(size(X1));
    
    % 計算目標函數值
    for i = 1:size(X1, 1)
        for j = 1:size(X1, 2)
            x = [X1(i,j), X2(i,j)];
            [Z(i,j), ~] = objective_with_grad(x);
        end
    end
    
    % 建立新的圖形
    figure;
    
    % 繪製等高線圖
    subplot(2,1,1);
    contour(X1, X2, Z, 20, 'LineWidth', 1.5);
    hold on;
    
    % 繪製約束條件
    x1_range = linspace(-5, 5, 100);
    x2_c1 = (x1_range + 1.5)./(x1_range - 1); % 從 x1*x2 - x1 - x2 = -1.5 解出 x2
    x2_c2 = -10./x1_range; % 從 -x1*x2 = 10 解出 x2
    
    % 繪製約束條件線
    plot(x1_range, x2_c1, 'r-', 'LineWidth', 2, 'DisplayName', 'x1*x2-x1-x2=-1.5');
    plot(x1_range, x2_c2, 'g-', 'LineWidth', 2, 'DisplayName', '-x1*x2=10');
    
    % 標示最佳解
    plot(x_opt(1), x_opt(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', '最佳解');
    
    % 添加圖例和標籤
    legend('Location', 'best');
    xlabel('x1');
    ylabel('x2');
    title('優化問題的等高線圖與約束條件');
    grid on;
    
    % 繪製3D曲面圖
    subplot(2,1,2);
    surf(X1, X2, log(Z), 'EdgeColor', 'none', 'FaceAlpha', 0.7);
    hold on;
    
    % 在3D曲面上標示最佳解
    [f_opt, ~] = objective_with_grad(x_opt);
    plot3(x_opt(1), x_opt(2), log(f_opt), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % 添加標籤
    xlabel('x1');
    ylabel('x2');
    zlabel('log(目標函數)');
    title('目標函數的對數曲面 (取對數以便觀察)');
    colorbar;
    grid on;
    
    % 調整圖形
    set(gcf, 'Position', [100, 100, 800, 700]);
end