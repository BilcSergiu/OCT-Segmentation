function [indexes] = extractSegmentedIndexes(path)
%EXTRACTSEGMENTEDINDEXES Summary of this function goes here
%   Detailed explanation goes here

data = load(path);
indexes = [];
% disp(data);
for k = 1 : size(data.manualFluid2,3)
    X = data.manualFluid2(:,:,k);
%     A=(A(~isnan(A)));
   X(~isnan(X));
   result = sum(~isnan(X(:)));
   result1  = sum(X > 0);
   result1 = sum(result1);
   
%    disp(result1);
   if result > 0 & result1 > 0
        indexes = [indexes, k]
   end
end

% disp(indexes)
