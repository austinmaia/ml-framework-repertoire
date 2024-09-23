
%% 
load("Z:\MaiaClassificationProject\allcontours\3 species\without fkw\ARTwarp096_0.mat")

%%
% Initialize an empty array to store the data
data = [];

% Use a loop to extract and concatenate the 'myField' from each struct element
for i = 1:numel(DATA)
    % Extract the 'myField' from the current struct element
    currentData = DATA(i).contour;
    
    % Concatenate the currentData to the existing data
    data{i} = [currentData];
end
dataMatrix = data';
%%
% Call the custom function to compute the DTW distance matrix
dtwDistanceMatrix = computeDTWDistanceMatrix(dataMatrix);
%%
% Perform NMDS on the DTW distance matrix
rng("default")
nDims = 2; % Set the number of dimensions for NMDS
nmdsResult = cmdscale(dtwDistanceMatrix, nDims);

% Cluster with k-means and Calinski-Harabasz
%k_values = 1:5; % Define the range of cluster numbers to consider
k_values = 1:NET.numCategories
% Initialize variables to store the clustering results and CH scores
cluster_assignments = cell(1, numel(k_values));
ch_scores = zeros(1, numel(k_values));
silhouette_coeffs = cell(1, numel(k_values));


for i = 1:numel(k_values)
    k = k_values(i);
    cluster_assignments{i} = kmeans(nmdsResult, k);
    
    % Evaluate clustering quality using the Calinski-Harabasz criterion
    eva = evalclusters(nmdsResult, cluster_assignments{i}, 'CalinskiHarabasz');
    ch_scores(i) = eva.CriterionValues; % Extract the CH score

    % Calculate silhouette coefficient
    silhouette_coeffs{i} = silhouette(nmdsResult, cluster_assignments{i});

end

% Determine the optimal number of clusters based on Calinski-Harabasz
[~, optimal_ch_index] = max(ch_scores);
optimal_num_clusters = k_values(optimal_ch_index);

% Create a scatter plot with optimal clustering
figure;
scatter(nmdsResult(:, 1), nmdsResult(:, 2), [], cluster_assignments{optimal_ch_index});
title('NMDS Plot with Optimal Ch Clustering')



%%

% Perform NMDS on the DTW distance matrix
rng("default")
nDims = 2; % Set the number of dimensions for NMDS
nmdsResult = cmdscale(dtwDistanceMatrix, nDims);
k_values = 1:(NET.numCategories * 2);

ch_evaluation = evalclusters(nmdsResult, "kmeans", "CalinskiHarabasz", "KList", k_values)

%%
plot(ch_evaluation)
plot(s_evaluation)
%%
k_values = 1:NET.numCategories

evaluation = evalclusters(dtwDistanceMatrix,"kmeans","silhouette","KList",k_values)
plot(evaluation)

%%
function dtwDistanceMatrix = computeDTWDistanceMatrix(timeSeriesData)
    N = length(timeSeriesData);
    dtwDistanceMatrix = zeros(N, N);

    for i = 1:N
        for j = i+1:N
            % Compute DTW distance using 'warp' function from ARTwarp
            dtwCell = warp(timeSeriesData{i}, timeSeriesData{j});
            dtwDist = dtwCell{1};
            dtwDistanceMatrix(i, j) = dtwDist;
            dtwDistanceMatrix(j, i) = dtwDist; %make into symmetric matrix
        end
    end
end
