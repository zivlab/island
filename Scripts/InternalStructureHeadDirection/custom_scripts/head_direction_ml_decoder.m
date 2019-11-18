function [ maximum_likelihood_angle_per_sample_index ] = head_direction_ml_decoder(spike_rate_mat_neuron_by_angle, neuronal_activity_mat_neuron_by_sample, temporal_time_bin)
    % 'spike_rate_mat_neuron_by_angle' - in hertz
    % 'temporal_time_bin' - BEHAVIOR_SAMPLES_PER_TEMPORAL_BIN / BEHAVIOR_SAMPLE_RATE (from 'main.m')
    
    binned_spike_rate_mat_neuron_by_angle = spike_rate_mat_neuron_by_angle * temporal_time_bin;
    
    % Replicated for all samples
    binned_spike_rate_mat_neuron_by_angle_by_sample = repmat(binned_spike_rate_mat_neuron_by_angle, [1 1 size(neuronal_activity_mat_neuron_by_sample, 2)]);
    
    % Replicated for all angles
    neuronal_activity_mat_neuron_by_angle_by_sample = repmat(permute(neuronal_activity_mat_neuron_by_sample, [1 3 2]), [1 size(spike_rate_mat_neuron_by_angle, 2) 1]);
    
    lambda_mat = binned_spike_rate_mat_neuron_by_angle_by_sample;
    n_mat = neuronal_activity_mat_neuron_by_angle_by_sample;
    
    % Probability of each neuron (given its firing rate) to emit n spikes
    % in each angle (poisson distribution).
    p_mat = (exp(-lambda_mat) .* lambda_mat .^ n_mat) ./ factorial(n_mat);
    
    log_p_mat_angle_by_sample = sum(log(p_mat), 1);
    
    [~, maximum_likelihood_angle_per_sample_index] = max(log_p_mat_angle_by_sample, [], 2);
    
    maximum_likelihood_angle_per_sample_index = squeeze(maximum_likelihood_angle_per_sample_index);
end

