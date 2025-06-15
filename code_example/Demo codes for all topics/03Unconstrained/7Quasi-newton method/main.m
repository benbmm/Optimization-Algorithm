clc;clear all;

[X,F,Iters] = bfgs(2, [0 0], 1e-7, 1e-7, [1e-5 1e-5], 100, 'fx1')