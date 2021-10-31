function [BW,L] = extractFluidOnClick(image,X,Y, params)
%EXTRACTFLUIDONCLICK Summary of this function goes here
%   Detailed explanation goes here

close all;

filtredImage = medfilt2(image,[3 3]);

level = multithresh(filtredImage,7);
multiTreshBW = imquantize(filtredImage,level);

f = figure;
ax5 = axes(f);
imagesc(ax5,multiTreshBW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'MUltitresh');
hold off;

maskConnected = zeros(size(image));

if multiTreshBW(Y,X) <= 3
    maskConnected = grayconnected(multiTreshBW,Y,X);
end

f = figure;
ax5 = axes(f);
imagesc(ax5,maskConnected); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'OBJ');
hold off;

maskConnected = imfill(maskConnected, 'holes');

BW = maskConnected;

[mask,output] = extractRetinaMask(filtredImage,params);

% Close mask with diamond
radius = 3;
se = strel('diamond', radius);
BW = imclose(BW, se);


BW(~mask) = 255;

% Active contour
% BW = imcomplement(BW);
iterations = 200;
BW = activecontour(image, BW, iterations, 'Chan-Vese');

% Clear borders
% BW = imclearborder(BW);

BW(~mask) = 0;

for jj=1:size(BW,2)    
    for ii=1:size(BW,1)
        if ~(ii >= (output.B1(jj)+1) && ii<= output.B9(jj))
            BW(ii,jj) = 0;
        end
    end
end

% Fill holes
BW = imfill(BW, 'holes');

f = figure;
ax5 = axes(f);
imagesc(ax5,BW); colormap('gray'); axis off; axis equal; hold on;
title(ax5, 'RESULT');
hold off;
%

CC = bwconncomp(BW);
L = labelmatrix(CC);

end

