clc;clear all;

% plot the nonsmooth function
figure
x = linspace(-5,5,51);
[xx,yy] = meshgrid(x);
zz = zeros(size(xx));
for ii = 1:length(x)
    for jj = 1:length(x)
        zz(ii,jj) = sqrt(norm([xx(ii,jj),yy(ii,jj);0,0]));
    end
end
surf(xx,yy,zz)
xlabel('x(1)')
ylabel('x(2)')
title('Norm([x(1),x(2);0,0])^{1/2}')

% Initial setup
fun = @(x)norm([x(1:6);x(7:12)])^(1/2);
x0 = [1:6;7:12];
rng default
x0 = x0 + rand(size(x0))

% Minimize Using patternsearch
[xps,fvalps,eflagps,outputps] = patternsearch(fun,x0);
xps,fvalps,eflagps,outputps.funccount

% Minimize Using fminsearch
[xfms,fvalfms,eflagfms,outputfms] = fminsearch(fun,x0);
xfms,fvalfms,eflagfms,outputfms.funcCount

% Use particleswarm
[xpsw,fvalpsw,eflagpsw,outputpsw] = particleswarm(fun,12);
xpsw,fvalpsw,eflagpsw,outputpsw.funccount

% Use ga
[xga,fvalga,eflagga,outputga] = ga(fun,12);
xga,fvalga,eflagga,outputga.funccount

% Use fminunc from Optimization Toolbox
[xfmu,fvalfmu,eflagfmu,outputfmu] = fminunc(fun,x0);
xfmu,fvalfmu,eflagfmu,outputfmu.funcCount

% Use fmincon from Optimization Toolbox
[xfmc,fvalfmc,eflagfmc,outputfmc] = fmincon(fun,x0);
xfmc,fvalfmc,eflagfmc,outputfmc.funcCount

% Summary of Results
Solver = {'patternsearch';'fminsearch';'particleswarm';'ga';'fminunc';'fmincon'};
SolutionQuality = {'Good';'Poor';'Good';'Poor';'Poor';'Good'};
FVal = [fvalps,fvalfms,fvalpsw,fvalga,fvalfmu,fvalfmc]';
NumEval = [outputps.funccount,outputfms.funcCount,outputpsw.funccount, ...
    outputga.funccount,outputfmu.funcCount,outputfmc.funcCount]';
results = table(Solver,SolutionQuality,FVal,NumEval)
% Another view of the results.
figure
hold on
for ii = 1:length(FVal)
    clr = rand(1,3);
    plot(NumEval(ii),FVal(ii),'o','MarkerSize',10,'MarkerEdgeColor',clr, ...
        'MarkerFaceColor',clr)
    text(NumEval(ii),FVal(ii)+0.2,Solver{ii},'Color',clr);
end
ylabel('FVal')
xlabel('NumEval')
title('Reported Minimum and Evaluations By Solver')
hold off
