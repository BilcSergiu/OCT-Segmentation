function pearsonCorrelations = calcPearsonCorrelation(filename)
    % Load the entire table from the CSV file
    data = readtable(filename);
    
    % Select only the first 100 rows
    data = data(~ismissing(data.Expert), :);
    
    % Convert Expert annotations to numeric values
    % expertNumeric = grp2idx(data.Expert);
    expertNumeric = data.Expert;

    % Initialize results
    pearsonCorrelations = struct();
    
    % Calculate Pearson correlation for each metric
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        % Ensure the column is numeric
        if isnumeric(metricValues)
            r = corr(metricValues, expertNumeric, 'Type', 'Pearson');
            pearsonCorrelations.(metricName) = r;
        else
            pearsonCorrelations.(metricName) = NaN; % Handle non-numeric columns
        end
    end
    
    % Display results
    disp('Pearson Correlations:');
    disp(pearsonCorrelations);
end
