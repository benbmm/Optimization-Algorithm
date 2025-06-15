clear all, close all

% print the progress
options(1)=0; 

% Random search with alpha=0.5
options(18)=0.5;
figure
random_search('f_p',[0;-2],options)

% Random search with alpha=1.5
options(18)=1.5;
figure
random_search('f_p',[0;-2],options)

% Simulated annealing with alpha=0.5
options(18)=0.5;
figure
simulated_annealing('f_p',[0;-2],options);

