% function compare_metrics_and_expert_assesment(parentFolder)
%     % Define the subfolders
%     subfolders = {'Anisotropic', 'Wavelet', 'SplitBregmanROF'};
% 
%     % Read the parent folder data
%     parentFile = fullfile(parentFolder, 'quality-duminica-v2.csv');
%     parentData = readtable(parentFile);
% 
%     % Calculate the mean of each metric in the parent folder
%     % parentMeans = calculate_means(parentData);
% 
% 
%     % Remove the 'Expert' column from parentData for comparison
%     parentDataNoExpert = parentData(:, 1:end-1);  % Assumes 'Expert' is the last column
% 
%     % Calculate the mean of each metric in the parent folder
%     parentMeans = calculate_means(parentDataNoExpert);
%     disp(parentMeans);
%     % Initialize structures to hold the differences and comparisons
%     differences = struct();
%     expertGroups = struct();
% 
%     % Loop over each subfolder
%     for i = 1:length(subfolders)
%         subfolder = subfolders{i};
%         subFile = fullfile(parentFolder, subfolder, 'quality-duminica-v2.csv');
%         subData = readtable(subFile);
% 
%         % Calculate the mean of each metric in the subfolder
%         subMeans = calculate_means(subData);
% 
%         % Compute the differences between subfolder means and parent folder means
%         differences.(subfolder) = subMeans - parentMeans;
% 
%         disp(subfolders{i});
%         disp(differences.(subfolder));
%         % Group the files based on the Expert assessments in the parent folder
%         expertGroups.(subfolder) = group_by_expert(parentData, subData);
% 
%         disp('EXPERT');
%          disp(expertGroups.(subfolder));
%     end
% 
%     % Display the differences in detail
%     disp('Differences between means of metrics in subfolders compared to the parent folder:');
%     for i = 1:length(subfolders)
%         subfolder = subfolders{i};
%         disp(['--- ', subfolder, ' ---']);
%         disp(array2table(differences.(subfolder), 'VariableNames', parentMeans.Properties.VariableNames));
%     end
% 
%     % Display the expert-based comparisons in detail
%     disp('Expert-based comparisons:');
%     for i = 1:length(subfolders)
%         subfolder = subfolders{i};
%         disp(['--- ', subfolder, ' ---']);
%         expertStruct = expertGroups.(subfolder);
%         expertLevels = fieldnames(expertStruct);
%         for j = 1:length(expertLevels)-1
%             level = expertLevels{j};
%             disp(['Expert Level: ', num2str(level)]);
%             disp('Parent Means:');
%             disp(expertStruct.(level).ParentMeans);
%             disp('Subfolder Means:');
%             disp(expertStruct.(level).SubMeans);
%             disp('Diffenrece Means:');
%             disp(expertStruct.(level).SubMeans - expertStruct.(level).ParentMeans(:, 1:end-1));
%         end
%     end
% end
% 
% function means = calculate_means(data)
%     % Calculate the mean of each column (excluding the ImageName column)
%     means = varfun(@mean, data(:, 2:end));
% end
% 
% function groupedData = group_by_expert(parentData, subData)
%     % Extract the unique expert quality levels
%     expertLevels = unique(parentData.Expert);
% 
%     % Initialize a struct to hold grouped data
%     groupedData = struct();
% 
%     % Loop over each expert quality level
%     for i = 1:length(expertLevels)
%         level = expertLevels(i);
%         % Filter the parent and subData based on the expert level
%         filterIdx = parentData.Expert == level;
%         parentFiltered = parentData(filterIdx, :);
%         subFiltered = subData(filterIdx, :);
% 
%         % Calculate means for this group
%         groupedData.(sprintf('Expert_Level_%d', level)) = struct();
%         groupedData.(sprintf('Expert_Level_%d', level)).ParentMeans = calculate_means(parentFiltered);
%         groupedData.(sprintf('Expert_Level_%d', level)).SubMeans = calculate_means(subFiltered);
%     end
% end

% ----------------------------------------------------------------------------


