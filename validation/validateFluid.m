close all;

params = struct();
% 0.001
params.C = 0.001;
params.smoothParam = 0.02;
params.gradientSmoothParam = 0.02;
params.gradientEnhaParam = 0.01;
params.p9thAboveBandWidth = 10;
params.p9thSmoothParam = 0.0002;
params.p4thAboveBandWidth = 25;
params.p4thBelowBandWidth = 10;
params.p8thAboveBandWidth = 0;
params.p8thBelowBandWidth = 4;
params.p6thAboveBandWidth = 22;
params.p6thBelowBandWidth = 2;
params.p1stBelowBandWidth = 40;
params.p5thAboveBandWidth = 0;
params.p5thBelowBandWidth = 5;
params.p4thAboveBandWidth2 = 10;
params.p4thBelowBandWidth2 = 1;
params.p3thAboveBandWidth = 20;
params.p3thBelowBandWidth = 2;
params.p2thAboveBandWidth = 2;
params.p2thBelowBandWidth = 4;

url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_08.mat';
data = load(url);
indexes = extractFluidIndexes(url);

% indexes = indexes(4:7);
Dices = [];
selIndexes = [];
ImgIndexes = [];
TPS = [];
FPS = [];
FNS = [];
% disp(indexes);
disp(size(indexes));
for i = 1 : size(indexes,2)
    index = indexes(i);
    %     disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    
    img(img == 255) = 0;
    
    
    [fluid, labeled] = fluidSegmentation2(img, params);
    %     [B7,Y] = compute7thLayerB(img, params);
    %         [output, ~] = segmentMultipleOCTB(img, params, false);
    %
    %
    f = figure;
    ax3 = axes(f);
    imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    title(ax3, index);
    alphamask(fluid,[0 0 1], 0.5);
    hold off;
    
    manualBw = data.manualFluid2(:,:,index);
    
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,manualBw); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'bnary');
    %     hold off;
    
    %     disp(manualBw);
    
    
    manualBw(manualBw > 0) = 1;
    fluid(fluid > 0) = 1;
    
    %
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'original');
    %     hold off;
    %
    %
    f = figure;
    ax3 = axes(f);
    imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    title(ax3, 'manual');
    alphamask(manualBw,[1 0 0], 0.5);
    hold off;
    
    
    falseNegative = zeros(size(manualBw));
    falsePositive = zeros(size(fluid));
    truePositive = zeros(size(fluid));
    
    falseNegative(manualBw==1 & fluid==0) = 1;
    falsePositive(manualBw==0 & fluid==1) = 1;
    truePositive(manualBw==1 & fluid==1) = 1;
    
    diff = or(falseNegative,falsePositive);
    
%           f = figure;
%         ax3 = axes(f);
%         imagesc(ax3,falseNegative); colormap('gray'); axis off; axis equal; hold on;
%         title(ax3, 'falseNegative');
%         hold off;
%     
   
    numberOfWhitePixels = sum(diff(:));
    
    TP = sum(truePositive(:));
    FP = sum(falsePositive(:));
    FN = sum(falseNegative(:));
    Dice = (2*TP)/(2*TP + FP + FN);
    
    if(Dice > 0.3)
        
         f = figure;
    ax3 = axes(f);
    imagesc(ax3,diff); colormap('gray'); axis off; axis equal; hold on;
    title(ax3, 'diff');
    hold off;
    
    
        TPS = [TPS, TP];
        FPS = [FPS, FP];
        FNS = [FNS, FN];
        selIndexes = [selIndexes, i];
        ImgIndexes = [ImgIndexes, index];
        Dices = [Dices, Dice];
    end
    %     disp(Dice);
    %     X1 = find(~isnan(layers(1,:,:)), 1);
    %     tempLayer = fliplr(layers(1,:,:));
    %     X2 = find(~isnan(tempLayer),1);
    %
    %
end

disp(selIndexes);
disp(ImgIndexes);
disp(Dices);



url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_07.mat';
data = load(url);
indexes = extractFluidIndexes(url);

