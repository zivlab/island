function [all_trials_activity_smoothed_mat position_active_frames activity_mat_active_frames legitimacy_vec]=...
    SmoothingAndThresholdingData(all_trials_position,all_trials_activity_mat,downsample_flag,ActvitySmoothingSize,ActivityThreshold)


if downsample_flag==0
    all_trials_activity_smoothed_mat=all_trials_activity_mat;
elseif downsample_flag==1
    downsampled_all_trials_activity_mat=all_trials_activity_mat(:,1:2:end-1)+all_trials_activity_mat(:,2:2:end);
    all_trials_activity_smoothed_mat=downsampled_all_trials_activity_mat;
    all_trials_position=all_trials_position(1:2:end-1);
elseif downsample_flag==2
    downsampled_all_trials_activity_mat=conv2(all_trials_activity_mat,ones(1,ActvitySmoothingSize),'same');
    all_trials_activity_smoothed_mat=downsampled_all_trials_activity_mat;
end

activity_leg=~~(sum(all_trials_activity_smoothed_mat)>ActivityThreshold);

legitimacy_vec=(activity_leg);

activity_mat_active_frames=all_trials_activity_smoothed_mat(:,legitimacy_vec);

position_active_frames=all_trials_position(legitimacy_vec);