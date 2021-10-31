function gradImg = getGradientMap(img, flagMark, smoothPara, enhPara)
img=SplitBregmanROF(img, smoothPara, 0.005);

% Y direction gradient using central difference.
[gradImgX, gradImgY] = grad(img);

if flagMark == 0
    gradImgY = -gradImgY;
end

gradImgY = gradImgY.*double(gradImgY>0);

% normalise to [0,1]
gradImgY = (gradImgY-min(gradImgY(:)))/(max(gradImgY(:))-min(gradImgY(:)));

gradImgY = 1 - exp(-enhPara*gradImgY.^2);

% gradImgY = (gradImgY-min(gradImgY(:)))/(max(gradImgY(:))-min(gradImgY(:)));

% figure; imshow((gradImgY),[]); colormap('gray'); axis off; axis equal; 
% figure; imshow((gradImgY),[]); colormap('gray'); axis off; axis equal; 



% gradImgY = (gradImgY-min(gradImgY(:)))/(max(gradImgY(:))-min(gradImgY(:)));
% figure; imshow((img),[]); colormap('gray'); axis off; axis equal; 

gradImgX = abs(gradImgX);
gradImgX = 1-(gradImgX-min(gradImgX(:)))/(max(gradImgX(:))-min(gradImgX(:)));

gradImg = 1-(1-gradImgY).*gradImgX;

gradImg =(gradImg-min(gradImg(:)))/(max(gradImg(:))-min(gradImg(:)));
% figure; imshow((gradImg),[]); colormap('gray'); axis off; axis equal; 

% f = figure;
% ax3 = axes(f);
% imagesc(ax3,gradImg); colormap('gray'); axis off; axis equal;
% title(ax3, 'gradImg');