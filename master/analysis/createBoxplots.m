function createBoxplots(filename)
    % Load data from CSV file
    data = readtable(filename);

     % Select only the first 100 rows
   data = data(~ismissing(data.Expert), :);
    
    % Convert Expert annotations to numeric values
    expertNumeric = grp2idx(data.Expert);
    
    % Get list of metrics
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    
    % Create boxplots for each metric
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        figure;
        boxplot(metricValues, expertNumeric);
        title(['Boxplot of ', metricName, ' by Expert Rating']);
        xlabel('Expert Rating');
        ylabel(metricName);
    end
end
