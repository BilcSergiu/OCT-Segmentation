img = imread('D:\Licenta\Datasets\OCTDL\OCTDL\ERM\erm_24.jpg'); % Load your OCT image
threshold = 30; % Set a threshold value for noise suppression

denoised_img = curvelet_denoising(img, threshold);

% Display the original and the denoised images
figure;
subplot(1, 2, 1);
imshow(img, []);
title('Original Image');

subplot(1, 2, 2);
imshow(denoised_img, []);
title('Denoised Image');