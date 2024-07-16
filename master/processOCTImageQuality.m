function processOCTImageQuality(imgPath)
    % Load the image
    img = imread(imgPath);
    disp(imgPath);

    % Convert to grayscale if necessary
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Compute Quality Index (QI)
    QI = calculateQI(img);
    disp(['Quality Index (QI): ', num2str(QI)]);

    % Compute other image quality metrics
    [entropy_value, sharpness, brisque_score, psnr_value, ssim_value] = calculateImageMetrics(img);
    
    % Display the calculated metrics
    disp(['Entropy: ', num2str(entropy_value)]);
    disp(['Sharpness: ', num2str(sharpness)]);
    disp(['Brisque score: ', num2str(brisque_score)]);
    disp(['PSNR: ', num2str(psnr_value)]);
    disp(['SSIM: ', num2str(ssim_value)]);
end
