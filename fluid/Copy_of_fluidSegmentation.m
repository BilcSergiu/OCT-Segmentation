function [output, ROI] = fluidSegmentation(PathName, imgName, imgExt, params)

close all;

img0= imread([PathName imgName imgExt]);

Im = img0(:, :, 1);
% ImB=medfilt2(Im,[11 11]);
ImB = medfilt2(Im,[5 5]);
% ImB = medfilt2(Im,[3 3]);

% f = figure;
% ax0 = axes(f);
% imagesc(ax0,ImB); colormap('gray'); axis off; axis equal; hold on;
% title(ax0, 'FIltered');
% hold off;
% 
% edges = edge(ImB,'sobel');
% f = figure;
% ax1 = axes(f);
% imagesc(ax1,edges); colormap('gray'); axis off; axis equal; hold on;
% title(ax1, 'Edges Sobel');
% hold off;
% 
% edges = canny(ImB);
% f = figure;
% ax1 = axes(f);
% imagesc(ax1,edges); colormap('gray'); axis off; axis equal; hold on;
% title(ax1, 'Edges canny');
% hold off;

% my_image = edges;
% se = offsetstrel('ball',3,5);
% my_image = imdilate(my_image, se);
% 
% max_pixel= 0;
% [~,min_pixel] = size(ImB);

my_image = ImB;

output = extractRetina(PathName, imgName, imgExt, params);

f = figure;
ax2 = axes(f);
imagesc(ax2,ImB); colormap('gray'); axis off; axis equal; hold on;
title(ax2, 'Extracted layers');
plot(ax2, 1:514,output.B1,'g-.','linewidth',2);
plot(ax2, 1:514,output.B9,'r-.','linewidth',2);
hold off;

mask = zeros(size(ImB));

for jj=1:size(my_image,2)    
    for ii=1:size(my_image,1)
        if ii >= output.B1(jj) && ii<= output.B9(jj)
            mask(ii,jj) = 255;
        else
            mask(ii,jj) = 0;
        end
    end
end

f = figure;
ax3 = axes(f);
imagesc(ax3,mask); colormap('gray'); axis off; axis equal; hold on;
title(ax3, 'Initial Contour Location');
hold off;

% figure();
% bw = activecontour(ImB,mask,100);
% imshow(bw)
% title('Segmented Image, 100 Iterations')

bw = mask;

img0 = double(Im);

disp(class(img0));
disp(class(mask));

% retina = medfilt2(Im, [5 5]);;
retina = ImB;
retina(~bw) = 255;
% retina(~bw) = 0;

f = figure;
ax4 = axes(f);
imagesc(ax4,retina); colormap('gray'); axis off; axis equal; hold on;
title(ax4, 'Retina');
hold off;

histo = zeros([1 257]);

for jj=1:size(retina,2)    
    for ii=1:size(retina,1)
        histo(retina(ii,jj)+1) = histo(retina(ii,jj)+1) + 1;
    end
end

noTreshold = 0;
totalThresh = 0;
for i=1:70
    noTreshold = noTreshold + histo(:,i);
end

for i=1:254
    totalThresh = totalThresh + histo(:,i);
end
%   disp(histo);
% disp(noTreshold);
% disp(totalThresh);

levelTresh = noTreshold / totalThresh;

disp(levelTresh);
% disp('MOOOOOOOOOOOOR');

% 
% T = adaptthresh(retina, levelTresh, 'ForegroundPolarity','dark');
% BW = imbinarize(retina, T);

level = multithresh(retina,7);
BW = imquantize(retina,level);

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'Multitresh');
hold off;

% T = adaptthresh(BW,levelTresh+0.2, 'ForegroundPolarity','dark');
BW12 = zeros(size(BW));
multiTreshBW = BW;

for jj=1:size(BW,2)    
    for ii=1:size(BW,1)
        if BW(ii,jj) <= 2
            BW12(ii,jj) = 0;
         
        else
            BW12(ii,jj) = 255;
        end
    end
end
BW = BW12;

se = strel('sphere', 2);
% se = offsetstrel('ball',3,5);
% BW = imdilate(BW, se);
% BW = imerode(BW, se);
BW = imclose(BW, se);

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'Treshold');
hold off;

