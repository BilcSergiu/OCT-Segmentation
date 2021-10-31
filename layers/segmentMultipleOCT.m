function [output, ROI] = segmentMultipleOCT(PathName, imgName, imgExt, subFolderName, segType, params, isDrusen)

close all;
% 
% disp('================ Segment multiple ==================');
% disp(params);
% % if nargin < 7
% %     params = struct();
% %     params.C = 0.01;
% %     params.smoothParam = 0.02;
% %     params.p9thAboveBandWidth = 10;
% %     params.p9thSmoothParam = 0.0002;
% %     params.p8thAboveBandWidth = 4;
% %     params.p8thBelowBandWidth = 4;
% %     params.p6thAboveBandWidth = 15;
% %     params.p6thBelowBandWidth = 5;
% %     params.p1stBelowBandWidth = 5;
% %     params.p4thAboveBandWidth2 = 7;
% %     params.p4thBelowBandWidth2 = 1;
% %     params.p3thAboveBandWidth = 14;
% %     params.p3thBelowBandWidth = 4;
% %     params.p2thAboveBandWidth = 4;
% %     params.p2thBelowBandWidth = 8;
% % end
% 
% disp('================ Segment multiple end ==================');
imgO = imread([PathName imgName imgExt]); %pick an image
imgO = imgO(:, :, 1);
img0 = double(imgO);
szimg = size(img0);
imgPad = padarray(img0, [0, 1],  'symmetric');

ROI = struct();

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
% toc
% fatten image and 7th boundary to make the next segmentation easier
[fattenedImgPad, refpt] = fattenImg(imgPad, B7);

fattenedB7 = ones(size(B7)) .* refpt;

% plot(ax, Y,fattenedB7,'g-.','linewidth',2);

% plot(ax, Y,B7,'g-.','linewidth',2);
if isDrusen == false
    fattenedImgPad = imgPad;
    fattenedB7 = B7;
end
% 
% f = figure;
% ax3 = axes(f);
% imagesc(ax3,img0); colormap('gray'); axis off; axis equal;
% hold;
% plot(Y, B7, 'y', 'linewidth', 2);
% title(ax3, 'ROI 5th');

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
%% get the 8th boundary (OS-RPE border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the region of interst, refering to IS-OS layer
% BW0 = removeRegionAboveSegLine(B7, Y, imgPad, params.p8thAboveBandWidth); %6th
BW0 = removeRegionAboveSegLine(fattenedB7, Y, imgPad, params.p8thAboveBandWidth); %6th
BW1 = removeRegionBelowSegLine(B9, Y, imgPad, params.p8thBelowBandWidth); %bottom
BW = BW0 .* BW1;

ROI.reg8 = BW;

gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.08, 0.1);

[B8, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);

% plot(ax, Y, B8, 'b-.', 'linewidth', 2);

%% get the 6th boundary (ONL_IS border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the region of interest i.e. narrow band above the IS_OS layer
BW = zeros(szimg);
% BW(refpt - params.p6thAboveBandWidth:refpt - params.p6thBelowBandWidth, 1:end) = 1; % adjust parameters to get right ROI
BW0 = removeRegionBelowSegLine(fattenedB7, Y, imgPad, params.p6thAboveBandWidth);
BW1 = removeRegionBelowSegLine(fattenedB7, Y, imgPad, params.p6thBelowBandWidth);

BW = BW1 - BW0;

ROI.reg6 = BW;

gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1);

[B6, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);

%% get the 1st boundary (IML border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BW = removeRegionBelowSegLine(B6, Y, imgPad, params.p1stBelowBandWidth);

gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.05, 50);

% alphamask(BW, [0 1 1], 0.4);

ROI.reg1 = BW;



