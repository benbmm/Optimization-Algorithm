clear, clc, close all

% 定義目標函數
f = @(x) -(x-5).^2 + 4; % 函式表示式：f(x) = -(x-5)² + 4

% 畫出函式圖形
fplot(f, [0, 10]) % 畫出函式影象，區間改為 [0, 10]
grid on
xlabel('x')
ylabel('f(x)')
title('f(x) = -(x-5)^2 + 4')

% 遺傳演算法參數
N = 50; % 種群上限
ger = 100; % 迭代次數
L = 5; % 基因長度
pc = 0.8; % 交叉概率
pm = 0.1; % 變異概率

% 解碼器（十進制編碼）
dco = [10000; 1000; 100; 10; 1]; % 解碼器

% 初始化種群
dna = randi([0, 9], [N, L]); % 基因

% 對初始種群解碼到區間 [0, 10]
x = dna * dco / 99999 * 10; % 修改：映射到 [0, 10] 區間

hold on
plot(x, f(x), 'ko', 'linewidth', 3) % 畫出初始解的位置

% 初始化變量
x1 = zeros(N, L); % 初始化子代基因，提速用
x2 = x1; % 同上
x3 = x1; % 同上
fi = zeros(N, 1); % 初始化適應度，提速

% 遺傳演算法主循環
for epoch = 1:ger % 進化代數為100
    % 交叉操作
    for i = 1:N
        if rand < pc
            d = randi(N); % 確定另一個交叉的個體
            m = dna(d, :); % 確定另一個交叉的個體
            crossover_point = randi(L-1); % 確定交叉斷點
            x1(i, :) = [dna(i, 1:crossover_point), m(crossover_point+1:L)]; % 新個體 1
            x2(i, :) = [m(1:crossover_point), dna(i, crossover_point+1:L)]; % 新個體 2
        end
    end
    
    % 變異操作
    x3 = dna;
    for i = 1:N
        if rand < pm
            x3(i, randi(L)) = randi([0, 9]);
        end
    end
    
    % 合併新舊基因
    dna = [dna; x1; x2; x3];
    
    % 計算適應度（解碼到 [0, 10] 區間）
    fi = f(dna * dco / 99999 * 10); % 修改：映射到 [0, 10] 區間
    
    % 將適應度加入基因矩陣
    dna = [dna, fi];
    
    % 對適應度進行排名（降序排列，因為要找最大值）
    dna = flipud(sortrows(dna, L + 1));
    
    % 自然選擇
    while size(dna, 1) > N
        d = randi(size(dna, 1)); % 排名法
        if rand < (d - 1) / size(dna, 1)
            dna(d, :) = [];
            fi(d, :) = [];
        end
    end
    
    % 移除適應度列，保留基因
    dna = dna(:, 1:L);
end

% 對最終種群解碼
x = dna * dco / 99999 * 10; % 修改：映射到 [0, 10] 區間

% 畫出最終解的位置
plot(x, f(x), 'ro', 'linewidth', 3)

% 顯示結果
disp(['最優解為 x = ', num2str(x(1))]);
disp(['最優值為 f(x) = ', num2str(f(x(1)))]);

% 理論最優解
disp('理論最優解：x = 5, f(x) = 4');

% 添加圖例
legend('函數曲線', '初始種群', '最終種群', 'Location', 'best')