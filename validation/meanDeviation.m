function [meanDev,outputArg2] = meanDeviation(X,dev)
%MEANDEVIATION Summary of this function goes here
%   Detailed explanation goes here
summ = 0;
k = length(X);
% sum(abs(xi-mean(x)))/(n-1)
for i = 1: k 
    summ = summ + abs(x(i)-dev);
end
meanDev = (summ)/k;

end

