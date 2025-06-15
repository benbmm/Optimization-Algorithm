function [g,h] = cons_wsm (x)
d = x(1); h = x(2); w = x(3);

g(1) = h-w;
g(2) = 2.5*h - d;

h = [];
end

