function [T, G, Map, Ang, Pos, wake, rem, sws] = load_mouse_data(data_path, mouse_name)
	% Load data from all electrodes
	[T, G, Map, ~] = LoadCluRes([data_path mouse_name '\' mouse_name]);

    Ang = LoadAng([data_path 'AngFiles\' mouse_name '.ang']);
    Pos = LoadPos([data_path 'PosFiles\' mouse_name '.pos']);

    wake = dlmread([data_path mouse_name '\' mouse_name '.states.WAKE']); %in sec;
    rem = dlmread([data_path mouse_name '\' mouse_name '.states.REM']); %in sec;
    sws = dlmread([data_path mouse_name '\' mouse_name '.states.SWS']); %in sec;
end

