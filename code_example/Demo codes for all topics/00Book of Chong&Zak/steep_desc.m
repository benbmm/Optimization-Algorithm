function [x,N]=steep_desc(grad,xnew,options);
%Matlab routine for steepest descent algorithm 
%using secant method for line search.
%-- by E. K. P. Chong,  Feb. 11, 1994
%
%    STEEP_DESC('grad',x0);
%    STEEP_DESC('grad',x0,OPTIONS);
%
%    x = STEEP_DESC('grad',x0);
%    x = STEEP_DESC('grad',x0,OPTIONS);
%
%    [x,N] = STEEP_DESC('grad',x0);
%    [x,N] = STEEP_DESC('grad',x0,OPTIONS);
%
%The first variant finds the minimizer of a function whose gradient
%is described in grad (usually an M-file: grad.m), using a gradient
%descent algorithm with initial point x0. The line search used in the
%secant method.
%The second variant allows a vector of optional parameters to
%defined. OPTIONS(1) controls how much display output is given; set 
%to 1 for a tabular display of results, (default is no display: 0). 
%OPTIONS(2) is a measure of the precision required for the final point.
%OPTIONS(3) is a measure of the precision required of the gradient.
%OPTIONS(14) is the maximum number of iterations.
%For more information type HELP FOPTIONS. 
%
%The next two variants returns the value of the final point.
%The last two variants returns a vector of the final point and the
%number of iterations. 

if nargin ~= 3
  options = [];
  if nargin ~= 2
    disp('Wrong number of arguments.');
    return;
  end
end

if length(options) >= 14 
  if options(14)==0
    options(14)=1000*length(xnew);
  end
else
  options(14)=1000*length(xnew);
end

if length(options) < 18
  options(18)=0.002; %optional step size
end

%clc;
format compact;
format short e;

options = foptions(options);
print = options(1);
epsilon_x = options(2);
epsilon_g = options(3);
max_iter=options(14);

ros_cnt;
if length(xnew) == 2
  plot(xnew(1),xnew(2),'o')
  text(xnew(1),xnew(2),'Start Point')
end

for k = 1:max_iter,

  xcurr=xnew;
  g_curr=feval(grad,xcurr);
  if norm(g_curr) <= epsilon_g
    disp('Terminating: Norm of gradient less than');
    disp(epsilon_g);
    k=k-1;
      break;
    end %if

  if options(7) == 0,
    alpha=secant(grad,xcurr,-g_curr);
  else
    alpha=options(18);
  end %if

  xnew = xcurr-alpha*g_curr;

  if print,
    disp('Iteration number k =')
    disp(k);  %print iteration index k
    disp('alpha =');
    disp(alpha);  %print alpha
    disp('Gradient = ');
    disp(g_curr'); %print gradient
    disp('New point =');
    disp(xnew'); %print new point
  end %if

  if norm(xnew-xcurr) <= epsilon_x*norm(xcurr)
    disp('Terminating: Norm of difference between iterates less than');
    disp(epsilon_x);
    break;
  end %if

  pltpts(xnew,xcurr);

  if k == max_iter
    disp('Terminating with maximum number of iterations');
  end %if
end %for

if nargout >= 1
  x=xnew;
  if nargout == 2
    N=k;
  end 
else
  disp('Final point ='); 
  disp(xnew'); 
  disp('Number of iterations ='); 
  disp(k); 
end %if