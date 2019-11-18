function [ filtered_neuron_firing ] = filter_neuron_firing( neuron_firing )
%FILTER_NEURON_FIRING Post processing of the neuronal firing data

    % Binarize the data of the number of spiking per time frame (any number of
    % spikes is equal to binary True)
    filtered_neuron_firing = 1.0 * (~~neuron_firing);
    % Threshold minimum number of spikes at 2
    %full_neuron_firing_per_bin = 1.0*(full_neuron_firing_per_bin > 1);
    % Reduce long distrances
    %full_neuron_firing_per_bin = log(full_neuron_firing_per_bin + 1);

end

