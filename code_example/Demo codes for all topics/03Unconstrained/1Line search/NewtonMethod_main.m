clear all, clc

% y = x^2 and its derivative
y1 = @(x) x.^2;
dy1 = @(x) 2.*x;

% y = cos(x) and its derivative
y2 = @(x) cos(x);
dy2 = @(x) -sin(x);

% Set the interval for search
x = 0:0.01:1.2;

% Plot both functions to estimate the location of the intersection 
figure;
hold on;
plot(x,y1(x),'LineWidth',1.5);
plot(x,y2(x),'LineWidth',1.5);
hold off;
grid on;
xlabel('$x$','Interpreter','latex','FontSize',18);
ylabel('$y$','Interpreter','latex','FontSize',18);
legend('$y=x^{2}$','$y=\sin{(x)}$','Interpreter','latex','FontSize',14,...
    'Location','northwest');

% Find the intersection Using Newton's method
x_int = NewtonMethod(@(x) y2(x)-y1(x),@(x) dy2(x)-dy1(x),0.8)

% plot the result
figure;
hold on;
plot(x,y1(x),'LineWidth',1.5);
plot(x,y2(x),'LineWidth',1.5);
plot(x_int,y1(x_int),'ko','MarkerSize',9,'LineWidth',1.5);
hold off;
grid on;
xlabel('$x$','Interpreter','latex','FontSize',18);
ylabel('$y$','Interpreter','latex','FontSize',18);
legend('$y=x^{2}$','$y=\sin{(x)}$','intersection','Interpreter','latex',...
    'FontSize',14,'Location','northwest');