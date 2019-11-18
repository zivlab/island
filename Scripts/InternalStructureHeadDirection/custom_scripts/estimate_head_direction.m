function [ smooth_maximum_likelihood_angle_per_sample_index ] = estimate_head_direction( spike_rate_mat_neuron_by_angle, full_neuron_firing_per_bin )
    global TEMPORAL_TIME_BIN NUMBER_OF_ANGLE_BINS;    

    % Perform decoding of neuronal data, based on wake data, to color data
    % points of the reduced data
    head_direction_neurons_indices = find_head_direction_neurons(spike_rate_mat_neuron_by_angle);
    
    maximum_likelihood_angle_index_per_sample_index = head_direction_ml_decoder(spike_rate_mat_neuron_by_angle(head_direction_neurons_indices, :), ...
                                                                                full_neuron_firing_per_bin(:, head_direction_neurons_indices)', ...
                                                                                TEMPORAL_TIME_BIN);
    maximum_likelihood_angle_per_sample_index = maximum_likelihood_angle_index_per_sample_index * 2 * pi / NUMBER_OF_ANGLE_BINS;

    % Post processing of decoder results
    % Smoothing
    smooth_maximum_likelihood_angle_per_sample_index = mod(angle(conv2(exp(1i * maximum_likelihood_angle_per_sample_index), ones(5, 1), 'same')), 2 * pi);
end

