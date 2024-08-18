function [bestIntervalOverall, bestAccuracyOverall] = calculateBestOverallIntervals(filename)
    % Load the first 100 rows from the CSV file
    data = readtable(filename);
    data = data(1:100, :);

    % Convert Expert annotations to numeric values
    expertNumeric = grp2idx(data.Expert); % 1=Excellent, 2=Good, 3=Bad
    
    % Initialize variables to store intervals and accuracy
    metrics = data.Properties.VariableNames(2:end-1); % excluding ImageName and Expert columns
    bestIntervalOverall = struct();
    bestAccuracyOverall = struct();
    
    % Iterate through each metric
    for i = 1:length(metrics)
        metricName = metrics{i};
        metricValues = data.(metricName);
        
        % Generate possible thresholds
        thresholds = linspace(min(metricValues), max(metricValues), 100);
        
        % Initialize variables to store the best intervals and their accuracy
        bestInterval = [0, 0, 0];
        bestAccuracy = 0;
        
        % Iterate through all possible combinations of intervals
        for t1 = thresholds
            for t2 = thresholds
                for t3 = thresholds
                    if t1 < t2 && t2 < t3
                        % Define intervals
                        intervalPoor = metricValues <= t1;
                        intervalGood = (metricValues > t1) & (metricValues <= t2);
                        intervalExcellent = metricValues > t2;
                        
                        % Create a combined prediction array
                        predictions = zeros(size(expertNumeric));
                        predictions(intervalExcellent) = 1; % Predict Excellent
                        predictions(intervalGood) = 2; % Predict Good
                        predictions(intervalPoor) = 3; % Predict Bad
                        
                        % Calculate overall accuracy
                        overallAccuracy = sum(predictions == expertNumeric) / length(expertNumeric);
                        
                        % Update the best intervals and accuracy if this is the best so far
                        if overallAccuracy > bestAccuracy
                            bestAccuracy = overallAccuracy;
                            bestInterval = [t1, t2, t3];
                        end
                    end
                end
            end
        end
        
        % Store the best interval and accuracy for this metric
        bestIntervalOverall.(metricName) = bestInterval;
        bestAccuracyOverall.(metricName) = bestAccuracy;
        
        % Display the results for this metric
        disp(['Metric: ', metricName]);
        disp(['Best Overall Interval (Poor, Good, Excellent): ', num2str(bestInterval)]);
        disp(['Best Overall Accuracy: ', num2str(bestAccuracy)]);
        disp('---');
    end
end
