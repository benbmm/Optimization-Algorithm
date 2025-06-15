clear all, clc
format short

% Define the Objective function
f=@(x)(x<1/2).*((1-x)./2)+(x>=0.5).*(x.^2);

% Input the parameters
L=input('Enter lower limit='); % -1
R=input('Enter upper limit='); % 1
n=input('Enter no.0f iteration='); % 6
maxerr=input('Enter Max.Error='); % 0.03

% Plot the function
t = linspace(L,R,100);
plot(t,f(t),'k','LineWidth',2);

% Golden section search
ratio = 0.618;
x2 = L+ratio.*(R-L); % Compute x2
x1 = L+R-x2; % Compute x2
err = R-L; % Initial Error
iter =1; % Set iteration initially
while err>maxerr
    err = R-L; % compute Error
    fx1 = f(x1); % Compute f(x1)
    fx2 = f(x2); % Compute f(x2)
    % For printing purpose
    rsl(iter,:)=[L R x1 x2 fx1 fx2];
    if fx1>fx2 % Look for "Minimum"
        L = x1; % Update L
        x1 = x2; % Update x1
        x2 = L+R-x1; % Compute x2
    elseif fx1<fx2
        R = x2; % Update R
        x2 = x1; % Update x2
        x1 = L+R-x2; % Compute x1
    elseif fx1==fx2
        if min(abs(x1),abs(L))==abs(L)
            R = x2; % Update R
        else
            L = x1; % Update L
        end
    end % End "if-else" loop
    if iter==n % check Max iteration
        break;
    else
        iter=iter+1; % Update iteration
    end
end % End of while ioop

% Display the condition met
if iter==n
    fprintf('Max. iteration %d reached',n);
else
    fprintf('Max. Error limit %d reached',maxerr);
end

% Printing the Final Results
Variables={'L','R','x1','x2','fx1','fx2'};
Resl= array2table(rsl); % Convert Array to Table
Resl.Properties.VariableNames(1:size(Resl,2)) = Variables

% Compute & Print Optimal Result
xopt=(L+R)/2; % Optimal "x"(mid-point of L & R)
fopt=f(xopt); % Optimal value of f(x)
fprintf('Optimal value of x = %f \n',xopt);
fprintf('Optimal value of f(x) = %f \n',fopt);