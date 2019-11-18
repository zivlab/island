function [ reduced_data ] = create_reduced_data( neuron_firing, p_neightbors_vec, number_of_reduced_dimensions_vec )
    reduced_data = {};
    
    reduced_data{1} = neuron_firing;
    
    for iteration_index = 1:length(number_of_reduced_dimensions_vec)
        reduced_data{iteration_index + 1} = reduce_data_by_laplacian_eigenmap(reduced_data{iteration_index}, ...
                                                                              p_neightbors_vec(iteration_index), ...
                                                                              number_of_reduced_dimensions_vec(iteration_index));
    end
end

