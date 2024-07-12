function [fluid, labeledFluid] = fluidSegmentation2(img, params)
% 
% close all;
% img0= imread([PathName imgName imgExt]);
% Im = img0(:, :, 1);
% ImB = medfilt2(Im,[5 5]);
Im = img;
img0 = img;

[mask, output] = extractRetinaMask(img0, params);
% 
% f = figure;
% ax6 = axes(f);
% imagesc(Im); colormap('gray'); axis off; axis equal;
% title(ax6,'ORIGINAL');

retina = img0(:,:,1);
retina(~mask) = 255;

BW = extractInitialFluid2(Im, retina, mask, output.B1, output.B9);

fluid = BW;
labeledFluid = extractLabelMatrix(BW);
% 
% f = figure;
% ax6 = axes(f);
% imagesc(Im); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'ORIGINAL');

% imshow(label2rgb(labeledFluid,'jet','k','shuffle'));
% hold off;

end
