function gradImgY = getGradientMap0(img, flagMark, smoothPara, enhPara)

img=SplitBregmanROF(img, smoothPara, 0.005);

% Y direction gradient using central difference.
[~, gradImgY] = grad(img);

if flagMark == 0
    gradImgY = -gradImgY;
end

gradImgY = gradImgY.*double(gradImgY>0);

% normalise to [0,1]
gradImgY = (gradImgY-min(gradImgY(:)))/(max(gradImgY(:))-min(gradImgY(:)));

% normalise to [0,1]
gradImgY = 1 - exp(-enhPara*gradImgY.^2);