% 
% [L,N] = superpixels(retina,800);
% BW1 = boundarymask(L);
% 
% f = figure;
% ax5 = axes(f);
% imagesc(ax5,imoverlay(retina, BW1, 'cyan')); axis off; axis equal; hold on;
% title(ax5, 'Initiail magnification');
% hold off;

% 
% se = strel('sphere', 2);
% BW = imclose(BW, se);
foregroundX = [];
foregroundY = [];
backgroundX = [];
backgroundY = [];

mask1 = zeros(size(retina));
mask2 = zeros(size(retina));

maskConnected = zeros(size(retina));
% retina = rescale(retina);

for jj=1:size(retina,2)    
    auxBackgroundX = [];
    auxBackgroundY = [];
    isForeground = false;
    for ii=1:size(retina,1)
        if multiTreshBW(ii,jj) > 1 && retina(ii,jj) ~= 255 && mod(jj,75)==0 && ii<=size(retina,1) && jj<=size(retina,2)
            auxBackgroundX = [auxBackgroundX ii];
            auxBackgroundY = [auxBackgroundY jj];
            mask2(ii,jj) = 255;
        end
        if multiTreshBW(ii,jj) <= 1 && maskConnected(ii,jj)==0 && ii<=size(retina,1) && jj<=size(retina,2)
            foregroundX = [foregroundX ii];
            foregroundY = [foregroundY jj];
            mask1(ii,jj) = 255;
            maskConnected = or(maskConnected,grayconnected(retina,ii,jj,40));
%             isForeground = true;
        end
    end
    if isForeground == false
        backgroundX = [backgroundX auxBackgroundX];
        backgroundY = [backgroundX auxBackgroundY];
    end
end


maskConnected = imfill(maskConnected, 'holes');
f = figure;
ax5 = axes(f);
imagesc(ax5,maskConnected); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'MASK CONNECTED');
hold off;

% size1 = min([1000,length(foregroundX)]);
% 
% foregroundX = foregroundX(1:size1);
% foregroundY = foregroundY(1:min([1000,length(foregroundY)]));
% backgroundX = backgroundX(1:min([1000,length(backgroundX)]));
% backgroundY = backgroundY(1:min([1000,length(backgroundY)]));
% 
% disp('======================== TE ADOR ==================');
% % disp(length(foregroundY));
% % disp(length(foregroundX));
% disp(foregroundY);
% disp(foregroundX);
% % disp(length(backgroundY));
% % disp(length(backgroundX));
% % disp(size(retina));
% % disp(foregroundInd);
% % disp(backgroundY);
% disp('======================== TE ADOR ==================');
% 
% foregroundInd = sub2ind(size(retina),foregroundX,foregroundY);
% backgroundInd = sub2ind(size(retina),backgroundX,backgroundY);
% 
% f = figure;
% ax5 = axes(f);
% imagesc(ax5,mask1); colormap('gray'); axis off; axis equal; hold on;
% title(ax5, 'FOREGROUND');
% hold off;
% 
% f = figure;
% ax5 = axes(f);
% imagesc(ax5,mask2); colormap('gray'); axis off; axis equal; hold on;
% title(ax5, 'BACKGROUND');
% hold off;

% BW = lazysnapping(ImB,L,foregroundInd,backgroundInd);
BW = maskConnected;
% BW = imclearborder(BW);

% Close mask with diamond
radius = 3;
se = strel('diamond', radius);
BW = imclose(BW, se);

BW(~bw) = 255;

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'Lazy snapping');
hold off;

% Active contour
% BW = imcomplement(BW);
iterations = 200;
BW = activecontour(Im, BW, iterations, 'Chan-Vese');

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'Active contour');
hold off;

% Clear borders
% BW = imclearborder(BW);

for jj=1:size(BW,2)    
    for ii=1:size(BW,1)
        if ~(ii >= output.B1(jj) && ii<= output.B9(jj))
            BW(ii,jj) = 0;
        end
    end
end

% Fill holes
BW = imfill(BW, 'holes');

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'Treshold x2');
hold off;

f = figure;
ax6 = axes(f);
imagesc(ax6,Im); colormap('gray'); axis off; axis equal; hold on;
alphamask(BW, [0 0 1]);
title(ax6,'Final');
hold off;

end