% indexes = indexes(4:7);
% Dices = [];
% selIndexes = [];
% ImgIndexes = [];
% disp(indexes);
disp(size(indexes));
for i = 1 : size(indexes,2)
    index = indexes(i);
    %     disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    
    img(img == 255) = 0;
    
    
    [fluid, labeled] = fluidSegmentation2(img, params);
    %     [B7,Y] = compute7thLayerB(img, params);
    %         [output, ~] = segmentMultipleOCTB(img, params, false);
    %
    %
    
    manualBw = data.manualFluid2(:,:,index);
    
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,manualBw); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'bnary');
    %     hold off;
    
    %     disp(manualBw);
    
    
    manualBw(manualBw > 0) = 1;
    fluid(fluid > 0) = 1;
    
    %
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'original');
    %     hold off;
    %
    %
    
    
    
    falseNegative = zeros(size(manualBw));
    falsePositive = zeros(size(fluid));
    truePositive = zeros(size(fluid));
    
    falseNegative(manualBw==1 & fluid==0) = 1;
    falsePositive(manualBw==0 & fluid==1) = 1;
    truePositive(manualBw==1 & fluid==1) = 1;
    
    diff = or(falseNegative,falsePositive);
    
    %       f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,falseNegative); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'falseNegative');
    %     hold off;
    %
    
    
    numberOfWhitePixels = sum(diff(:));
    
    TP = sum(truePositive(:));
    FP = sum(falsePositive(:));
    FN = sum(falseNegative(:));
    Dice = (2*TP)/(2*TP + FP + FN);
    
    if(Dice > 0.3)
        TPS = [TPS, TP];
        FPS = [FPS, FP];
        FNS = [FNS, FN];
        selIndexes = [selIndexes, i];
        ImgIndexes = [ImgIndexes, index];
        Dices = [Dices, Dice];
    end
    %     disp(Dice);
    %     X1 = find(~isnan(layers(1,:,:)), 1);
    %     tempLayer = fliplr(layers(1,:,:));
    %     X2 = find(~isnan(tempLayer),1);
    %
    %
end
% 
disp('Subject 7');
disp(selIndexes);
disp(ImgIndexes);
disp(Dices);



url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_05.mat';
data = load(url);
indexes = extractFluidIndexes(url);

% indexes = indexes(4:7);
% Dices = [];
% selIndexes = [];
% ImgIndexes = [];
% disp(indexes);
disp(size(indexes));
for i = 1 : size(indexes,2)
    index = indexes(i);
    %     disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    
    img(img == 255) = 0;
    
    
    [fluid, labeled] = fluidSegmentation2(img, params);
    %     [B7,Y] = compute7thLayerB(img, params);
    %         [output, ~] = segmentMultipleOCTB(img, params, false);
    %
    %
    
    
    manualBw = data.manualFluid2(:,:,index);
    
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,manualBw); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'bnary');
    %     hold off;
    
    %     disp(manualBw);
    
    
    manualBw(manualBw > 0) = 1;
    fluid(fluid > 0) = 1;
    
    %
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'original');
    %     hold off;
    %
    %
    
    
    
    falseNegative = zeros(size(manualBw));
    falsePositive = zeros(size(fluid));
    truePositive = zeros(size(fluid));
    
    falseNegative(manualBw==1 & fluid==0) = 1;
    falsePositive(manualBw==0 & fluid==1) = 1;
    truePositive(manualBw==1 & fluid==1) = 1;
    
    diff = or(falseNegative,falsePositive);
    
    %       f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,falseNegative); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'falseNegative');
    %     hold off;
    %
    
    numberOfWhitePixels = sum(diff(:));
    
    TP = sum(truePositive(:));
    FP = sum(falsePositive(:));
    FN = sum(falseNegative(:));
    Dice = (2*TP)/(2*TP + FP + FN);
    
    if(Dice > 0.3)
        TPS = [TPS, TP];
        FPS = [FPS, FP];
        FNS = [FNS, FN];
        selIndexes = [selIndexes, i];
        ImgIndexes = [ImgIndexes, index];
        Dices = [Dices, Dice];
    end
    %     disp(Dice);
    %     X1 = find(~isnan(layers(1,:,:)), 1);
    %     tempLayer = fliplr(layers(1,:,:));
    %     X2 = find(~isnan(tempLayer),1);
    %
    %
end

disp('Subject 6');
disp(selIndexes);
disp(ImgIndexes);
disp(Dices);



url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_06.mat';
data = load(url);
indexes = extractFluidIndexes(url);

