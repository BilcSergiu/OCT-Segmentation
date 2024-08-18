% close all;

%% Test retina mask 
params = struct();
params.C = 0.001;
params.smoothParam = 0.02;
params.gradientSmoothParam = 0.02;
params.gradientEnhaParam = 0.0001;
params.p9thAboveBandWidth = 10;
params.p9thSmoothParam = 0.0002;
params.p8thAboveBandWidth = 0;
params.p8thBelowBandWidth = 8;
params.p6thAboveBandWidth = 15;
params.p6thBelowBandWidth = 2;
params.p1stBelowBandWidth = 25;
params.p4thAboveBandWidth2 = 20;
params.p4thBelowBandWidth2 = 1;
params.p3thAboveBandWidth = 4;
params.p3thBelowBandWidth = 14;
params.p2thAboveBandWidth = 4;
params.p2thBelowBandWidth = 8;

% original = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/273EB090.tif');
% manualMask = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/fluid/retina_273EB090.tif');
img = imread('D:\Licenta\Interface\OCTSegExamples\date_31_ian\Pacient_5\OD\Visit_8\273EB090.tif');
img = img(:,:,1);
algoMask = extractRetinaMask(img,params);

% difff1 = zeros(size(manualMask));
% difff2 = zeros(size(algoMask));
% 
% difff1(manualMask==1 & algoMask==0) = 1;
% difff2(manualMask==0 & algoMask==255) = 1;
% diff = or(difff1,difff2);
% 
% numberOfWhitePixels = sum(diff(:));
% totalNumberOfPixels = numel(diff);
% differencePercentage = numberOfWhitePixels / totalNumberOfPixels;
% 
% disp(differencePercentage);
% 
% assert(differencePercentage < 0.03);

f = figure;
ax6 = axes(f);
montage({original, diff, manualMask, algoMask}); colormap('gray'); axis off; axis equal; hold on;
title(ax6,'Retina mask');
hold off;
% %% Test number 2
% 
% params = struct();
% params.C = 0.001;
% params.smoothParam = 0.02;
% params.gradientSmoothParam = 0.02;
% params.gradientEnhaParam = 0.0001;
% params.p9thAboveBandWidth = 10;
% params.p9thSmoothParam = 0.0002;
% params.p8thAboveBandWidth = 0;
% params.p8thBelowBandWidth = 8;
% params.p6thAboveBandWidth = 15;
% params.p6thBelowBandWidth = 2;
% params.p1stBelowBandWidth = 25;
% params.p4thAboveBandWidth2 = 20;
% params.p4thBelowBandWidth2 = 1;
% params.p3thAboveBandWidth = 4;
% params.p3thBelowBandWidth = 14;
% params.p2thAboveBandWidth = 4;
% params.p2thBelowBandWidth = 8;
% 
% originalImage = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/273EB090.tif');
% originalImage = originalImage(:,:,1);
% 
% manualMask = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/fluid/manual_273EB090.tif');
% 
% [mask,layers] = extractRetinaMask('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/', '273EB090','.tif',params);
% fluid = extractInitialFluid(originalImage,originalImage, mask, layers.B1, layers.B9);
% 
% difff1 = zeros(size(manualMask));
% difff2 = zeros(size(fluid));
% 
% difff1(manualMask==1 & fluid==0) = 1;
% difff2(manualMask==0 & fluid==255) = 1;
% diff = or(difff1,difff2);
% 
% numberOfWhitePixels = sum(diff(:));
% 
% mask(mask==255 ) = 1;
% 
% totalNumberOfPixels = sum(mask(:));
% differencePercentage = numberOfWhitePixels / totalNumberOfPixels;
% disp(differencePercentage);
% 
% assert(differencePercentage < 0.05);
% 
% % f = figure;
% % ax6 = axes(f);
% % montage({originalImage, diff, manualMask, fluid}); colormap('gray'); axis off; axis equal; hold on;
% % title(ax6,'Fluid');
% % hold off;
% %% Test whole functionality
% 
% params = struct();
% params.C = 0.001;
% params.smoothParam = 0.02;
% params.gradientSmoothParam = 0.02;
% params.gradientEnhaParam = 0.0001;
% params.p9thAboveBandWidth = 10;
% params.p9thSmoothParam = 0.0002;
% params.p8thAboveBandWidth = 0;
% params.p8thBelowBandWidth = 8;
% params.p6thAboveBandWidth = 15;
% params.p6thBelowBandWidth = 2;
% params.p1stBelowBandWidth = 25;
% params.p4thAboveBandWidth2 = 20;
% params.p4thBelowBandWidth2 = 1;
% params.p3thAboveBandWidth = 4;
% params.p3thBelowBandWidth = 14;
% params.p2thAboveBandWidth = 4;
% params.p2thBelowBandWidth = 8;
% 
% originalImage = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/273EB090.tif');
% originalImage = originalImage(:,:,1);
% 
% manualMask = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/fluid/manual_273EB090.tif');
% 
% [mask,~] = extractRetinaMask('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/', '273EB090','.tif',params);
% [fluid,labeledFluid] = fluidSegmentation('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/', '273EB090','.tif',params);
% 
% difff1 = zeros(size(manualMask));
% difff2 = zeros(size(fluid));
% 
% difff1((manualMask==1 & fluid==0) | (manualMask==255 & fluid==0)) = 1;
% difff2((manualMask==0 & fluid==255) | (manualMask==0 & fluid==1) ) = 1;
% diff = or(difff1,difff2);
% 
% numberOfWhitePixels = sum(diff(:));
% 
% mask(mask==255 ) = 1;
% 
% totalNumberOfPixels = sum(mask(:));
% differencePercentage = numberOfWhitePixels / totalNumberOfPixels;
% 
% disp(differencePercentage);
% 
% assert(differencePercentage < 0.03);
% 
% f = figure;
% ax6 = axes(f);
% montage({originalImage, diff, manualMask, fluid}); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'Fluid segmentation');
% hold off;