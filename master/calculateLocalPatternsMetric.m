function qualityScore = calculateLocalPatternsMetric(imgPath, patchSize)
    % Calculate Local Patterns Metric for OCT Image Quality
    % Inputs:
    %   imagePath - Path to the grayscale OCT image
    %   patchSize - Size of the patches (e.g., [32 32])
    % Output:
    %   qualityScore - Quality score based on LBP variance and entropy

    image = imread(imgPath);
    
    % Convert the image to grayscale if it's not already
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    % Get the image size
    [rows, cols] = size(image);

    % Calculate the number of patches
    numPatchesX = floor(cols / patchSize(2));
    numPatchesY = floor(rows / patchSize(1));

    % Initialize arrays to hold LBP histograms and patch quality metrics
    lbpHistograms = cell(numPatchesY, numPatchesX);
    patchVariance = zeros(numPatchesY, numPatchesX);
    patchEntropy = zeros(numPatchesY, numPatchesX);

    % Loop over patches
    for i = 1:numPatchesY
        for j = 1:numPatchesX
            % Extract the patch
            patch = image((i-1)*patchSize(1)+1:i*patchSize(1), ...
                          (j-1)*patchSize(2)+1:j*patchSize(2));

            % Compute LBP for the patch
            lbpImage = extractLBPFeatures(patch, 'Upright', false);

            % Calculate the histogram of LBP patterns
            lbpHist = histcounts(lbpImage, 'Normalization', 'probability');
            lbpHistograms{i, j} = lbpHist;

            % Calculate variance and entropy for the LBP histogram
            patchVariance(i, j) = var(lbpHist);
            patchEntropy(i, j) = -sum(lbpHist .* log2(lbpHist + eps)); % Adding eps to avoid log(0)
        end
    end

    % Calculate overall variance and entropy across all patches
    overallVariance = mean(patchVariance(:));
    overallEntropy = mean(patchEntropy(:));

    % Compute the quality score (e.g., a simple average of variance and entropy)
    qualityScore = overallVariance + overallEntropy;

    % % % Display the results
    % fprintf('OCT Image Quality Analysis for %s:\n', imgPath);
    % fprintf('Overall Variance: %f\n', overallVariance);
    % fprintf('Overall Entropy: %f\n', overallEntropy);
    % fprintf('Quality Score: %f\n', qualityScore);
end
