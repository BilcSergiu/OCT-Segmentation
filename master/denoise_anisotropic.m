% Define the path to the input and output folders
inputFolder = 'D:\Licenta\Datasets\OCTDL\OCTDL\ERM\';
outputFolder = fullfile(inputFolder, 'Wavelet');

% Get a list of all the image files in the input folder
imageFiles = dir(fullfile(inputFolder, '*.jpg')); % Adjust the file extension as needed

% Limit the processing to the first 10 images
numImagesToProcess = min(1000, length(imageFiles));

% Create the output folder if it does not exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end


% Define parameters for anisotropic diffusion
num_iter = 10; % Number of iterations
kappa = 15;    % Conductance parameter
lambda = 0.15; % Integration constant (usually between 0 and 1)
wavelet = 'db1';                      % Type of wavelet
level = 2;                             % Level of decomposition
K = 10;                                 % Parameter to control thresholding



% Iterate over the first 10 image files
for i = 1:numImagesToProcess
    % Construct the full file path
    inputFile = fullfile(inputFolder, imageFiles(i).name);
    
    % Read the image
    img = imread(inputFile);

    % SplitBregmanRof
    % img = img(:, :, 1);
    % img = double(img);

    
    % Apply the anisotropic diffusion function
    % denoisedImg = anisotropic_diffusion(img, num_iter, kappa, lambda);
    denoisedImg = wavelet_diffusion(img, wavelet, level, K);
    % denoisedImg = SplitBregmanROF(img, 0.15, 0.001);


    % Construct the output file path
    [~, name, ext] = fileparts(imageFiles(i).name);
    outputFile = fullfile(outputFolder, [name ext]);
    fprintf('Processing complete for %s\n', [name ext]);
    % Save the denoised image
    imwrite(uint8(denoisedImg), outputFile); % Convert the image back to uint8 before saving
end

disp('Denoising completed and images saved.');
