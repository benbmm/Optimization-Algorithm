function FirstDerivX = FirstDerivatives(X, N, myFx)

for iVar=1:N
  xt = X(iVar);
  h = 0.01 * (1 + abs(xt));
  X(iVar) = xt + h;
  fp = feval(myFx, X, N);
  X(iVar) = xt - h;
  fm = feval(myFx, X, N);
  X(iVar) = xt;
  FirstDerivX(iVar) = (fp - fm) / 2 / h;
end

end