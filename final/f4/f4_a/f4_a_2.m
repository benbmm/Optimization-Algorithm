clear all, close all

% 創建網格
x = linspace(-100, 100, 200);
y = linspace(-100, 100, 200);
[X, Y] = meshgrid(x, y);

% 計算函數值
Z = sawtooth(X, Y);

% 創建表面圖
figure(1)
surf(X, Y, Z, 'EdgeColor', 'none')
colormap(gray)
shading interp
xlabel('x', 'FontSize', 12)
ylabel('y', 'FontSize', 12)
zlabel('f(x,y)', 'FontSize', 12)
title('Surface Plot of f(r,θ) = g(r)h(θ)', 'FontSize', 14)
view(45, 30)
grid on
colorbar