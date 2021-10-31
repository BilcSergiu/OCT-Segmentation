fileName ='273EB090.tif';
img = imread(['/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_5/OD/Visit_8/' fileName]);
im = imshow(img);

N = 1;
ROI = zeros(size(img));

for i = 1:N
    e = drawassisted(im);
%     position = wait();
    BW = createMask(e, im);
    ROI = or(ROI, BW);
end

f = figure;
ax2 = axes(f);
imagesc(ax2,ROI); colormap('gray'); axis off; axis equal; hold on;
% alphamask(BW, [0 1 1], 0.5);
title(ax2, 'Retina');
ROI = ROI(:,:,1);

imwrite(ROI,'retina_2341C0C0.tif');

