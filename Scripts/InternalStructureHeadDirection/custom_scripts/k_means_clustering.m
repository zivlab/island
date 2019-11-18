function [ clustering_results ] = k_means_clustering( reduced_data, number_of_clusters, number_of_iterations )
%K_MEANS_CLUSTERING Summary of this function goes here
%   Detailed explanation goes here

    clustering_results = zeros(size(reduced_data, 1), number_of_iterations);

    % Set the random generator to get stable results
    rng(0);
    
    for iteration_index = 1:number_of_iterations
        clustering_results(:, iteration_index) = kmeans(reduced_data, number_of_clusters);
    end
    
    
end

