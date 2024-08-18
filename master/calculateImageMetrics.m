function [entropy_value, sharpness, brisque_score, psnr_value] = calculateImageMetrics(imgPath, threshold_area)

    if nargin < 2
        threshold_area = 100;
    end

    % Step 1: Load and preprocess the image
    img = imread(imgPath);

    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    normalized_image = mat2gray(img);

    % Step 2: Automatic Signal ROI Detection using thresholding and region properties
    threshold_level = graythresh(normalized_image);
    min_intensity = min(normalized_image(:));
    adjusted_threshold = threshold_level * 0.8 + min_intensity * 0.2; % Weighted adjustment
    % disp(['Threshold Level: ', num2str(adjusted_threshold)]);
    binary_image = imbinarize(normalized_image, adjusted_threshold);

    % Remove small objects
    binary_image = bwareaopen(binary_image, threshold_area);

    % Label connected components
    labeled_image = logical(binary_image);

    % Measure properties of regions
    regions = regionprops(labeled_image, 'Area', 'PixelIdxList');



    % Assuming the largest non-background region as signal region
    [~, idx] = max([regions.Area]);
    signal_idx = regions(idx).PixelIdxList;
    signal_values = normalized_image(signal_idx);

     % Create a binary mask for the signal region
    binary_mask = false(size(normalized_image));
    binary_mask(signal_idx) = true;

    filteredImg = normalized_image .* binary_mask;


   entropy_value = entropy(img);

    % Ensure both images are of the same class
    img = double(img);

    % Calculate sharpness using Laplacian variance
    laplacian_filter = fspecial('laplacian', 0);
    laplacian_image = imfilter(img, laplacian_filter);
    laplacian_image = double(laplacian_image);
    sharpness = var(laplacian_image(:));

    % Calculate BRISQUE score
    brisque_score = brisque(img);

    % Convert to double for processing
    double_image = double(img); 
    
    % % Uncomment the following lines if you want to use denoising as the reference
    % % % Denoise the image using Split Bregman ROF
    % referenceImg = SplitBregmanROF(double_image, .15, 0.001);
    
    % Normalize images for PSNR calculation
    psnr_value = psnr(mat2gray(filteredImg), mat2gray(double_image));

    % Calculate SSIM
    % ssim_value = ssim(double_image, mat2gray(filteredImg));
    
    % % Calculate SNR
    % signal_power = mean(referenceImg(:).^2);
    % noise_power = mean((referenceImg(:) - double_image(:)).^2);
    % snr_value = 10 * log10(signal_power / noise_power);
end
