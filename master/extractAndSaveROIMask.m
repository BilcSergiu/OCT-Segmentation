function extractAndSaveROIMask(imgPath)
    % Define the parameters structure (hardcoded within the function)
    params = struct();
    params.C = 0.001;
    params.smoothParam = 0.02;
    params.gradientSmoothParam = 0.02;
    params.gradientEnhaParam = 0.0001;
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

    % Load the OCT image
    I = imread(imgPath);

    % Extract the retinal mask using the provided parameters
    ROI_mask = extractRetinaMask(I, params);
     ROI_mask = logical(ROI_mask);

    % Apply the ROI mask to the original image
    maskedImage = I;
    maskedImage(~repmat(ROI_mask, [1, 1, size(I, 3)])) = 0;  % Apply the mask
    % 
    %     figure;
    % imshow(maskedImage);
    % title('Initial image');

    % Create the 'Signal' folder if it doesn't exist
    outputFolder = fullfile(fileparts(imgPath), 'Signal');
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    % Get the file name and extension from the original image path
    [~, fileName, ext] = fileparts(imgPath);

    % Save the ROI mask as an image in the 'Signal' folder
    outputFilePath = fullfile(outputFolder, [fileName, ext]);
    imwrite(maskedImage, outputFilePath);

    % Display a message confirming the file has been saved
    fprintf('ROI mask saved to %s\n', outputFilePath);
end
