clear all;clc;
format short  % Display output upto 4 digits

% Define objective function
f=@(x) (x<1/2).*((1-x)./2)+(x>=0.5).*(x.^2);
L = -1;       % Input Lower limit
R = 1;        % Input upper limit
n = 6;        % Nember of iterations

% Plot the function
t = linspace(L,R,100);
plot(t,f(t),'k','LineWidth',2);

% Compute Fibonacci Series
Fib = ones(1,n);   % Set all 1 initially
for i = 3:n+1
    Fib(i)=Fib(i-1)+Fib(i-2);
end
for k=1:n         % Fibonacci Ratio
    ratio =(Fib(n+1-k)./Fib(n+2-k));
    x2 = L+ratio.*(R-L); % Compute x2
    x1 = L+R-x2;         % Compute x1
    fx1 = f(x1);         % Compute f(x1)
    fx2 = f(x2);         % Compute f(x2)
    rsl(k,:)=[L R x1 x2 fx1 fx2]; %For printing purpose
    if fx1<fx2           % Look for "Minimum"
        R = x2;          % Update R
    elseif fx1>fx2
        L = x1;          % Update L
    elseif fx1==fx2
        if min(abs(x1),abs(L))==abs(L)
            R=x2;        % Update R
        else
            l=x1;        % Update L
        end
    end                  % End "if-else" loop
end                      % End "for k=1:n" loop

% Printing the Results
Variables={'L','R','x1','x2','fx1','fx2'};
Resl= array2table(rsl);  % Compute Array to Table
Resl.Properties.VariableNames(1:size(Resl,2)) = Variables;

% Compute & Print Optimal Result
xopt=(L+R)/2;            % Optimal "x"(mid-point of L & R)
fopt=f(xopt);            % Optimal value of f(x)
fprintf('Optimal value of x = %f \n',xopt);
fprintf('Optimal value of f(x) = %f \n',fopt);