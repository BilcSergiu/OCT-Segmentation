function [layer, Y] = compute7thLayerB(img, params)

close all;

disp('================= Compute 7th layer! ==================');

if nargin < 2
    disp(params);
    params = struct();
    params.C = 0.01;
    params.smoothParam = 0.02;
    params.gradientSmoothParam = 0.02;
    params.gradientEnhaParam = 1;
    params.p9thAboveBandWidth = 10;
    params.p9thSmoothParam = 0.0002;
    params.p8thAboveBandWidth = 4;
    params.p8thBelowBandWidth = 4;
    params.p6thAboveBandWidth = 15;
    params.p6thBelowBandWidth = 5;
    params.p1stBelowBandWidth = 5;
    params.p4thAboveBandWidth2 = 7;
    params.p4thBelowBandWidth2 = 1;
    params.p3thAboveBandWidth = 14;
    params.p3thBelowBandWidth = 4;
    params.p2thAboveBandWidth = 4;
    params.p2thBelowBandWidth = 8;
end


disp('================= Compute 7th layer end! ==================');

imgO = img;
img0 = double(imgO);
szimg = size(img0);
imgPad = padarray(img0, [0, 1],  'symmetric');

% f = figure;
% ax3 = axes(f);
% imagesc(ax3,img0); colormap('gray'); axis off; axis equal;
% title(ax3, 'img');

darkTobright = 1;
brightTodark = 0;

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

% fatten image and 7th boundary to make the next segmentation easier
[fattenedImgPad, refpt] = fattenImg(imgPad, B7);
fattenedImgPad = imgPad;

fattenedB7 = ones(size(B7)) .* refpt;

% plot(ax, Y,fattenedB7,'g-.','linewidth',2);
% plot(ax, Y,B7,'g-.','linewidth',2);

fattenedB7 = B7;

fattenedImgPad = fattenedImgPad(:, 2:end - 1);
[smoothedB7, Y] = smoothSegLine(B7, Y, 0.01);
layer = B7;