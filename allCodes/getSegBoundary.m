function [X, Y] = getSegBoundary(gradImg, imgPad, szimg, lineSoomthPara)

% get adjacency matrix where edge weights of graph calucated from vertical gradient
adjMatrixW = getAdjacencyMatrix(gradImg);

% run Dijkstra on adjacency matrix and get the shortest path
[X, Y] = getGraphShortestPath(adjMatrixW, imgPad, szimg);

% remove repeated points on segmented line to guarantee correction of fattening image
[X, Y] = removeRepeatedPointsOnSegLine(X, Y);

% reparametrise the segmented line making it smoother
[X, Y] = smoothSegLine(X, Y, lineSoomthPara);