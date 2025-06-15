function y = parameterized_fitness(x,p1,p2)
%PARAMETERIZED_FITNESS fitness function for GA
%   Copyright 2004 The MathWorks, Inc.        
 
y = p1 * (x(1)^2 - x(2)) ^2 + (p2 - x(1))^2;