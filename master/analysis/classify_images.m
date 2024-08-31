function [accuracy, kappa, predictions, counts, precision, recall, f1_score] = classify_images(filename, thresholds)
    % Input: filename - the name of the file containing the data
    %        thresholds - a vector of thresholds for each metric
    % Output: accuracy - accuracy of classification for each metric
    %         kappa - kappa coefficient for each metric
    %         predictions - the predicted category for each image per metric
    %         counts - structure containing various classification counts
    %         precision - precision for poor classification
    %         recall - recall for poor classification
    %         f1_score - F1 score for poor classification
    
    % Read the data from the file
    data = readtable(filename);
    
    % Extract the metrics and the expert labels
    metrics = data{:, 2:end-4};  % All columns except 'ImageName' and 'Expert'
    expert_labels = data.Expert; % The 'Expert' column
    
    % Convert expert_labels: Convert all 2's (Good) to 1's (Excellent/Good)
    expert_labels(expert_labels == 2) = 1;
    
    % Number of metrics
    num_metrics = size(metrics, 2);
    
    % Initialize accuracy, kappa, precision, recall, and F1 score vectors
    accuracy = zeros(1, num_metrics);
    kappa = zeros(1, num_metrics);
    precision = zeros(1, num_metrics);
    recall = zeros(1, num_metrics);
    f1_score = zeros(1, num_metrics);
    
    counts(num_metrics) = struct('excellent_good_by_expert', 0, 'excellent_good_by_metric', 0, ...
                                  'poor_by_expert', 0, 'poor_by_metric', 0, ...
                                  'poor_by_metric_not_expert', 0, 'poor_by_expert_not_metric', 0, ...
                                  'correct_poor_by_both', 0, 'correct_good_by_both', 0);
    
    % Initialize prediction matrix
    predictions = zeros(size(metrics)); % Each column will hold predictions for each metric
    
    % Iterate over each metric to apply the provided thresholds
    for i = 1:num_metrics
        metric_name = data.Properties.VariableNames{i+1}; % Adjusting index to match metric names
        
        if strcmp(metric_name, 'SS') % Special handling for SS
            % Apply threshold: classify as 1 (Excellent/Good) if below threshold, else 3 (Poor)
            predictions(:, i) = (metrics(:, i) <= thresholds(i)) * 1 + (metrics(:, i) > thresholds(i)) * 3;
        else
            % Apply threshold: classify as 1 (Excellent/Good) if above threshold, else 3 (Poor)
            predictions(:, i) = (metrics(:, i) > thresholds(i)) * 1 + (metrics(:, i) <= thresholds(i)) * 3;
        end
        
        % Count the number of "Excellent/Good" and "Poor" classifications by the metric
        counts(i).excellent_good_by_metric = sum(predictions(:, i) == 1);
        counts(i).poor_by_metric = sum(predictions(:, i) == 3);
        
        % Count the number of "Excellent/Good" and "Poor" classifications by the expert
        counts(i).excellent_good_by_expert = sum(expert_labels == 1);
        counts(i).poor_by_expert = sum(expert_labels == 3);
        
        % Count mismatches: Poor by metric but not by expert, and vice versa
        counts(i).poor_by_metric_not_expert = sum((predictions(:, i) == 3) & (expert_labels ~= 3));
        counts(i).poor_by_expert_not_metric = sum((expert_labels == 3) & (predictions(:, i) ~= 3));
        
        % Count correct "Poor" and "Excellent/Good" classifications by both metric and expert
        counts(i).correct_poor_by_both = sum((predictions(:, i) == 3) & (expert_labels == 3));
        counts(i).correct_good_by_both = sum((predictions(:, i) == 1) & (expert_labels == 1));
        
        % Compare predictions with expert labels
        correct_classifications = (predictions(:, i) == expert_labels);
        
        % Calculate accuracy for this metric
        accuracy(i) = sum(correct_classifications) / length(expert_labels) * 100;
        
        % Calculate kappa coefficient
        kappa(i) = compute_kappa(expert_labels, predictions(:, i));
        
        % Calculate precision, recall, and F1 score for "Poor" classification
        if counts(i).poor_by_metric > 0
            precision(i) = counts(i).correct_poor_by_both / counts(i).poor_by_metric;
        else
            precision(i) = NaN; % Avoid division by zero
        end
        
        if counts(i).poor_by_expert > 0
            recall(i) = counts(i).correct_poor_by_both / counts(i).poor_by_expert;
        else
            recall(i) = NaN; % Avoid division by zero
        end
        
        if ~isnan(precision(i)) && ~isnan(recall(i)) && (precision(i) + recall(i)) > 0
            f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
        else
            f1_score(i) = NaN; % Avoid division by zero
        end
    end
    
    % Display accuracy, kappa, precision, recall, F1 score, and counts for each metric
    metricNames = data.Properties.VariableNames(2:end-4);  % Get metric names
    for i = 1:num_metrics
        fprintf('Metric: %s\n', metricNames{i});
        fprintf('  Accuracy: %.2f%%\n', accuracy(i));
        fprintf('  Kappa Coefficient: %.2f\n', kappa(i));
        fprintf('  Precision for Poor: %.2f\n', precision(i));
        fprintf('  Recall for Poor: %.2f\n', recall(i));
        fprintf('  F1 Score for Poor: %.2f\n', f1_score(i));
        fprintf('  Number of Excellent/Good by Expert: %d\n', counts(i).excellent_good_by_expert);
        fprintf('  Number of Excellent/Good by Metric: %d\n', counts(i).excellent_good_by_metric);
        fprintf('  Number of Poor by Expert: %d\n', counts(i).poor_by_expert);
        fprintf('  Number of Poor by Metric: %d\n', counts(i).poor_by_metric);
        fprintf('  Poor by Metric but not by Expert: %d\n', counts(i).poor_by_metric_not_expert);
        fprintf('  Poor by Expert but not by Metric: %d\n', counts(i).poor_by_expert_not_metric);
        fprintf('  Correctly Classified Poor by Both: %d\n', counts(i).correct_poor_by_both);
        fprintf('  Correctly Classified Excellent/Good by Both: %d\n\n', counts(i).correct_good_by_both);
    end
end

function kappa = compute_kappa(true_labels, predicted_labels)
    % Create confusion matrix
    conf_matrix = confusionmat(true_labels, predicted_labels);
    
    % Total number of samples
    n = sum(conf_matrix(:));
    
    % Calculate the observed accuracy
    p0 = sum(diag(conf_matrix)) / n;
    
    % Calculate the expected accuracy
    row_marginals = sum(conf_matrix, 2) / n;
    col_marginals = sum(conf_matrix, 1) / n;
    pe = sum(row_marginals .* col_marginals);
    
    % Calculate kappa
    kappa = (p0 - pe) / (1 - pe);
end
