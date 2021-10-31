function [mask, output] = extractRetinaMask(image, params)
%EXTRACTRETINAMASK Creating a mask for a image from the two input lines

% f = figure;
% ax3 = axes(f);
% imagesc(ax3,image); colormap('gray'); axis off; axis equal;
% title(ax3, 'image');

output = extractRetina(image, params);
B1 = output.B1;
B2 = output.B9;

originalImg = output.originalImage;

auxMask = zeros(size(originalImg));

for jj=1:size(originalImg,2)    
    for ii=1:size(originalImg,1)
        if ii >= B1(jj) && ii<= B2(jj)
            auxMask(ii,jj) = 255;
        else
            auxMask(ii,jj) = 0;
        end
    end
end

% f = figure;
% ax3 = axes(f);
% imagesc(ax3,auxMask); colormap('gray'); axis off; axis equal;
% title(ax3, 'masca');

image(~auxMask) = 0;

% f = figure;
% ax3 = axes(f);
% imagesc(ax3,image); colormap('gray'); axis off; axis equal;
% title(ax3, 'retina extrasa');

mask = auxMask;

end