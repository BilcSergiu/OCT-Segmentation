function plotNormalizedQualityMetrics(fileName, X, normalizationMethod)
    % Load the data from CSV file
    data = readtable(fileName);
    
    % If X is greater than the number of rows in the table, adjust it
    if X > height(data)
        X = height(data);
    end
    
    % Extract the relevant columns (excluding ImageName)
    metrics = data{1:X, 2:end}; % Extracts all numeric columns for the first X rows
    
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
    
    % Box Plot of normalized metrics
    figure;
    boxplot(normalizedMetrics, 'Labels', data.Properties.VariableNames(2:end));
    title(['Normalized Quality Metrics (' normalizationMethod ')']);
    ylabel('Normalized Value');
    xlabel('Metrics');
    grid on;
    
    % Individual Box Plots for each metric
    numMetrics = size(normalizedMetrics, 2);
    figure;
    for i = 1:numMetrics
        subplot(ceil(numMetrics/2), 2, i);
        boxplot(normalizedMetrics(:, i));
        title(data.Properties.VariableNames{i+1});
        ylabel('Normalized Value');
        grid on;
    end
    
    % Correlation Analysis
    correlationMatrix = corr(normalizedMetrics); % Calculate the Pearson correlation coefficients
    
    % Plotting the Correlation Matrix as a heatmap
    figure;
    heatmap(data.Properties.VariableNames(2:end), data.Properties.VariableNames(2:end), correlationMatrix, ...
        'ColorbarVisible', 'on', 'Colormap', parula);
    title('Correlation Matrix of Quality Metrics');
    xlabel('Metrics');
    ylabel('Metrics');
    
    % Principal Component Analysis (PCA)
    [coeff, score, latent, ~, explained] = pca(normalizedMetrics);
    
    % Plotting the first two principal components
    figure;
    scatter(score(:,1), score(:,2), 50, 'filled');
    xlabel(['PC1 (' num2str(explained(1), '%.2f') '% variance)']);
    ylabel(['PC2 (' num2str(explained(2), '%.2f') '% variance)']);
    title('PCA: First Two Principal Components');
    grid on;
    
    % Plotting the explained variance
    figure;
    pareto(explained);
    xlabel('Principal Component');
    ylabel('Variance Explained (%)');
    title('Explained Variance by Principal Components');
    grid on;
    
    % Radar/Spider Plot using custom radarPlot function
    % Plotting a radar chart for a few selected images (you can choose a different number or specific images)
    selectedImages = [1, 5, 10]; % Example indices of images to plot
    for i = 1:length(selectedImages)
        figure;
        radarPlot(normalizedMetrics(selectedImages(i), :), data.Properties.VariableNames(2:end));
        title(['Radar Plot for Image ' num2str(selectedImages(i))]);
    end
    
    % Heatmap of normalized metrics
    figure;
    heatmap(1:X, data.Properties.VariableNames(2:end), normalizedMetrics');
    title(['Heatmap of Normalized Quality Metrics (' normalizationMethod ')']);
    xlabel('Image Index');
    ylabel('Metrics');
    colorbar;
end

function radarPlot(data, labels)
    % This function creates a simple radar plot
    % data: 1xN array of data to be plotted
    % labels: 1xN cell array of labels for each axis
    
    numVars = length(data);
    angles = linspace(0, 2*pi, numVars + 1);
    
    % Close the loop on the data
    data = [data data(1)];
    
    % Create the plot
    polarplot(angles, data, '-o', 'LineWidth', 2);
    
    % Add the labels
    ax = gca;
    ax.ThetaTickLabel = labels;
    ax.ThetaTick = rad2deg(angles(1:end-1));
    title('Radar Plot');
end
