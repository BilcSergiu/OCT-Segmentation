% Define the paths to the input folders
noisyFolder = 'D:\Licenta\Datasets\OCTDL\OCTDL\ERM\Noisy';
denoisedFolder = 'D:\Licenta\Datasets\OCTDL\OCTDL\ERM\Denoised';

% Get a list of all the image files in the noisy folder
noisyFiles = dir(fullfile(noisyFolder, '*.jpg')); % Adjust the file extension as needed

% Iterate over each pair of images
for i = 1:length(noisyFiles)
    % Construct the full file paths
    noisyFile = fullfile(noisyFolder, noisyFiles(i).name);
    denoisedFile = fullfile(denoisedFolder, noisyFiles(i).name);
    
    % Read the images
    noisyImg = imread(noisyFile);
    denoisedImg = imread(denoisedFile);
    
    % Convert to grayscale if necessary
    if size(noisyImg, 3) == 3
        noisyImg = rgb2gray(noisyImg);
    end
    if size(denoisedImg, 3) == 3
        denoisedImg = rgb2gray(denoisedImg);
    end
  
    % Calculate Quality Index (QI)
    QI = calculateQI(noisyImg);
        
    % Calculate other image quality metrics
    [entropy_value, sharpness, brisque_score, psnr_value, ssim_value, snr_value] = calculateImageMetrics(noisyImg, denoisedImg);
    
    % Write XML metadata
    writeXMLMetadata(noisyFiles(i).name, QI, entropy_value, sharpness, brisque_score, psnr_value, ssim_value, snr_value, noisyFolder);
    
    disp(['Processed and saved metadata for ', noisyFiles(i).name]);
end
