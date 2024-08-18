function computeKappaScores(filename, intervals)
    % Load the CSV file
    data = readtable(filename);
    data = data(~ismissing(data.Expert), :);  % Filter rows with missing Expert values
    
    % Convert Expert annotations to numeric values
    expertNumeric = grp2idx(data.Expert); % 1=Excellent, 2=Good, 3=Bad
    
    % Initialize variables to store kappa scores
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    kappaScores = struct();
    
    % Iterate through each metric
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        % Classify images based on provided intervals
        predictions = zeros(size(metricValues));
        for j = 1:length(metricValues)
            if metricValues(j) <= intervals(i, 1)
                predictions(j) = 3;  % Predict Bad
            elseif metricValues(j) > intervals(i, 1) && metricValues(j) <= intervals(i, 2)
                predictions(j) = 2;  % Predict Good
            elseif metricValues(j) > intervals(i, 2)
                predictions(j) = 1;  % Predict Excellent
            end
        end
        
        % Compute Kappa score for each group
        kappaScores.(metricName).Overall = computeKappa(expertNumeric, predictions);
        kappaScores.(metricName).Excellent = computeKappa(expertNumeric == 1, predictions == 1);
        kappaScores.(metricName).Good = computeKappa(expertNumeric == 2, predictions == 2);
        kappaScores.(metricName).Bad = computeKappa(expertNumeric == 3, predictions == 3);
        
        % Display Kappa scores for this metric
        disp(['Metric: ', metricName]);
        disp(['Overall Kappa: ', num2str(kappaScores.(metricName).Overall)]);
        disp(['Kappa for Excellent: ', num2str(kappaScores.(metricName).Excellent)]);
        disp(['Kappa for Good: ', num2str(kappaScores.(metricName).Good)]);
        disp(['Kappa for Bad: ', num2str(kappaScores.(metricName).Bad)]);
        disp('---');
    end
end

function kappa = computeKappa(expertLabels, predictions)
    % Confusion matrix
    confMat = confusionmat(expertLabels, predictions);
    
    % Compute observed accuracy
    po = sum(diag(confMat)) / sum(confMat(:));
    
    % Compute expected accuracy by chance
    pe = sum(sum(confMat, 1) .* sum(confMat, 2)) / (sum(confMat(:))^2);
    
    % Compute Cohen's Kappa
    kappa = (po - pe) / (1 - pe);
end