[B1, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

% smooth IML layer to create better ROI for INL_OPL
[soomthedB1, Y] = smoothSegLine(B1, Y, 0.0000001);

%     plot(Y, B1, 'r', 'linewidth', 2);
%% get the 4th boundary (INL_OPL border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p4thAboveBandWidth = 10;
p4thBelowBandWidth = 10;
BW0 = removeRegionAboveSegLine(soomthedB1, Y, imgPad, p4thAboveBandWidth); %1st
BW1 = removeRegionBelowSegLine(B6, Y, imgPad, p4thBelowBandWidth); %6th
BW = BW0 .* BW1; %ROI between 1th and 6th layers

gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1000);

[B4, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.4);

%% get the 5th boundary (OPLO border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p5thAboveBandWidth = 2;
p5thBelowBandWidth = 5;
BW0 = removeRegionAboveSegLine(B4, Y, imgPad, p5thAboveBandWidth); %4th
BW1 = removeRegionBelowSegLine(B6, Y, imgPad, p5thBelowBandWidth); %6th
BW = BW1 .* BW0; %ROI between 4th and 6th layers



ROI.reg5 = BW;

gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.06, 1);

[B5, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

% plot(Y, B5, 'c', 'linewidth', 2);

%% get the 4th boundary (INL_OPL border) again
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW0 = removeRegionAboveSegLine(B1, Y, imgPad, params.p4thAboveBandWidth2); %1st
BW1 = removeRegionBelowSegLine(B5, Y, imgPad, params.p4thBelowBandWidth2); %5th
BW = BW0 .* BW1; %ROI between 1th and 6th layers

ROI.reg4 = BW;

gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1000);

[B4, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = find(B4 > B5);
B4(temp) = B5(temp) - 1;

temp = find(B4 < B1 + 3);
B4(temp) = B1(temp) + 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[B4, Y] = smoothSegLine(B4, Y, 0.01);


%% get the 3th boundary (IPL-INL border)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW0 = removeRegionBelowSegLine(B4, Y, imgPad, params.p3thAboveBandWidth); %4th
BW1 = removeRegionBelowSegLine(B4, Y, imgPad, params.p3thBelowBandWidth); %4th

BW = BW0 - BW1; % ROI above 4th layer

gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.08, 10);

ROI.reg3 = BW;

[B3, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = find(B3 < B1 + 1);
B3(temp) = B1(temp) + 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[B3, Y] = smoothSegLine(B3, Y, 0.01);

% plot(Y, B3, 'y', 'linewidth', 2);

%% get the 2th boundary (RNFL border)
BW1 = removeRegionAboveSegLine(B1, Y, imgPad, params.p2thAboveBandWidth); % if above move seg line down to several pixels
BW0 = removeRegionBelowSegLine(B3, Y, imgPad, params.p2thBelowBandWidth); % if below move seg line up to several pixels
BW = BW0 .* BW1; %ROI between 1th and 3th layers

gradImg = getGradientMap(fattenedImgPad, brightTodark, 0.08, 0.001);

[B2, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

ROI.reg2 = BW;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = find(B2 < B1);
B2(temp) = B1(temp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

if isDrusen == true
    temp = refpt - B7;
    
    B9 = B9 - temp;
    B8 = B8 - temp;
    B6 = B6 - temp;
    B5 = B5 - temp;
    B4 = B4 - temp;
    B3 = B3 - temp;
    B2 = B2 - temp;
    B1 = B1 - temp;
end

output = struct();
output.B1 = B1;
output.B2 = B2;
output.B3 = B3;
output.B4 = B4;
output.B5 = B5;
output.B6 = B6;
output.B7 = B7;
output.B8 = B8;
output.B9 = B9;

% f = figure;
% ax4 = axes(f);
% imagesc(ax4,img0); colormap('gray'); axis off; axis equal;
% hold;
% plot(Y, B1, 'y', 'linewidth', 2);
% plot(Y, B7, 'y', 'linewidth', 2);
% plot(Y, B9, 'y', 'linewidth', 2);
% title(ax4, 'ROI 5th');

if segType == true
    
%     RPECH_OSRPE = B9 - B8;
%     OSRPE_ISOS = B8 - B7;
%     ISOS_ONLIS = B7 - B6;
%     ONLIS_OPLO = B6 - B5;
%     OPLO_INLOPL = B5 - B4;
%     INLOPL_IPLINL = B4 - B3;
%     IPLINL_RNFL = B3 - B2;
%     RNFL_IML = B2 - B1;
%     
%     Layers = [
%         RPECH_OSRPE;
%         OSRPE_ISOS;
%         ISOS_ONLIS;
%         ONLIS_OPLO;
%         OPLO_INLOPL;
%         INLOPL_IPLINL;
%         IPLINL_RNFL;
%         RNFL_IML;
%         ];
    
    
    previousFolder = pwd;
    cd([PathName subFolderName '/']);
    
    %     mkdir(imgName);
    %     cd(imgName);
    
    [~,len] = size(Y);
    layers = [B1(1:len);B2(1:len);B3(1:len);B4(1:len);B5(1:len);B6(1:len);B7(1:len);B8(1:len);B9(1:len)];
    
    segmentedImage = struct('Name', [PathName imgName imgExt], 'Layers', layers, 'params', params);
    
    disp([PathName imgName '.mat']);
    save([PathName imgName '.mat'],'-struct', 'segmentedImage');
    
   
    cd(previousFolder);
end
