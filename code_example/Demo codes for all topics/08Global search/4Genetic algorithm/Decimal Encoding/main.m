clear,clc,close all

f = @(x) sin(x) + x .* cos(x);   % 函式表示式
fplot(f, [0, 2*pi])             % 畫出函式影象

N = 50;                          % 種群上限
ger = 100;                       % 迭代次數
L = 5;                           % 基因長度
pc = 0.8;                        % 交叉概率
pm = 0.1;                        % 變異概率
dco = [10000; 1000; 100; 10 ;1]; % 解碼器
dna = randi([0, 9], [N, L]);     % 基因
x = dna * dco / 99999 * 2 * pi;  % 對初始種群解碼

hold on
plot(x, f(x),'ko','linewidth',3) % 畫出初始解的位置

x1 = zeros(N, L);                % 初始化子代基因，提速用
x2 = x1;                         % 同上
x3 = x1;                         % 同上
fi = zeros(N, 1);                % 初始化適應度，提速

for epoch = 1: ger               % 進化代數為100
    for i = 1: N                 % 交叉操作
        if rand < pc
           d = randi(N);            % 確定另一個交叉的個體
           m = dna(d,:);            % 確定另一個交叉的個體
           d = randi(L-1);          % 確定交叉斷點
           x1(i,:) = [dna(i,1:d), m(d+1:L)];  % 新個體 1        
           x2(i,:) = [m(1:d), dna(i,d+1:L)];  % 新個體 2
        end
    end
    x3 = dna;
    for i = 1: N                           % 變異操作
        if rand < pm
            x3(i,randi(L)) = randi([0, 9]);
        end
    end
    dna = [dna; x1; x2; x3];               % 合併新舊基因
    fi = f(dna * dco / 99999 * 2 * pi);    % 計算適應度，容易理解
    dna = [dna, fi];
    dna = flipud(sortrows(dna, L + 1));    % 對適應度進行排名
    while size(dna, 1) > N                 % 自然選擇
        d = randi(size(dna, 1));           % 排名法
        if rand < (d - 1) / size(dna, 1)
            dna(d,:) = [];
            fi(d, :) = [];
        end
    end
    dna = dna(:, 1:L);
end
x = dna * dco / 99999 * 2 * pi;            % 對最終種群解碼
plot(x, f(x),'ro','linewidth',3)           % 畫出最終解的位置
disp(['最優解為x=',num2str(x(1))]);
disp(['最優值為y=',num2str(fi(1))]);