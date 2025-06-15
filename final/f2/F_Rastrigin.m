function f = F_Rastrigin(x, y)
% Rastrigin 函數：Ras(x) = 20 + x1² + x2² - 10(cos(2πx1) + cos(2πx2))
% 用於螞蟻群演算法尋找最大值
% 輸入：x, y - 變數值
% 輸出：f - 函數值

f = 20 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y);
end