function plotQualityMetrics(fileName, X)
    % Load the data from CSV file
    data = readtable(fileName);
  
    % If X is greater than the number of rows in the table, adjust it
    if X > height(data)
        X = height(data);
    end
    
    % Create a figure window
    figure;
    
    % Top subplot: QI values (bar graph)
    subplot(2, 1, 1); % 2 rows, 1 column, 1st subplot
    bar(data.QI(1:X)); % Plot only the first X QI values
    set(gca, 'XTickLabel', data.ImageName(1:X), 'XTick', 1:X);
    xtickangle(45); % Rotate the x-axis labels for better readability
    xlabel('Image Name');
    ylabel('Quality Index (QI)');
    title(['QI Values for First ', num2str(X), ' Images']);
    
    % Bottom subplot: SNR_OLD and SNR_NEW values (line graph)
    subplot(2, 1, 2); % 2 rows, 1 column, 2nd subplot
    plot(1:X, data.SNR_OLD(1:X), '-o', 'DisplayName', 'SNR OLD'); % Plot SNR_OLD values as a line graph
    hold on;
    plot(1:X, data.SNR_NEW(1:X), '-s', 'DisplayName', 'SNR NEW'); % Plot SNR_NEW values as a line graph
    hold off;
    set(gca, 'XTickLabel', data.ImageName(1:X), 'XTick', 1:X);
    xtickangle(45); % Rotate the x-axis labels for better readability
    xlabel('Image Name');
    ylabel('SNR');
    title(['SNR (OLD & NEW) Values for First ', num2str(X), ' Images']);
    legend show; % Display the legend to differentiate the lines
    
    % Adjust the figure window size
    set(gcf, 'Position', [100, 100, 1200, 800]); % Width x Height

end
