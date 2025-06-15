function f = F(x,y)
%f = -(x.^2+3*y.^4-0.2*cos(3*pi*x)-0.4*cos(4*pi*y)+0.6);
f=-(x.^2+y.^2-10*cos(2*pi*x)-10*cos(2*pi*y)+20);
end
