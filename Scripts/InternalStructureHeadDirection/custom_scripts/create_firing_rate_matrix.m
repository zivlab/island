function [ firing_rate ] = create_firing_rate_matrix( full_firing_rate, angles )
    % 'angle' should be between 0 and 2 * pi

    global NUMBER_OF_ESTIMATED_ANGLE_BINS BEHAVIORAL_SAMPLE_RATE BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN;
    
    CENTER_OF_ESTIMATED_ANGLE_BINS = [0.5 * (2 * pi) / NUMBER_OF_ESTIMATED_ANGLE_BINS:...
                                      (2 * pi) / NUMBER_OF_ESTIMATED_ANGLE_BINS:...
                                      2 * pi - 0.5 * (2 * pi) / NUMBER_OF_ESTIMATED_ANGLE_BINS];
    
    number_of_neurons = size(full_firing_rate, 2);
    
    angles_bin_index = ceil((NUMBER_OF_ESTIMATED_ANGLE_BINS * angles) / (2 * pi));
    angles_bin_index(angles_bin_index == 0) = 1;
    
    frames_per_cluster_count = hist(angles,  CENTER_OF_ESTIMATED_ANGLE_BINS);
    
    number_of_spikes = zeros(number_of_neurons, NUMBER_OF_ESTIMATED_ANGLE_BINS);
    
    for running_bin_index = 1:NUMBER_OF_ESTIMATED_ANGLE_BINS
        number_of_spikes(:, running_bin_index) = sum(full_firing_rate(angles_bin_index == running_bin_index, :), 1);
    end
    
    firing_rate = number_of_spikes ./ repmat(frames_per_cluster_count, number_of_neurons, 1);
    
    firing_rate = firing_rate * (BEHAVIORAL_SAMPLE_RATE / BEHAVIORAL_SAMPLES_PER_TEMPORAL_BIN);

end