% function compare_metrics_and_expert_assessment(parentFolder)
%     % Define the subfolders
%     subfolders = {'Anisotropic', 'Wavelet', 'SplitBregmanROF'};
%     excelFileName = fullfile(parentFolder, 'OCT_Analysis_Results.xlsx');
% 
%     % Read the parent folder data
%     parentFile = fullfile(parentFolder, 'quality-duminica-v2.csv');
%     parentData = readtable(parentFile);
% 
%     % Remove the 'Expert' column from parentData for comparison
%     parentDataNoExpert = parentData(:, 1:end-1);  % Assumes 'Expert' is the last column
% 
%     % Calculate the mean of each metric in the parent folder
%     parentMeans = calculate_means(parentDataNoExpert);
% 
%     % Initialize a table to hold all results
%     combinedTable = table();
% 
%     % Loop over each subfolder
%     for i = 1:length(subfolders)
%         subfolder = subfolders{i};
%         subFile = fullfile(parentFolder, subfolder, 'quality-duminica-v2.csv');
%         subData = readtable(subFile);
% 
%         % Calculate the mean of each metric in the subfolder
%         subMeans = calculate_means(subData);
% 
%         % Ensure both tables have the same variables by removing 'Expert' column from parentMeans
%         % and then compute the differences between subfolder means and parent folder means
%         subMeans.Properties.VariableNames = parentMeans.Properties.VariableNames;  % Ensure variable names match
%         differences = subMeans.Variables - parentMeans.Variables;
% 
%         % Convert differences to table and add a column for the subfolder name
%         diffTable = array2table(differences, 'VariableNames', parentMeans.Properties.VariableNames);
%         diffTable.Subfolder = repmat({subfolder}, height(diffTable), 1);
%         diffTable.Type = repmat({'Difference'}, height(diffTable), 1);
% 
%         % Add differences to the combined table
%         combinedTable = [combinedTable; diffTable];
% 
%         % Group the files based on the Expert assessments in the parent folder
%         expertGroups = group_by_expert(parentData, subData, subfolder);
% 
%         % Append the expert-based comparisons to the combined table
%         for j = 1:length(expertGroups)
%             expertLevel = expertGroups(j).ExpertLevel;
%             parentMeansTable = expertGroups(j).ParentMeans;
%             parentMeansTable.Subfolder = repmat({subfolder}, height(parentMeansTable), 1);
%             parentMeansTable.Type = repmat({['Parent Means - Level ', num2str(expertLevel)]}, height(parentMeansTable), 1);
% 
%             subMeansTable = expertGroups(j).SubMeans;
%             subMeansTable.Subfolder = repmat({subfolder}, height(subMeansTable), 1);
%             subMeansTable.Type = repmat({['Subfolder Means - Level ', num2str(expertLevel)]}, height(subMeansTable), 1);
% 
%             combinedTable = [combinedTable; parentMeansTable; subMeansTable];
%         end
%     end
% 
%     % Write the combined table to a single sheet in the Excel file
%     writetable(combinedTable, excelFileName, 'Sheet', 'Results', 'WriteMode', 'overwrite');
% end
% 
% function means = calculate_means(data)
%     % Calculate the mean of each column (excluding the ImageName column)
%     means = varfun(@mean, data(:, 2:end));
% end
% 
% function expertGroups = group_by_expert(parentData, subData, subfolder)
%     % Extract the unique expert quality levels
%     expertLevels = unique(parentData.Expert);
% 
%     % Initialize a struct array to hold grouped data
%     expertGroups = struct('ExpertLevel', {}, 'ParentMeans', {}, 'SubMeans', {});
% 
%     % Loop over each expert quality level
%     for i = 1:length(expertLevels)
%         level = expertLevels(i);
%         % Filter the parent and subData based on the expert level
%         filterIdx = parentData.Expert == level;
%         parentFiltered = parentData(filterIdx, :);
%         subFiltered = subData(filterIdx, :);
% 
%         % Calculate means for this group
%         parentMeansTable = calculate_means(parentFiltered(:, 1:end-1)); % Exclude 'Expert'
%         subMeansTable = calculate_means(subFiltered);
% 
%         % Add the results to the struct array
%         expertGroups(i).ExpertLevel = level;
%         expertGroups(i).ParentMeans = parentMeansTable;
%         expertGroups(i).SubMeans = subMeansTable;
%     end
% end
function compare_metrics_and_expert_assessment(parentFolder)
    % Define the subfolders
    subfolders = {'Anisotropic', 'Wavelet', 'SplitBregmanROF'};
    excelFileName = fullfile(parentFolder, 'OCT_Analysis_Results_Metrics.xlsx');
    
    % Read the parent folder data
    parentFile = fullfile(parentFolder, 'quality-duminica-v2.csv');
    parentData = readtable(parentFile);
    
    % Remove the 'Expert' column from parentData for comparison
    parentDataNoExpert = parentData(:, 1:end-1);  % Assumes 'Expert' is the last column
    
    % Calculate the mean of each metric in the parent folder
    parentMeans = calculate_means(parentDataNoExpert);
    
    % Initialize the final table with the parent means
    combinedTable = parentMeans;
    combinedTable.Properties.RowNames = {'Parent'};
    
    % Loop over each subfolder and compute the means and differences
    for i = 1:length(subfolders)
        subfolder = subfolders{i};
        
        % Read the subfolder data
        subFile = fullfile(parentFolder,  subfolder, 'quality-duminica-v2.csv');
        subData = readtable(subFile);
        
        % Calculate the mean of each metric in the subfolder
        subMeans = calculate_means(subData);
        subMeans.Properties.RowNames = {subfolder};
        
        % Append the subfolder mean values as a new row in the combined table
        combinedTable = [combinedTable; subMeans];
        
        % Calculate the differences between subfolder means and parent folder means
        differences = subMeans.Variables - parentMeans.Variables;
        diffRowName = ['Difference_', subfolder];
        diffTable = array2table(differences, 'VariableNames', parentMeans.Properties.VariableNames, 'RowNames', {diffRowName});
        
        % Append the differences as a new row in the combined table
        combinedTable = [combinedTable; diffTable];
    end
    
    % Write the combined table to a single sheet in the Excel file
    writetable(combinedTable, excelFileName, 'Sheet', 'Metrics', 'WriteRowNames', true, 'WriteMode', 'overwrite');
end

function means = calculate_means(data)
    % Calculate the mean of each column (excluding the ImageName column)
    means = varfun(@mean, data(:, 2:end));
end
