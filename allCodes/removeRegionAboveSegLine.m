function BW = removeRegionAboveSegLine(pathX, pathY, imgPad, bandWidth) 

% reparametrise the segmented line making it smoother
fitresult = createFit(pathY,pathX);
pathY = pathY(1):5:pathY(end);
pathX = fitresult(pathY);
pathX = pathX';

% get normals on the smooth segmented line
[N1,N2] = GetContourNormals2D([pathX',pathY']);

% get line below the segmented line
xsDown = pathX'-bandWidth*N1;
ysDown = pathY'-bandWidth*N2;
xsDown = xsDown';
ysDown = ysDown';

fitresult=createFit(ysDown,xsDown);
ysDown = 1:1:size(imgPad,2);
xsDown = fitresult(ysDown);
xsDown = xsDown';

% figure; imagesc(imgPad); colormap('gray'); axis off; axis equal; hold on;
% plot(ysDown,xsDown,'g','linewidth',2);

% get line above the segmented line
% xsUp = pathX' + bandWidth*N1;
% ysUp = pathY' + bandWidth*N2;
% xsUp = xsUp';
% ysUp = ysUp';
% 
% fitresult = createFit(ysUp,xsUp);
% ysUp = 1:1:size(imgPad,2);
% xsUp = fitresult(ysUp);
% xsUp = xsUp';

% figure; imagesc(imgPad); colormap('gray'); axis off; axis equal; hold on;
% plot(pathY,pathX,'g','linewidth',2);
% plot(ysUp,xsUp,'g','linewidth',2);

% get narrow band region
top = zeros(1, size(imgPad,2));

BW = poly2mask([ysDown,fliplr(ysDown)], [top,fliplr(xsDown)], size(imgPad,1), size(imgPad,2));

BW = 1-double(BW(:,2:end-1));