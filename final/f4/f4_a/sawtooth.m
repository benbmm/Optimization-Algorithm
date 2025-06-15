function f = sawtooth(x, y)
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