function [snr, snr_dB, CNR, QSNR] = calculateSNR2(image_path, threshold_area)
    % calculate_snr - Computes the SNR and relevant statistics from an OCT image
    %
    % Syntax: [snr, mean_signal, std_signal, mean_noise, std_noise] = calculate_snr(image_path, threshold_area)
    %
    % Inputs:
    %    image_path - The file path to the OCT image
    %    threshold_area - Minimum area for considering regions (default is 100 if not provided)
    %
    % Outputs:
    %    snr - Signal-to-noise ratio
    %    mean_signal - Mean intensity of the signal region
    %    std_signal - Standard deviation of the signal region
    %    mean_noise - Mean intensity of the noise region
    %    std_noise - Standard deviation of the noise region

    if nargin < 2
        threshold_area = 100;
    end
    
    % Step 1: Load and preprocess the image
    exact = imread(image_path);

    if size(exact, 3) == 3
        exact = rgb2gray(exact);
    end
    normalized_image = mat2gray(exact);

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

    % Calculate mean and standard deviation for signal
    mean_signal = mean(signal_values);
    std_signal = std(signal_values);

    % Step 3: Automatic Noise ROI Detection (assuming border regions as noise)
    border_size = 10;
    top_border = normalized_image(1:border_size, :);
    bottom_border = normalized_image(end-border_size+1:end, :);
    left_border = normalized_image(:, 1:border_size);
    right_border = normalized_image(:, end-border_size+1:end);

    % Concatenate the noise regions correctly
    noise_region = [top_border(:); bottom_border(:); left_border(:); right_border(:)];
    mean_noise = mean(noise_region);
    std_noise = std(noise_region);

    % Step 4: Calculate SNR
    snr = mean_signal / std_noise;

    CNR = (mean_signal - mean_noise) / std_noise;

    speckleNoiseLevel = std_signal;
    QSNR = (snr + CNR) / speckleNoiseLevel;

    snr_dB = 10 * log10(snr);
    % SNR = (mean_signal - mean_noise) / std_noise;d

    % Step 5: Display the results
    % disp(['Mean Signal Intensity: ', num2str(mean_signal)]);
    % disp(['Standard Deviation of Signal Intensity: ', num2str(std_signal)]);
    % disp(['Mean Noise Intensity: ', num2str(mean_noise)]);
    % disp(['Standard Deviation of Noise Intensity: ', num2str(std_noise)]);
    % disp(['SNR: ', num2str(snr)]);
    % disp(['SNR_dB: ', num2str(snr_dB)]);
    % disp(['SNR diff: ', num2str(SNR)]);

    % Visualization for human validation
    % figure;
    % imshow(normalized_image, []);
    % hold on;
    % [y, x] = ind2sub(size(normalized_image), signal_idx);
    % plot(x, y, 'r.', 'MarkerSize', 1);
    % title(['SNR: ', num2str(snr)]);
end
