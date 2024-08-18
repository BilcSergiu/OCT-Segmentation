function analyzeQualityCorrelation(fileName, X, normalizationMethod)
    % Load the data from CSV file
    data = readtable(fileName);
    
    % If X is greater than the number of rows in the table, adjust it
    if X > height(data)
        X = height(data);
    end
    
    % Convert Expert labels to numeric values
   expertLabels = data{1:X, 'Expert'};
    expertNumeric = zeros(size(expertLabels));
    expertNumeric(strcmp(expertLabels, 'excelent')) = 3;
    expertNumeric(strcmp(expertLabels, 'good')) = 2;
    expertNumeric(strcmp(expertLabels, 'bad')) = 1;
    
    % Extract the relevant columns (excluding ImageName and Expert)
    metrics = data{1:X, 2:end-1}; % Extracts all numeric columns for the first X rows
    
    % Normalize each metric according to the specified method
    switch normalizationMethod
        case 'minmax'
            % Min-Max Normalization
            normalizedMetrics = (metrics - min(metrics)) ./ (max(metrics) - min(metrics));
        case 'zscore'
            % Z-Score Normalization
            normalizedMetrics = (metrics - mean(metrics)) ./ std(metrics);
        otherwise
            error('Invalid normalization method. Choose ''minmax'' or ''zscore''.');
    end
    
    % Calculate Spearman's correlation between each metric and the expert labels
    correlations = zeros(1, size(normalizedMetrics, 2));
    for i = 1:size(normalizedMetrics, 2)
        correlations(i) = corr(normalizedMetrics(:, i), expertNumeric, 'Type', 'Spearman');
    end
    
    % Bar plot of the correlations
    figure;
    bar(correlations);
    set(gca, 'XTickLabel', data.Properties.VariableNames(2:end-1), 'XTickLabelRotation', 45);
    ylabel('Spearman Correlation with Expert Rating');
    title('Correlation of Metrics with Expert Quality Assessment');
    grid on;
end
