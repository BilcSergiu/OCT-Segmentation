function qualityScore = calculateGradientMetric(imgPath)
    % Assess the quality of an OCT image, focusing on internal retinal layer clarity and robustness to noise.
    
    % Read the image
    img = imread(imgPath);
    
    % Convert the image to grayscale if it's not already
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % 1. Denoise the image to reduce speckle noise
    % denoisedImg = medfilt2(img, [3 3]); % Use a better denoising method if needed
    denoisedImg = SplitBregmanROF(double(img), .15, 0.001);
    denoisedImg = uint8(denoisedImg);

    % 2. Compute the gradient magnitude
    Gx = double(imfilter(denoisedImg, fspecial('sobel')));
    Gy = double(imfilter(denoisedImg, fspecial('sobel')'));
    gradientMagnitude = sqrt(Gx.^2 + Gy.^2);
%     params.gradientSmoothParam = 0.02;
%     params.gradientEnhaParam = 0.0001;
    gradImg = getGradientMap(double(img), 1, 0.02, 0.0001);
    
    
    % 3. Detect edges and focus on them
    edges = edge(denoisedImg, 'canny');
    edgeGradients = gradientMagnitude .* edges;
    
    % 4. Calculate local contrast in edge regions
    localContrast = stdfilt(denoisedImg, ones(3));
    edgeContrast = mean(localContrast(edges));
    
    % 5. Calculate Structural Similarity Index (SSIM)
    [ssimValue, ~] = ssim(denoisedImg, img);
    
    % 6. Combine metrics into a final quality score
    % qualityScore = (mean(edgeGradients(:)) / std(edgeGradients(:))) * ssimValue * edgeContrast;
    qualityScore = (mean(edgeGradients(:)) / std(edgeGradients(:)));
    
    % Display results (optional)
    % fprintf('Mean Edge Gradient: %.2f\n', mean(edgeGradients(:)));
    %     fprintf('Deviation Edge Gradient: %.2f\n', std(edgeGradients(:)));
    % fprintf('Edge Contrast: %.2f\n', edgeContrast);
    % fprintf('SSIM: %.2f\n', ssimValue);
    % fprintf('Quality Score: %.2f\n', qualityScore);
    
    % % Optional: Plot the images and gradients for visualization
    % figure;
    % subplot(1, 4, 1), imshow(img), title('Original Image');
    % subplot(1, 4, 2), imshow(Gy, []), title('Gradient Magnitude');
    % subplot(1, 4, 3), imshow(gradImg, []), title('My Gradient');
    % subplot(1, 4, 4), imshow(edgeGradients, []), title('Edge Gradients');
end


% function qualityScore = assessOCTQuality(imgPath)
%     % assessOCTQuality - Assess the quality of an OCT image based on gradient magnitude and edge analysis.
%     %
%     % Syntax: qualityScore = assessOCTQuality(imgPath)
%     %
%     % Inputs:
%     %    imgPath - Path to the OCT image.
%     %
%     % Outputs:
%     %    qualityScore - A score reflecting the image quality (higher is better).
%     %
%     % Example: 
%     %    score = assessOCTQuality('path_to_oct_image.png');
% 
%     % Read the image
%     img = imread(imgPath);
%     retinaFolder = fullfile(fileparts(imgPath), 'Signal');
% 
%     % Get the file name and extension from the original image path
%     [~, fileName, ext] = fileparts(imgPath);
% 
%     % Save the ROI mask as an image in the 'Signal' folder
%     retinaFilePath = fullfile(retinaFolder, [fileName, ext]);
% 
%     retinaImg = imread(retinaFilePath);
%     if size(retinaImg, 3) == 3
%         retinaImg = rgb2gray(retinaImg);
%     end
% 
%     retinaMask = false(size(retinaImg));
%     retinaMask(retinaImg > 0) = true;
% 
%      se = strel('disk', 5); % Structuring element for erosion
%     retinaMask = imerode(retinaMask, se);
% 
%     % Convert the image to grayscale if it's not already
%     if size(img, 3) == 3
%         img = rgb2gray(img);
%     end
% 
%     % Apply the Sobel operator to calculate the gradient magnitude
%     Gx = double(imfilter(img, fspecial('sobel')));
%     Gy = double(imfilter(img, fspecial('sobel')'));
%     gradientMagnitude = sqrt(Gx.^2 + Gy.^2);
% 
%     gradientMagnitude = gradientMagnitude .* retinaMask;
% 
%      % 3. Detect edges and focus on them
%     edges = edge(denoisedImg, 'canny');
%     edgeGradients = gradientMagnitude .* edges;
% 
%     noiseLevel = std(gradientMagnitude(:)) / 2; % Estimate noise level
%     gradientMagnitude(gradientMagnitude < noiseLevel) = 0; % Suppress weak edges
% 
% 
%     % Calculate the mean and standard deviation of the gradient magnitudes
%     meanGradient = mean(gradientMagnitude(:));
%     stdGradient = std(gradientMagnitude(:));
% 
%     % Combine the metrics into a single quality score
%     % Here, we consider high mean and low standard deviation as indicators of high quality
%     qualityScore = meanGradient / stdGradient;
% 
%     % Display results (optional)
%     % fprintf('Mean Gradient Magnitude: %.2f\n', meanGradient);
%     % fprintf('Standard Deviation of Gradient Magnitude: %.2f\n', stdGradient);
%     % fprintf('Quality Score: %.2f\n', qualityScore);
% 
%     % Optional: Plot the image and gradient magnitude for visualization
%     figure;
%     subplot(1, 2, 1), imshow(img), title('Original Image');
%     subplot(1, 2, 2), imshow(gradientMagnitude, []), title('Gradient Magnitude');
% end
