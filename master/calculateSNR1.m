function [SNR, SNR_dB, CNR, QSNR] = calculateSNR1(imgPath)
   
    % Load the original OCT image
    I = imread(imgPath);
    
    % Get the file name and directory
    [imgDir, fileName, ext] = fileparts(imgPath);

    % Load the masked image saved earlier
    maskedImgPath = fullfile(imgDir, 'Signal', [fileName, ext]);
    if exist(maskedImgPath, 'file')
        maskedImage = imread(maskedImgPath);
    else
        error('Masked image not found: %s', maskedImgPath);
    end

    % Ensure the masked image is binary
    if size(maskedImage, 3) == 3
        maskedImage = rgb2gray(maskedImage);
    end
    ROI_mask = maskedImage > 0;

    % Get the size of the binary mask
    [rows, cols] = size(ROI_mask);

    % Initialize the new mask for the background
    top_black_mask = false(rows, cols);

    % Loop over each column to find the first white pixel and set the mask
    for col = 1:cols
        % Find the first white pixel in the column
        first_white_pixel_row = find(ROI_mask(:, col), 1, 'first');

        % If a white pixel is found, set all pixels above it to true (white)
        if ~isempty(first_white_pixel_row)
            top_black_mask(1:first_white_pixel_row-1, col) = true;
        end
    end

    % Convert the original image to double for precise calculations
    I = double(I);

    % Normalize the original image to range [0, 1]
    I = mat2gray(I);

    % Extract pixels for the ROI and background
    R_signal_pixels = I(ROI_mask);
    R_background_pixels = I(top_black_mask);

    % Calculate the noise standard deviation and mean intensity
    sigma_noise = std(R_background_pixels(:));
    mu_noise = mean(R_background_pixels(:));

    % Calculate the mean intensity of the signal
    mu_signal = mean(R_signal_pixels(:));
    sigma_signal = std(R_signal_pixels(:));

    % Compute SNR
    SNR = mu_signal / sigma_noise;
    
    CNR = (mu_signal - mu_noise) / sigma_noise;

    speckleNoiseLevel = sigma_signal;
    QSNR = (SNR + CNR) / speckleNoiseLevel;

    % Convert SNR to dB
    SNR_dB = 10 * log10(SNR);

    % % Display the SNR values
    % fprintf('SNR: %.2f\n', SNR);
    % fprintf('SNR in dB: %.2f dB\n', SNR_dB);
end
