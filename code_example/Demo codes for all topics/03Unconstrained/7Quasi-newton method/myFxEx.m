function y = myFxEx(N, X, DeltaX, lambda, myFx)

  X = X + lambda * DeltaX;
  y = feval(myFx, X, N);

end