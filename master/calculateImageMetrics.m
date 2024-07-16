function [entropy_value, sharpness, brisque_score, psnr_value, ssim_value, snr_value] = calculateImageMetrics(img, referenceImg)
    % Calculate entropy
    entropy_value = entropy(img);

    % Ensure both images are of the same class
    img = double(img);
    referenceImg = double(referenceImg);

    % Calculate sharpness using Laplacian variance
    laplacian_filter = fspecial('laplacian', 0);
    laplacian_image = imfilter(img, laplacian_filter);
    laplacian_image = double(laplacian_image);
    sharpness = var(laplacian_image(:));

    % Calculate BRISQUE score
    brisque_score = brisque(img);

    % Convert to double for processing
    double_image = double(img); 
    
    % Uncomment the following lines if you want to use denoising as the reference
    % % Denoise the image using Split Bregman ROF
    % referenceImg = SplitBregmanROF(double_image, .15, 0.001);
    
    % Normalize images for PSNR calculation
    psnr_value = psnr(mat2gray(referenceImg), mat2gray(double_image));

    % Calculate SSIM
    ssim_value = ssim(double_image, referenceImg);
    
    % Calculate SNR
    signal_power = mean(referenceImg(:).^2);
    noise_power = mean((referenceImg(:) - double_image(:)).^2);
    snr_value = 10 * log10(signal_power / noise_power);
end
