
function bw=Seg2(IM,ws,C,smoothPara)

IM=double(IM(:,:,1));
IM=SplitBregmanROF(IM,smoothPara,0.005);
IM=mat2gray(IM);

% f = figure;
% ax6 = axes(f);
% imagesc(ax6, IM); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'FILTER 1');
% hold off;

mIM=imfilter(IM,fspecial('average',ws),'replicate');

% f = figure;
% ax6 = axes(f);
% imagesc(ax6, mIM); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'Filter 2');
% hold off;

sIM=mIM-IM-C;

% f = figure;
% ax6 = axes(f);
% imagesc(ax6, sIM); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'sIM');
% hold off;

bw=im2bw(sIM,0);

% f = figure;
% ax6 = axes(f);
% imagesc(ax6, bw); colormap('gray'); axis off; axis equal; hold on;
% title(ax6,'bw');
% hold off;

bw=imcomplement(bw);