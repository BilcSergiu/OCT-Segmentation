%              rof_mex_demo.m  by Tom Goldstein
% This code tests the method defined by "splitBregmanROF.c".  This code
% must be compiled using the "mex" command before this demo will work.

 
% Step 1:  Get the test image
exact = double(imread('D:\Licenta\Datasets\OCT2017\train\CNV\CNV-135126-11.jpeg'));
% dims = size(exact);
% 
% noisy = exact+15*randn(dims);
% 
% % Step 2: Denoise the Image
% 
% clean = SplitBregmanROF(exact,.03,0.001);
% 
% % Step 3:  Display Results
% 
% close all;
% figure;
% subplot(2,2,1);
% imagesc(exact);
% colormap(gray);
% title('Original');
% 
% % subplot(2,2,2);
% % imagesc(noisy);
% % colormap(gray);
% % title('noisy');
% 
% subplot(2,2,3);
% imagesc(clean);
% colormap(gray);
% title('denoised');
% 
% subplot(2,2,4);
% imagesc(exact-clean);
% % imagesc(noisy-clean);
% colormap(gray);
% title('difference');

if size(exact, 3) == 3
    exact = rgb2gray(exact);
end

% exact(exact> 250) = 0;
normalized_image = mat2gray(exact);

% Automatic Signal ROI Detection using thresholding and region properties
threshold_level = graythresh(normalized_image);
disp(threshold_level);
binary_image = imbinarize(normalized_image, threshold_level);

% Remove small objects
binary_image = bwareaopen(binary_image, 100);

% Label connected components
labeled_image = bwlabel(binary_image);

% Measure properties of regions
regions = regionprops(labeled_image, 'Area', 'PixelIdxList');

% Assuming the largest non-background region as signal region
[~, idx] = max([regions.Area]);
signal_idx = regions(idx).PixelIdxList;
signal_values = normalized_image(signal_idx);

% Calculate mean and standard deviation for signal
mean_signal = mean(signal_values);
std_signal = std(signal_values);

% Automatic Noise ROI Detection (assuming border regions as noise)
border_size = 10;
top_border = normalized_image(1:border_size, :);
bottom_border = normalized_image(end-border_size+1:end, :);
left_border = normalized_image(:, 1:border_size);
right_border = normalized_image(:, end-border_size+1:end);

% Concatenate the noise regions correctly
noise_region = [top_border(:); bottom_border(:); left_border(:); right_border(:)];
mean_noise = mean(noise_region);
std_noise = std(noise_region);

% Calculate SNR
snr = mean_signal / std_noise;

% Display the results
disp(['Mean Signal Intensity: ', num2str(mean_signal)]);
disp(['Standard Deviation of Signal Intensity: ', num2str(std_signal)]);
disp(['Mean Noise Intensity: ', num2str(mean_noise)]);
disp(['Standard Deviation of Noise Intensity: ', num2str(std_noise)]);
disp(['SNR: ', num2str(snr)]);

% Visualization for human validation
figure;
imshow(normalized_image, []);
hold on;
[y, x] = ind2sub(size(normalized_image), signal_idx);
plot(x, y, 'r.', 'MarkerSize', 1);
title(['SNR: ', num2str(snr)]);
