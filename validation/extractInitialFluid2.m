function [maskedConnected] = extractInitialFluid2(real,originalImage, mask, B1, B9)
%EXTRACTINITIALFLUID Summary of this function goes here
%   Detailed explanation goes here


level = multithresh(originalImage,7);
BW = imquantize(originalImage,level);
multiTreshBW = BW;


% f = figure;
% ax3 = axes(f);
% imagesc(ax3,multiTreshBW); colormap('gray'); axis off; axis equal; hold;
% title(ax3, 'multiTreshBW');
% alphamask(auxMaskConnected, [0 1 1],0.8, ax3);
% hold off;

% figure;
% histo2 = histogram(multiTreshBW);

auxMaskConnected = zeros(size(originalImage));


% T = adaptthresh(originalImage,0.1, 'ForegroundPolarity','dark');
% BW = imbinarize(originalImage,T);
% temp = zeros(size(originalImage));
% temp = originalImage(BW == 0);
% T = max(temp);
% 
% f = figure;
% ax3 = axes(f);
% imagesc(ax3,temp); colormap('gray'); axis off; axis equal; hold;
% title(ax3, 'temp');
% hold off;
% 
% disp(T);

for jj=1:size(originalImage,2)    
    for ii=1:size(originalImage,1)
        if multiTreshBW(ii,jj) <= 1 && originalImage(ii,jj) < 18 && auxMaskConnected(ii,jj)==0
            auxMaskConnected = or(auxMaskConnected, grayconnected(originalImage,ii,jj,18));
        end
    end
end

maskedConnected = imfill(auxMaskConnected, 'holes');

radius = 3;
se = strel('diamond', radius);
maskedConnected = imclose(maskedConnected, se);

%  f = figure;
% ax6 = axes(f);
% imagesc(originalImage); colormap('gray'); axis off; axis equal;
% hold on;
% title(ax6,'Flood fill');
% alphamask(auxMaskConnected, [0 1 1],0.8, ax6);
% hold off;

maskedConnected(~mask) = 255;

iterations = 150;
maskedConnected = activecontour(real, maskedConnected, iterations, 'Chan-Vese');

for jj=1:size(maskedConnected,2)    
    for ii=1:size(maskedConnected,1)
        if ~(ii >= (B1(jj)+1) && ii<= B9(jj))
            maskedConnected(ii,jj) = 0;
        end
    end
end

maskedConnected = imfill(maskedConnected, 'holes');

%  f = figure;
% ax6 = axes(f);
% imagesc(originalImage); colormap('gray'); axis off; axis equal;
% hold on;
% title(ax6,'ACTIVE');
% alphamask(maskedConnected, [0 1 1],0.8, ax6);
% hold off;

maskedConnected = imclearborder(maskedConnected);
 
end

