function [stdev] = standardDeviation(X,dev)
%STANDARDDEVIATION Summary of this function goes here
%   Detailed explanation goes here
summ = 0;
k = length(X);
% sqrt(sum((xi-mean(x))^2/(n-1)))
for i = 1: k 
    summ = summ + ((X(i)-dev).^2);
end
stdev = sqrt((summ)/k);

end

