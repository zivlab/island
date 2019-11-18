%%
% Import project-wide constants
constants_raw

%% Load data

[T, G, Map, Ang, Pos, wake, rem, sws] = load_mouse_data(DATA_PATH, MOUSE_NAME);

%% Basic extraction of data

[full_neuron_firing_per_bin, angle_per_temporal_bin, position_per_temporal_bin] = create_spike_count_and_angles_vector(wake, T, G, Ang, Pos);

%%
spike_rate_mat_neuron_by_angle = calculate_spike_rate_neuron_by_angle(T, G, Ang, wake);