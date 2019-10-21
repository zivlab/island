function [segmet_start_time_Array segmet_end_time_Array activity_per_segment_Array]=...
    TimeSegmentation_Ver1(TimeVec,NumOfStates,state_per_frame,all_trials_activity_smoothed_mat,gap_threshold_vec,long_segmet_treshold_vec)

% TimeVec
% state_per_frame
% NumOfStates

 %maybe to make those external(struct as input) + unique per state:
include_all_frame_within_segment=1;
% gap_threshold=5;
% long_segmet_treshold=5;

segmet_start_time_Array={};
segmet_end_time_Array={};
activity_per_segment_Array={};

for chosen_cluster_index=1:NumOfStates
    gap_threshold=gap_threshold_vec(chosen_cluster_index);
    long_segmet_treshold=long_segmet_treshold_vec(chosen_cluster_index);
    
    frames_of_chosen_cluster=find(state_per_frame==chosen_cluster_index);
    gaps_between_frames_of_chosen_cluster=diff(frames_of_chosen_cluster);
    gaps_between_frames_of_chosen_cluster2=diff(TimeVec(frames_of_chosen_cluster));
    
    segment_start_vec=[];
    segment_end_vec=[];
    within_segment_flag=0;
    for run=1:length(gaps_between_frames_of_chosen_cluster)
        if within_segment_flag==0 & gaps_between_frames_of_chosen_cluster(run)<gap_threshold
            segment_start_vec=[segment_start_vec run];
            within_segment_flag=1;
        elseif within_segment_flag==1 & gaps_between_frames_of_chosen_cluster(run)>=gap_threshold
            segment_end_vec=[segment_end_vec run-1];
            within_segment_flag=0;
        end
    end
    
    if length(segment_start_vec)>length(segment_end_vec)
        segment_end_vec=[segment_end_vec run];
    end
       
    segmet_length_vec=segment_end_vec-segment_start_vec+1;
    
    long_segments_start_vec=segment_start_vec(segmet_length_vec>long_segmet_treshold);
    long_segments_end_vec=segment_end_vec(segmet_length_vec>long_segmet_treshold);

    
    TimeVec_chosen_cluster=TimeVec(state_per_frame==chosen_cluster_index);
    Time_of_start_long_segmets_vec=TimeVec_chosen_cluster(long_segments_start_vec);
    Time_of_end_long_segmets_vec=TimeVec_chosen_cluster(long_segments_end_vec);
      
    AllClusters_Time_of_start_long_segmets_Array{chosen_cluster_index}=Time_of_start_long_segmets_vec;
    AllClusters_Time_of_end_long_segmets_Array{chosen_cluster_index}=Time_of_end_long_segmets_vec;
    
    activity_at_long_segments_of_chosen_cluster=[];
    current_segmet_start_time_vec=[];
    current_segmet_end_time_vec=[];
    if include_all_frame_within_segment==1
        for run=1:length(long_segments_start_vec)
            current_segmet_start_time=TimeVec(frames_of_chosen_cluster(long_segments_start_vec(run)));
            current_segmet_end_time=TimeVec(frames_of_chosen_cluster(long_segments_end_vec(run)));
%             size(all_trials_activity_smoothed_mat)
%             current_segmet_start_time
%             current_segmet_end_time
            current_segment_activity=sum(all_trials_activity_smoothed_mat(:,current_segmet_start_time:current_segmet_end_time),2);
            activity_at_long_segments_of_chosen_cluster(:,run)=current_segment_activity;
            current_segmet_start_time_vec=[current_segmet_start_time_vec current_segmet_start_time];
            current_segmet_end_time_vec=[current_segmet_end_time_vec current_segmet_end_time];
        end
    else
        for run=1:length(long_segments_start_vec)
            current_segmet_start_time=TimeVec(frames_of_chosen_cluster(long_segments_start_vec(run)));
            current_segmet_end_time=TimeVec(frames_of_chosen_cluster(long_segments_end_vec(run)));
            current_segment_TimeVec_chosen_cluster=TimeVec_chosen_cluster(TimeVec_chosen_cluster>=current_segmet_start_time & TimeVec_chosen_cluster<=current_segmet_end_time);
            current_segment_activity=sum(all_trials_activity_smoothed_mat(:,current_segment_TimeVec_chosen_cluster),2);
            activity_at_long_segments_of_chosen_cluster(:,run)=current_segment_activity;
            current_segmet_start_time_vec=[current_segmet_start_time_vec current_segmet_start_time];
            current_segmet_end_time_vec=[current_segmet_end_time_vec current_segmet_end_time];
        end
    end
    
    segmet_start_time_Array{chosen_cluster_index}=current_segmet_start_time_vec;
    segmet_end_time_Array{chosen_cluster_index}=current_segmet_end_time_vec;
    activity_per_segment_Array{chosen_cluster_index}=activity_at_long_segments_of_chosen_cluster;
end