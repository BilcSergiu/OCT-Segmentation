function compare_experts(filename)
    % Read the data from the file
    data = readtable(filename);
    
    % Extract the relevant columns
    expert1 = data.Expert1;
    expert2 = data.Expert2;
    expert3 = data.Expert3;
    
    % Remove rows where any expert's evaluation is missing
    validIndices = ~isnan(expert1) & ~isnan(expert2) & ~isnan(expert3);
    expert1 = expert1(validIndices);
    expert2 = expert2(validIndices);
    expert3 = expert3(validIndices);
    
    fprintf('\nExpert evaluations for folder: %s\n', fileparts(filename));
    % Calculate and display distribution of ratings
    display_rating_distribution(expert1, 'Expert 1');
    display_rating_distribution(expert2, 'Expert 2');
    display_rating_distribution(expert3, 'Expert 3');
    
    % Compare the assessments
    compare_two_experts(expert1, expert2, 'Expert 1', 'Expert 2', 'Confusion_Matrix_Expert1_vs_Expert2_NO_Normalized.png');
    compare_two_experts(expert1, expert3, 'Expert 1', 'Expert 3', 'Confusion_Matrix_Expert1_vs_Expert3_NO_Normalized.png');
    compare_two_experts(expert2, expert3, 'Expert 2', 'Expert 3', '');
    
    compare_three_experts(expert1, expert2, expert3);
    
    % Display confusion matrices
    display_confusion_matrix(expert1, expert2, 'Expert 1', 'Expert 2');
    display_confusion_matrix(expert1, expert3, 'Expert 1', 'Expert 3');
    display_confusion_matrix(expert2, expert3, 'Expert 2', 'Expert 3');
end

function display_rating_distribution(expert, label)
    % Calculate and display the distribution of ratings
    excellent = sum(expert == 1);
    acceptable = sum(expert == 2);
    poor = sum(expert == 3);
    
    fprintf('\n%s Rating Distribution:\n', label);
    fprintf('Excellent (1): %d (%.2f%%)\n', excellent, (excellent / length(expert)) * 100);
    fprintf('Acceptable (2): %d (%.2f%%)\n', acceptable, (acceptable / length(expert)) * 100);
    fprintf('Poor (3): %d (%.2f%%)\n', poor, (poor / length(expert)) * 100);
end

function compare_two_experts(expert1, expert2, label1, label2, output_image_path)
    % Calculate agreement
    agreement = mean(expert1 == expert2) * 100;
    
    % Calculate Cohen's Kappa
    kappa = cohen_kappa(expert1, expert2);
    
    % Calculate Pearson Correlation
    corr_val = corr(expert1, expert2);
    
    % Display results
    fprintf('Comparing %s and %s:\n', label1, label2);
    fprintf('Agreement: %.2f%%\n', agreement);
    fprintf('Cohen''s Kappa: %.2f\n', kappa);
    fprintf('Pearson Correlation: %.2f\n\n', corr_val);
    
    % Generate confusion matrix
    conf_matrix = confusionmat(expert1, expert2);
    
    % Normalize confusion matrix
    conf_matrix_normalized = conf_matrix ./ sum(conf_matrix, 2);
    
    % Plot and save the confusion matrix if output_image_path is provided
    if ~isempty(output_image_path)
        figure;
        imagesc(conf_matrix_normalized);
        colormap(flipud(gray));
        colorbar;
        title(sprintf('Normalized Confusion Matrix: %s vs %s', label1, label2));
        xlabel(label2);
        ylabel(label1);
        xticks([1 2 3]);
        xticklabels({'Excellent', 'Acceptable', 'Poor'});
        yticks([1 2 3]);
        yticklabels({'Excellent', 'Acceptable', 'Poor'});
        axis square;
        
        % Save the figure as an image
        saveas(gcf, output_image_path);
        close(gcf);
    end
end

function compare_three_experts(expert1, expert2, expert3)
    fprintf('\nComparing Expert 1, Expert 2, and Expert 3:\n');
    
    % Fleiss' kappa
    ratings = [expert1, expert2, expert3];
    fleissKappa = fleiss_kappa(ratings);
    fprintf('Fleiss'' Kappa: %.2f\n', fleissKappa);
end

function category_agreement(expertA, expertB, labelA, labelB)
    fprintf('\nCategory-wise Agreement between %s and %s:\n', labelA, labelB);
    
    categories = unique([expertA; expertB]);
    for i = 1:length(categories)
        category = categories(i);
        agreement = sum(expertA == category & expertB == category) / sum(expertA == category) * 100;
        fprintf('Category %d Agreement: %.2f%%\n', category, agreement);
    end
end

function display_confusion_matrix(expertA, expertB, labelA, labelB)
    fprintf('\nConfusion Matrix for %s and %s:\n', labelA, labelB);
    confMat = confusionmat(expertA, expertB);
    disp(confMat);
    
    % Display normalized confusion matrix
    fprintf('\nNormalized Confusion Matrix for %s and %s:\n', labelA, labelB);
    confMatNorm = confMat ./ sum(confMat, 2);
    disp(confMatNorm);
end

function kappa = cohen_kappa(expertA, expertB)
    % Calculate Cohen's Kappa
    n = length(expertA);
    observed_agreement = sum(expertA == expertB) / n;
    
    % Expected agreement
    unique_labels = unique([expertA; expertB]);
    pA = histcounts(expertA, [unique_labels; max(unique_labels)+1]) / n;
    pB = histcounts(expertB, [unique_labels; max(unique_labels)+1]) / n;
    expected_agreement = sum(pA .* pB);
    
    % Cohen's kappa
    kappa = (observed_agreement - expected_agreement) / (1 - expected_agreement);
end

function kappa = fleiss_kappa(ratings)
    % Calculate Fleiss' Kappa for multiple raters
    [n, k] = size(ratings); % n subjects, k raters
    unique_labels = unique(ratings(:));
    
    % Proportion of all assignments to each category
    p = zeros(1, length(unique_labels));
    for i = 1:length(unique_labels)
        p(i) = sum(ratings(:) == unique_labels(i)) / (n * k);
    end
    
    % Proportion of raters who assigned each category for each subject
    P = zeros(n, 1);
    for i = 1:n
        count = histcounts(ratings(i, :), [unique_labels; max(unique_labels)+1]);
        P(i) = sum(count .^ 2) - k;
        P(i) = P(i) / (k * (k - 1));
    end
    
    % Mean of P(i)
    P_bar = mean(P);
    
    % Mean of p(i)
    P_e = sum(p .^ 2);
    
    % Fleiss' kappa
    kappa = (P_bar - P_e) / (1 - P_e);
end
