% Define the path to the input and output folders
inputFolder = 'D:\Licenta\Datasets\OCTDL\OCTDL\ERM\';
outputFolder = fullfile(inputFolder, 'Denoised');
% Limit the processing to the first 10 images
numImagesToProcess = min(5, length(imageFiles));

% Create the output folder if it does not exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get a list of all the image files in the input folder
imageFiles = dir(fullfile(inputFolder, '*.jpg')); % Adjust the file extension as needed

% Define parameters for anisotropic diffusion
num_iter = 10; % Number of iterations
kappa = 10;    % Conductance parameter
lambda = 0.1; % Integration constant (usually between 0 and 1)

% Iterate over the first 10 image files
for i = 1:numImagesToProcess
    % Construct the full file path
    inputFile = fullfile(inputFolder, imageFiles(i).name);
    
    % Read the image
    img = imread(inputFile);
    
    % Apply the anisotropic diffusion function
    denoisedImg = anisotropic_diffusion(img, num_iter, kappa, lambda);
    
    % Construct the output file path
    [~, name, ext] = fileparts(imageFiles(i).name);
    outputFile = fullfile(outputFolder, [name ext]);
    
    % Save the denoised image
    imwrite(uint8(denoisedImg), outputFile); % Convert the image back to uint8 before saving
end

disp('Denoising completed and images saved.');
