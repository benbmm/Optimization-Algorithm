function main()
    fprintf('線性規劃問題求解\n');
    fprintf('目標: 最大化 x₁ + 2x₂\n');
    fprintf('約束條件:\n');
    fprintf('  -2x₁ + x₂ + x₃ = 2\n');
    fprintf('  -x₁ + 2x₂ + x₄ = 7\n');
    fprintf('  x₁ + x₅ = 3\n');
    fprintf('  xᵢ ≥ 0, i = 1,2,3,4,5\n\n');
    
    % 執行問題導向解法
    fprintf('======= 問題導向解法 =======\n');
    problem_based_approach();
    
    % 執行求解器導向解法
    fprintf('\n======= 求解器導向解法 =======\n');
    solver_based_approach();
end

% 方法一：問題導向解法
function problem_based_approach()
    % 創建優化問題
    prob = optimproblem('ObjectiveSense', 'maximize');
    
    % 定義變數 (所有變數非負)
    x = optimvar('x', 5, 'LowerBound', 0);
    
    % 定義目標函數 (最大化 x₁ + 2x₂)
    prob.Objective = x(1) + 2*x(2);
    
    % 定義約束條件
    prob.Constraints.con1 = -2*x(1) + x(2) + x(3) == 2;
    prob.Constraints.con2 = -x(1) + 2*x(2) + x(4) == 7;
    prob.Constraints.con3 = x(1) + x(5) == 3;
    
    % 求解問題
    x0.x = zeros(5, 1); % 初始點
    [sol, fval, exitflag, output] = solve(prob, x0);
    
    % 顯示結果
    fprintf('最優解:\n');
    for i = 1:5
        fprintf('x%d = %.4f\n', i, sol.x(i));
    end
    fprintf('目標函數值 = %.4f\n', fval);
    
    % 檢查約束條件是否滿足
    check_constraints(sol.x);
end

% 方法二：求解器導向解法
function solver_based_approach()
    % 定義目標函數的係數 (最大化 x₁ + 2x₂)
    % 注意：linprog 是最小化問題，所以我們對係數取負值使其成為最大化
    f = [-1; -2; 0; 0; 0];
    
    % 定義不等式約束 Ax <= b (這裡沒有不等式約束，除了非負約束)
    A = [];
    b = [];
    
    % 定義等式約束 Aeq*x = beq
    Aeq = [-2, 1, 1, 0, 0;
           -1, 2, 0, 1, 0;
            1, 0, 0, 0, 1];
    beq = [2; 7; 3];
    
    % 定義變數下限 (所有變數非負)
    lb = zeros(5, 1);
    
    % 定義變數上限 (無上限)
    ub = [];
    
    % 定義選項
    options = optimoptions('linprog', 'Display', 'iter');
    
    % 求解線性規劃問題
    [x, fval, exitflag, output] = linprog(f, A, b, Aeq, beq, lb, ub, options);
    
    % 顯示結果
    fprintf('最優解:\n');
    for i = 1:5
        fprintf('x%d = %.4f\n', i, x(i));
    end
    fprintf('目標函數值 = %.4f\n', -fval); % 轉回最大化問題的值
    
    % 檢查約束條件是否滿足
    check_constraints(x);
end

% 檢查約束條件是否滿足
function check_constraints(x)
    fprintf('\n檢查約束條件:\n');
    
    % 檢查-2x₁ + x₂ + x₃ = 2
    con1_val = -2*x(1) + x(2) + x(3);
    fprintf('約束1: -2x₁ + x₂ + x₃ = %.4f (應該等於2)\n', con1_val);
    
    % 檢查-x₁ + 2x₂ + x₄ = 7
    con2_val = -x(1) + 2*x(2) + x(4);
    fprintf('約束2: -x₁ + 2x₂ + x₄ = %.4f (應該等於7)\n', con2_val);
    
    % 檢查x₁ + x₅ = 3
    con3_val = x(1) + x(5);
    fprintf('約束3: x₁ + x₅ = %.4f (應該等於3)\n', con3_val);
    
    % 檢查非負約束
    all_non_negative = all(x >= 0);
    if all_non_negative
        fprintf('非負約束: 所有變數都非負\n');
    else
        fprintf('非負約束: 不滿足! 某些變數為負\n');
    end
end