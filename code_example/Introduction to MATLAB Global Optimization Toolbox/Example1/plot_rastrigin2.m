clear all, clc

rf3 = @(x,y)reshape(rastriginsfcn([x(:)/10,y(:)/10]),size(x));
fsurf(rf3,[-30 30],'ShowContours','on')
title('Rastrigins Function: Scaled Version')
xlabel('x'), ylabel('y')

