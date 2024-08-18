% Script to process all images in a directory and compute SNR_dB for each

% Specify the directory containing the images
imageDir = 'D:\Licenta\Datasets\OCTDL\OCTDL\DME\Wavelet\'; % Change this path to your directory

% Get a list of all image files in the directory
imageFiles = dir(fullfile(imageDir, '*.jpg')); % Assuming all images are .jpg, modify as needed

% Initialize a cell array to store the results
results = cell(length(imageFiles), 14);

% Loop over each image file in the directory
for i = 1:length(imageFiles)
    % Get the full path to the image file
    imgPath = fullfile(imageDir, imageFiles(i).name);

    % extractAndSaveROIMask(imgPath);
    

    fprintf('Processing for %s \n', imageFiles(i).name);
    % % Calculate SNR and SNR_dB using the previously defined function
    [QI] = calculateQI(imgPath);
    [snr_c, snr_c_db, CNR1, QSNR1] = calculateSNR1(imgPath);
    [snr, snr_db, CNR2, QSNR2] = calculateSNR2(imgPath, 500);
    [SD, SS] = calculateSignalDeviation(imgPath);
    [entropy_value, sharpness, brisque_score, psnr_value] = calculateImageMetrics(imgPath, 500);
    % [QS] = calculateGradientMetric(imgPath);
    % [qualityScore] = calculateLocalPatternsMetric(imgPath, [64 64]);
    % disp(['QS: ',imageFiles(i).name, num2str(QS)]); 
    %     disp(['SD:  ', num2str(SD)]);
    % disp(['SS:  ', num2str(SS)]);

    % % Store the image name and SNR_dB value in the results cell array
    results{i, 1} = imageFiles(i).name;
    results{i, 2} = round(QI, 2);
    results{i, 3} = round(snr_c_db, 2);
    results{i, 4} = round(CNR1, 2);
    results{i, 5} = round(QSNR1, 2);
    results{i, 6} = round(snr_db, 2);
    results{i, 7} = round(CNR2, 2);
    results{i, 8} = round(QSNR2, 2);
    results{i, 9} = round(entropy_value, 2);
    results{i, 10} = round(sharpness, 2);
    results{i, 11} = round(brisque_score, 2);
    results{i, 12} = round(psnr_value, 2);
    results{i, 13} = round(SD, 2);
    results{i, 14} = round(SS, 2);  
    % results{i, 15} = round(QS, 2);  
    % results{i, 16} = round(qualityScore, 2);
end

% Convert the results cell array to a table
resultsTable = cell2table(results, 'VariableNames', {'ImageName', 'QI', 'SNR_OLD', 'CNR1', 'QSNR1', 'SNR_NEW','CNR2','QSNR2', 'Entropy', 'Sharpness', 'BrisqueScore', 'PSNR', 'SD', 'SS'});


% Specify the output CSV file name
outputCsvFile = fullfile(imageDir, 'quality-duminica-v2.csv');

% Write the table to a CSV file
writetable(resultsTable, outputCsvFile);

% Display a message indicating that processing is complete
fprintf('Processing complete. Results saved to %s\n', outputCsvFile);