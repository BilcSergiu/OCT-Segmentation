function anovaResults = performANOVA(filename)
    % Load data from CSV file
    data = readtable(filename);

     % Select only the first 100 rows
    data = data(1:99, :);
    
    % Convert Expert annotations to numeric values
    expertNumeric = grp2idx(data.Expert);
    
    % Initialize results
    anovaResults = struct();
    
    % Get list of metrics
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    
    % Perform ANOVA for each metric
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        % ANOVA
        [p, tbl, stats] = anova1(metricValues, expertNumeric, 'off');
        anovaResults.(metricName) = struct('pValue', p, 'anovaTable', tbl, 'stats', stats);
        
        % Display result
        disp(['ANOVA results for ', metricName, ':']);
        disp(['p-value: ', num2str(p)]);
    end
end
