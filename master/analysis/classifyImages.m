function classifyImages(filename, outputFilename)
    % Load the CSV file
    data = readtable(filename);
    data = data(1:100, :);  % Assuming we're still working with the first 100 rows

    % Convert Expert annotations to numeric values
    expertNumeric = grp2idx(data.Expert); % 1=Excellent, 2=Good, 3=Bad
    
    % Initialize variables to store mean values, intervals, and accuracy
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    
    % Initialize a cell array to store the classification results
    results = cell(height(data), length(metrics) + 1);  % +1 for the image name
    results(:, 1) = data.ImageName;  % Include the image names

    % Iterate through each metric
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        % Generate possible thresholds
        thresholds = linspace(min(metricValues), max(metricValues), 100);
        
        % Initialize variables to store the best intervals and their accuracy
        bestIntervalPoor = [0, 0];
        bestIntervalAcceptable = [0, 0];
        bestIntervalExcellent = [0, 0];
        bestAccuracyOverall = 0;
        
        % Iterate through pairs of thresholds to define intervals
        for t1 = thresholds
            for t2 = thresholds
                for t3 = thresholds
                    if t1 < t2 && t2 < t3
                        % Define intervals for "Poor", "Acceptable", "Excellent"
                        intervalPoor = metricValues <= t1;
                        intervalAcceptable = (metricValues > t1) & (metricValues <= t2);
                        intervalExcellent = metricValues > t2;
                        
                        % Create a combined prediction array
                        predictions = zeros(size(expertNumeric));
                        predictions(intervalExcellent) = 1; % Predict Excellent
                        predictions(intervalAcceptable) = 2; % Predict Good
                        predictions(intervalPoor) = 3; % Predict Bad
                        
                        % Calculate overall accuracy
                        overallAccuracy = sum(predictions == expertNumeric) / length(expertNumeric);
                        
                        % Update the best intervals and accuracy if this is the best so far
                        if overallAccuracy > bestAccuracyOverall
                            bestAccuracyOverall = overallAccuracy;
                            bestIntervalPoor = [min(metricValues), t1];
                            bestIntervalAcceptable = [t1, t2];
                            bestIntervalExcellent = [t2, t3];
                        end
                    end
                end
            end
        end
        
        % Classify images based on the best intervals
        for j = 1:height(data)
            if metricValues(j) <= bestIntervalPoor(2)
                results{j, i + 1} = 'Poor';
            elseif metricValues(j) > bestIntervalPoor(2) && metricValues(j) <= bestIntervalAcceptable(2)
                results{j, i + 1} = 'Acceptable';
            elseif metricValues(j) > bestIntervalAcceptable(2)
                results{j, i + 1} = 'Excellent';
            end
        end
    end
    
    % Convert results to a table
    resultTable = cell2table(results, 'VariableNames', ['ImageName', metrics]);
    
    % Write the table to a CSV file
    writetable(resultTable, outputFilename);
    
    % Display a message indicating the file was written successfully
    disp(['Classification results have been written to ', outputFilename]);
end
