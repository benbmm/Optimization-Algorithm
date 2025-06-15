% Generate the data contaminated by noise
rng default % random number generaator set to default setting
xdata = linspace(0,3);
ydata = exp(-1.3*xdata) + 0.05*randn(size(xdata));

% Set the lower and upper bounds for the parameters
lb = [0,-2];
ub = [3/4,-1];

% Create the model function
fun = @(x,xdata)x(1)*exp(x(2)*xdata);

% Fit the model
x0 = [1/2,-2]; % Create an initial guess.
x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)

% Plot the fitted model vs the data points
plot(xdata,ydata,'ko',xdata,fun(x,xdata),'b-')
legend('Data','Fitted exponential')
title('Data and Fitted Curve')
