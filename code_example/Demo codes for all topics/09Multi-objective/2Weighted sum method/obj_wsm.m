function F = obj_wsm (x)
d = x(1); h = x(2); w = x(3);

f1 = 2*(d*h + h*w) + d*w;

f2 = -(d*h*w);

global w1
F = w1*f1+(1-w1)*f2;
end

