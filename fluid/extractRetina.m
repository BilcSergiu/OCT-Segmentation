function [output] = extractRetina(image, params)

% 
% if nargin < 2
%     params = struct();
%     params.C = 0.001;
%     params.smoothParam = 0.02;
%     params.gradientSmoothParam = 0.02;
%     params.gradientEnhaParam = 0.0001;
%     params.p9thAboveBandWidth = 10;
%     params.p9thSmoothParam = 0.0002;
%     params.p8thAboveBandWidth = 0;
%     params.p8thBelowBandWidth = 8;
%     params.p6thAboveBandWidth = 15;
%     params.p6thBelowBandWidth = 2;
%     params.p1stBelowBandWidth = 25;
%     params.p4thAboveBandWidth2 = 20;
%     params.p4thBelowBandWidth2 = 1;
%     params.p3thAboveBandWidth = 4;
%     params.p3thBelowBandWidth = 14;
%     params.p2thAboveBandWidth = 4;
%     params.p2thBelowBandWidth = 8;
% end


% imgO = imread([PathName imgName imgExt]); %pick an image
imgO = image;
imgO = imgO(:, :, 1);
img0 = double(imgO);
szimg = size(img0);
imgPad = padarray(img0, [0, 1],  'symmetric');

ROI = struct();

darkTobright = 1;
brightTodark = 0;

isDrusen = false;

tic

%% get 7th boundary (IS-OS border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% presegment image to enhance IS-OS layer and guarantee this layer segmented
%     bwImg = Seg2(img0, 100, 0.01, 0.02);
bwImg = Seg2(img0, 100, params.C, params.smoothParam);

img = double(bwImg .* img0);

% get the vertical gradient
%     gradImg = getGradientMap0(img, darkTobright, 0.02, 2);

gradImg = getGradientMap0(img, darkTobright, params.gradientSmoothParam, params.gradientEnhaParam);


[B7, Y] = getSegBoundary(gradImg, imgPad, szimg, 1);
% toc
% fatten image and 7th boundary to make the next segmentation easier
[fattenedImgPad, refpt] = fattenImg(imgPad, B7);

fattenedB7 = ones(size(B7)) .* refpt;

if isDrusen == false
    fattenedImgPad = imgPad;
    fattenedB7 = B7;
end

fattenedImgPad = fattenedImgPad(:, 2:end - 1);
%% get the 9th boundary (RPE-CH border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the region of interst, refering to IS-OS layer

BW = removeRegionAboveSegLine(fattenedB7, Y, imgPad, params.p9thAboveBandWidth);

gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.02, 30);

%     0.00002
[B9, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, params.p9thSmoothParam);


ROI.reg9 = BW;

[B9, Y] = smoothSegLine(B9, Y, 0.01);

% plot( ax,Y, B9, 'r-.', 'linewidth', 2);
% %% get the 8th boundary (OS-RPE border)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % get the region of interst, refering to IS-OS layer
% % BW0 = removeRegionAboveSegLine(B7, Y, imgPad, params.p8thAboveBandWidth); %6th
% BW0 = removeRegionAboveSegLine(fattenedB7, Y, imgPad, params.p8thAboveBandWidth); %6th
% BW1 = removeRegionBelowSegLine(B9, Y, imgPad, params.p8thBelowBandWidth); %bottom
% BW = BW0 .* BW1;
% 
% ROI.reg8 = BW;
% 
% gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.08, 0.1);
% 
% [B8, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);
% 
% % plot(ax, Y, B8, 'b-.', 'linewidth', 2);
% 
% %% get the 6th boundary (ONL_IS border)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % get the region of interest i.e. narrow band above the IS_OS layer
% BW = zeros(szimg);
% % BW(refpt - params.p6thAboveBandWidth:refpt - params.p6thBelowBandWidth, 1:end) = 1; % adjust parameters to get right ROI
% BW0 = removeRegionBelowSegLine(fattenedB7, Y, imgPad, params.p6thAboveBandWidth);
% BW1 = removeRegionBelowSegLine(fattenedB7, Y, imgPad, params.p6thBelowBandWidth);
% 
% BW = BW1 - BW0;
% 
% ROI.reg6 = BW;
% 
% gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1);
% 
% [B6, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);

%% get the 1st boundary (IML border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BW = removeRegionBelowSegLine(fattenedB7, Y, imgPad, params.p1stBelowBandWidth + params.p6thBelowBandWidth);

gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.05, 50);

% alphamask(BW, [0 1 1], 0.4);

ROI.reg1 = BW;



[B1, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

% smooth IML layer to create better ROI for INL_OPL
% [B1, Y] = smoothSegLine(B1, Y, 0.0000001);

%     plot(Y, B1, 'r', 'linewidth', 2);


toc

if isDrusen == true
    temp = refpt - B7;
    
    B9 = B9 - temp;
   
    B1 = B1 - temp;
end

% f = figure;
% ax15 = axes(f);
% imagesc(ax15,img0); colormap('gray'); axis off; axis equal; hold on;
% plot(ax15,B9,'-b', 'LineWidth',2);
% plot(ax15,B7,'-g', 'LineWidth',2);
% plot(ax15,B1,'-r', 'LineWidth',2);
% title(ax15, 'ROI 1st');
% hold off;

output = struct();
output.B1 = B1;
output.originalImage = img0;
output.B9 = B9;

end
