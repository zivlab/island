function [ spike_rate_mat_neuron_by_angle ] = calculate_spike_rate_neuron_by_angle( T, G, Ang, wake )
    global BEHAVIORAL_SAMPLE_RATE NEURONAL_SAMPLE_RATE NUMBER_OF_ANGLE_BINS CENTER_OF_ANGLE_BINS;
    
    number_of_neurons = max(G);
        
    wake_start_behavior_sample_index = ceil(wake(1) * BEHAVIORAL_SAMPLE_RATE);
    wake_end_behavior_sample_index = floor(wake(2) * BEHAVIORAL_SAMPLE_RATE);
    
    angle_during_awake = Ang(wake_start_behavior_sample_index:wake_end_behavior_sample_index);

    valid_angle_during_awake = angle_during_awake(angle_during_awake ~= -1);
    valid_angle_during_awake_histogram = hist(valid_angle_during_awake, CENTER_OF_ANGLE_BINS);

    spike_rate_mat_neuron_by_angle = nan(number_of_neurons, NUMBER_OF_ANGLE_BINS);

    for neuron_index = 1:number_of_neurons
        spike_times_of_cell = T(G == neuron_index);
        spike_times_of_cell_during_awake = spike_times_of_cell(spike_times_of_cell > (wake(1) * NEURONAL_SAMPLE_RATE) & ...
                                                               spike_times_of_cell < (wake(2) * NEURONAL_SAMPLE_RATE));
        angle_at_spike_times_during_awake = Ang(round((spike_times_of_cell_during_awake / NEURONAL_SAMPLE_RATE) * BEHAVIORAL_SAMPLE_RATE));
        % Remove -1 (unidentified LEDs) frames
        angle_at_spike_times_during_awake = angle_at_spike_times_during_awake(angle_at_spike_times_during_awake ~= -1);

        angle_at_spike_times_during_awake_histogram = hist(angle_at_spike_times_during_awake, CENTER_OF_ANGLE_BINS);

        spike_rate_per_angle_during_awake = angle_at_spike_times_during_awake_histogram ./ valid_angle_during_awake_histogram;

        spike_rate_mat_neuron_by_angle(neuron_index, :) = spike_rate_per_angle_during_awake;   
    end
    
    spike_rate_mat_neuron_by_angle = spike_rate_mat_neuron_by_angle * BEHAVIORAL_SAMPLE_RATE;
end

