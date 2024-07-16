% Define the path to the input and output folders
inputFolder = 'D:\Licenta\Datasets\OCTDL\OCTDL\ERM\';
outputFolder = fullfile(inputFolder, 'Noisy');

% Create the output folder if it does not exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get a list of all the image files in the input folder
imageFiles = dir(fullfile(inputFolder, '*.jpg')); % Adjust the file extension as needed

% Parameters
numImagesToProcess = 5; % Number of images to process
maxNoiseVariance = 0.2; % Maximum variance for speckle noise

% Determine the number of images to process
numImagesToProcess = min(numImagesToProcess, length(imageFiles));

% Iterate over the specified number of image files
for i = 1:numImagesToProcess
    % Construct the full file path
    inputFile = fullfile(inputFolder, imageFiles(i).name);
    
    % Read the image
    img = imread(inputFile);
    
    % Convert to grayscale if the image is RGB
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Normalize the image to range [0, 1]
    img = im2double(img);
    
    % Generate a random noise variance
    noiseVariance = maxNoiseVariance * rand();
    
    % Randomly decide to keep the original image (with a 10% chance)
    if rand() > 0.1
        % Add speckle noise
        noisyImg = img + sqrt(noiseVariance) * img .* randn(size(img));
        
        % Clip the values to be in the range [0, 1]
        noisyImg = im2uint8(mat2gray(noisyImg));
    else
        % Keep the original image
        noisyImg = im2uint8(img);
    end
    
    % Construct the output file path
    outputFile = fullfile(outputFolder, imageFiles(i).name);
    
    % Save the noisy image
    imwrite(noisyImg, outputFile);
end

disp('Noise addition completed and images saved.');
