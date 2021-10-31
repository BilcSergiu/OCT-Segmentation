function adjMatrixW = getAdjacencyMatrix(gradImg)

gradImg=padarray(gradImg, [0,1], 1);

% update size of image
szImg = size(gradImg);

%% generate adjacency matrix, see equation 1 in the refered article.

%minimum weight
minWeight = 1e-5;

neighborIterX = [1 1  1 0  0 -1 -1 -1];
neighborIterY = [1 0 -1 1 -1  1  0 -1];

% neighborIterX = [ 1  0  0  -1];
% neighborIterY = [ 0  1 -1   0];

% get location A (in the image as indices) for each weight.
adjMAsub = 1:szImg(1)*szImg(2);

% convert adjMA to subscripts
[adjMAx,adjMAy] = ind2sub(szImg,adjMAsub);

adjMAsub = adjMAsub';
szadjMAsub = size(adjMAsub);

% prepare to obtain the 8-connected neighbors of adjMAsub
% repmat to [1,8]
neighborIterX = repmat(neighborIterX, [szadjMAsub(1),1]);
neighborIterY = repmat(neighborIterY, [szadjMAsub(1),1]);

% repmat to [8,1]
adjMAsub = repmat(adjMAsub,[1 8]);
adjMAx = repmat(adjMAx, [1 8]);
adjMAy = repmat(adjMAy, [1 8]);

% get 8-connected neighbors of adjMAsub
% adjMBx,adjMBy and adjMBsub
adjMBx = adjMAx+neighborIterX(:)';
adjMBy = adjMAy+neighborIterY(:)';

% make sure all locations are within the image.
keepInd = adjMBx > 0 & adjMBx <= szImg(1) & adjMBy > 0 & adjMBy <= szImg(2);

% adjMAx = adjMAx(keepInd);
% adjMAy = adjMAy(keepInd);
adjMAsub = adjMAsub(keepInd);
adjMBx = adjMBx(keepInd);
adjMBy = adjMBy(keepInd);

adjMBsub = sub2ind(szImg,adjMBx(:),adjMBy(:))';

% calculate weight
adjMW =   2 - gradImg(adjMAsub(:)) - gradImg(adjMBsub(:)) + minWeight;

% pad minWeight on the side
imgTmp = nan(size(gradImg));
imgTmp(:,1) = 1;
imgTmp(:,end) = 1;
imageSideInd = ismember(adjMBsub,find(imgTmp(:)==1));
adjMW(imageSideInd) = minWeight;

% build sparse matrices
adjMatrixW = sparse(adjMAsub(:),adjMBsub(:),adjMW(:),numel(gradImg(:)),numel(gradImg(:)));
