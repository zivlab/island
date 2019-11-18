function [ valid_neurons_indices ] = find_head_direction_neurons(spike_rate_mat_neuron_by_angle)
    global CENTER_OF_ANGLE_BINS FIRING_RATE_THRESHOLD RAYLEIGH_VECTOR_LENGTH_THRESHOLD;
    
    number_of_neurons = size(spike_rate_mat_neuron_by_angle, 1);

    max_firing_rate_per_neuron = max(spike_rate_mat_neuron_by_angle, [], 2);
    
    v = exp(1i * CENTER_OF_ANGLE_BINS);
    m = spike_rate_mat_neuron_by_angle .* repmat(v, number_of_neurons, 1);
    rayleigh_vector_length_per_neuron = abs(sum(m, 2)) ./ sum(abs(m), 2);

    valid_neurons_indices = find(max_firing_rate_per_neuron > FIRING_RATE_THRESHOLD & ...
                                 rayleigh_vector_length_per_neuron > RAYLEIGH_VECTOR_LENGTH_THRESHOLD);
end

