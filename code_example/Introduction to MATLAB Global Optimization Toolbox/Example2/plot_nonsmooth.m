figure

x = linspace(-5,5,51);
[xx,yy] = meshgrid(x);
zz = zeros(size(xx));
for ii = 1:length(x)
    for jj = 1:length(x)
        zz(ii,jj) = sqrt(norm([xx(ii,jj),yy(ii,jj);0,0]));
    end
end
surf(xx,yy,zz)
xlabel('x(1)')
ylabel('x(2)')
title('Norm([x(1),x(2);0,0])^{1/2}')

