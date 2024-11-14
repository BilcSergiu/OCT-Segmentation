% File paths and parameters
p = 'D:\Licenta\Datasets\date_31_ian\Pacient_1\OD\Visit_1\';
f = 'A910D10';
ext = '.tif';

params = struct();
params.C = 0.001;
params.smoothParam = 0.02;
params.gradientSmoothParam = 0.02;
params.gradientEnhaParam = 1;
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

% Perform segmentation
[layers, ROI] = segmentMultipleOCT(p, f, ext, '', false, params, false);

% Construct the full image path
imgPath = fullfile(p, [f, ext]);

% Read the original OCT image
octImage = imread(imgPath);

% Display the OCT image
figure;
imshow(octImage, []);
title('OCT Image with Segmented Layers and ROIs');
hold on;

% Plot each boundary on the image
x = 1:length(layers.B1); % Assuming that the length of each boundary matches the image width

plot(x, layers.B1, 'Color', 'r', 'LineWidth', 1.5); %layers.B1 in red
text(x(end),layers.B1(end), 'B1', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B2, 'Color', 'g', 'LineWidth', 1.5); %layers.B2 in green
text(x(end),layers.B2(end), 'B2', 'Color', 'g', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B3, 'Color', 'b', 'LineWidth', 1.5); %layers.B3 in blue
text(x(end),layers.B3(end), 'B3', 'Color', 'b', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B4, 'Color', 'c', 'LineWidth', 1.5); %layers.B4 in cyan
text(x(end),layers.B4(end), 'B4', 'Color', 'c', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B5, 'Color', 'm', 'LineWidth', 1.5); %layers.B5 in magenta
text(x(end),layers.B5(end), 'B5', 'Color', 'm', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B6, 'Color', 'y', 'LineWidth', 1.5); %layers.B6 in yellow
text(x(end),layers.B6(end), 'B6', 'Color', 'y', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B7, 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); %layers.B7 in gray
text(x(end),layers.B7(end), 'B7', 'Color', [0.5 0.5 0.5], 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B8, 'Color', [0.5 0 0.5], 'LineWidth', 1.5); %layers.B8 in purple
text(x(end),layers.B8(end), 'B8', 'Color', [0.5 0 0.5], 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');

plot(x,layers.B9, 'Color', [0.3 0.7 0.2], 'LineWidth', 1.5); %layers.B9 in a custom color (greenish)
text(x(end),layers.B9(end), 'B9', 'Color', [0.3 0.7 0.2], 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'white');


hold off;