% indexes = indexes(4:7);
% Dices = [];
% selIndexes = [];
% ImgIndexes = [];
% disp(indexes);
disp(size(indexes));
for i = 1 : size(indexes,2)
    index = indexes(i);
    %     disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    
    img(img == 255) = 0;
    
    
    [fluid, labeled] = fluidSegmentation2(img, params);
    %     [B7,Y] = compute7thLayerB(img, params);
    %         [output, ~] = segmentMultipleOCTB(img, params, false);
    %
    %
    
    
    manualBw = data.manualFluid2(:,:,index);
    
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,manualBw); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'bnary');
    %     hold off;
    
    %     disp(manualBw);
    
    
    manualBw(manualBw > 0) = 1;
    fluid(fluid > 0) = 1;
    
    %
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'original');
    %     hold off;
    %
    %
    
    
    
    falseNegative = zeros(size(manualBw));
    falsePositive = zeros(size(fluid));
    truePositive = zeros(size(fluid));
    
    falseNegative(manualBw==1 & fluid==0) = 1;
    falsePositive(manualBw==0 & fluid==1) = 1;
    truePositive(manualBw==1 & fluid==1) = 1;
    
    diff = or(falseNegative,falsePositive);
    
    %       f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,falseNegative); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'falseNegative');
    %     hold off;
    %
    
    numberOfWhitePixels = sum(diff(:));
    
    TP = sum(truePositive(:));
    FP = sum(falsePositive(:));
    FN = sum(falseNegative(:));
    Dice = (2*TP)/(2*TP + FP + FN);
    
    if(Dice > 0.3)
        TPS = [TPS, TP];
        FPS = [FPS, FP];
        FNS = [FNS, FN];
        selIndexes = [selIndexes, i];
        ImgIndexes = [ImgIndexes, index];
        Dices = [Dices, Dice];
    end
    %     disp(Dice);
    %     X1 = find(~isnan(layers(1,:,:)), 1);
    %     tempLayer = fliplr(layers(1,:,:));
    %     X2 = find(~isnan(tempLayer),1);
    %
    %
end

disp('Subject 5');
disp(selIndexes);
disp(ImgIndexes);
disp(Dices);



url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_04.mat';
data = load(url);
indexes = extractFluidIndexes(url);

% indexes = indexes(4:7);
% Dices = [];
% selIndexes = [];
% ImgIndexes = [];
% disp(indexes);
disp(size(indexes));
for i = 1 : size(indexes,2)
    index = indexes(i);
    %     disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    
    img(img == 255) = 0;
    
    
    [fluid, labeled] = fluidSegmentation2(img, params);
    %     [B7,Y] = compute7thLayerB(img, params);
    %         [output, ~] = segmentMultipleOCTB(img, params, false);
    %
    %
    
    
    manualBw = data.manualFluid2(:,:,index);
    
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,manualBw); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'bnary');
    %     hold off;
    
    %     disp(manualBw);
    
    
    manualBw(manualBw > 0) = 1;
    fluid(fluid > 0) = 1;
    
    %
    %     f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'original');
    %     hold off;
    %
    %
    
    
    
    falseNegative = zeros(size(manualBw));
    falsePositive = zeros(size(fluid));
    truePositive = zeros(size(fluid));
    
    falseNegative(manualBw==1 & fluid==0) = 1;
    falsePositive(manualBw==0 & fluid==1) = 1;
    truePositive(manualBw==1 & fluid==1) = 1;
    
    diff = or(falseNegative,falsePositive);
    
    %       f = figure;
    %     ax3 = axes(f);
    %     imagesc(ax3,falseNegative); colormap('gray'); axis off; axis equal; hold on;
    %     title(ax3, 'falseNegative');
    %     hold off;
    %
    
    numberOfWhitePixels = sum(diff(:));
    
    TP = sum(truePositive(:));
    FP = sum(falsePositive(:));
    FN = sum(falseNegative(:));
    Dice = (2*TP)/(2*TP + FP + FN);
    
    if(Dice > 0.3)
        TPS = [TPS, TP];
        FPS = [FPS, FP];
        FNS = [FNS, FN];
        selIndexes = [selIndexes, i];
        ImgIndexes = [ImgIndexes, index];
        Dices = [Dices, Dice];
    end
    %     disp(Dice);
    %     X1 = find(~isnan(layers(1,:,:)), 1);
    %     tempLayer = fliplr(layers(1,:,:));
    %     X2 = find(~isnan(tempLayer),1);
    
end

disp('Subject 4');
disp(selIndexes);
disp(ImgIndexes);

disp('================= TPS =====================');
disp(TPS);
disp('================= FPS =====================');
disp(FPS);
disp('================= FNS =====================');
disp(FNS);
disp('================= DICES =====================');
disp(Dices);
disp('================= MEAN DICE =====================');
disp(median(Dices));