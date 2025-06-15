function [X,F,Iters] = bfgs(N, X, gradToler, ~, DxToler, MaxIter, myFx)
% Function bfgs performs multivariate optimization using the
% Broyden-Fletcher-Goldfarb-Shanno method.

B = eye(N,N);

bGoOn = true;
Iters = 0;
% calculate initial gradient
grad1 =  FirstDerivatives(X, N, myFx);
grad1 = grad1';

while bGoOn

  Iters = Iters + 1;
  if Iters > MaxIter
    break;
  end

  S = -1 * B * grad1;
  S = S' / norm(S); % normalize vector S

  lambda = 1;
  lambda = linsearch(X, N, lambda, S, myFx);
  % calculate optimum X() with the given Lambda
  d = lambda * S;
  X = X + d;
  % get new gradient
  grad2 =  FirstDerivatives(X, N, myFx);

  grad2 = grad2';
  g = grad2 - grad1;
  grad1 = grad2;

  % test for convergence
  for i = 1:N
    if abs(d(i)) > DxToler(i)
      break
    end
  end

  if norm(grad1) < gradToler
    break
  end

  d = d';
  x1 = d * d';
  x2 = d' * g;
  x3 = d * g';
  x4 = g * d';
  x5 = g' * B * g;
  x6 = d * g' * B;
  x7 = B * g * d';
  B = B + (1 + x5 / x2) * x1 / x2 - x6 / x2 - x7 / x2;
  break
end

F = feval(myFx, X, N);

end
