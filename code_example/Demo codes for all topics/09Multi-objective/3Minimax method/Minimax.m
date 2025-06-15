clear all, clc

x0 = [0.1; 0.1];       % Make a starting guess at solution
[x,fval] = fminimax(@myfun,x0)