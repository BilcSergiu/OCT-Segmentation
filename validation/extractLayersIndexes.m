function [indexes] = extractLayersIndexes(path)
%EXTRACTSEGMENTEDINDEXES Summary of this function goes here
%   Detailed explanation goes here

data = load(path);
indexes = [];

for k = 1 : size(data.manualLayers1,3)
    X = data.manualLayers1(:,:,k);
%     A=(A(~isnan(A)));
    result = sum(~isnan(X(:)));
   if result > 0
        indexes = [indexes, k]
   end
end

% disp(indexes)
