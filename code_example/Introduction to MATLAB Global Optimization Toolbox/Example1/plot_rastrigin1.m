clear all, clc

x1=[-5:0.1:5];
x2=[-5:0.1:5];
y=rastringis(x1,x2)
meshc(x1,x2,y);
xlabel('x'), ylabel('y')
title('Rastrigins Function: Non-scaled Version')

function [y]=rastringis(x1,x2)
dx1=length(x1);
dx2=length(x2);
for i=1:dx1
    for j=1:dx2
        y(i,j)=(20+x1(i).^2+x2(j).^2)-10*(cos(2*pi*x1(i)) ...
        +cos(2*pi*x2(j)));
    end
end
end

