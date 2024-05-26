function [pathX, pathY]=getGraphShortestPath(adjMatrixW,imgPad,szimg)

% get layer going from dark to light
% [~, path] = graphshortestpath( adjMatrixW, 1, numel(imgPad(:))); % find the path from node 1 to numel(img(:))
% [pathX, pathY] = ind2sub(szimg, path);

% Create the graph object
G = graph(adjMatrixW, 'lower');

% Find the shortest path from node 1 to node numel(imgPad(:))
[startNode, endNode] = deal(1, numel(imgPad(:)));
path = shortestpath(G, startNode, endNode);

% Convert linear indices to subscripts
[pathX, pathY] = ind2sub(szimg, path);

% if ~isempty(path)
    startInd = find(pathY==1);
    endInd   = find(pathY==size(imgPad,2));
    
    pathY = pathY(startInd(end):endInd(1));
    pathX = pathX(startInd(end):endInd(1));
% else
%     pathY = zeros([1,size(imgPad,2)-2]);
%     pathX = zeros([1,size(imgPad,2)-2]);
% end

