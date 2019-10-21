function SubTypeClusteringPerType_Array=SubClusteringPerSegment(NumOfStates,activity_per_segment_Array,segmet_start_time_Array,segmet_end_time_Array,ManualClustering2_flug)

SubTypeClusteringPerType_Array={};
for run_type=1:NumOfStates
    run_type
    activity_at_long_segments_of_chosen_cluster=activity_per_segment_Array{run_type};
    NumOfSegOfCurrentType=size(activity_at_long_segments_of_chosen_cluster,2);
    rand('seed',0)
    [coeff,score,latent,tsquared,explained,mu] = pca(activity_at_long_segments_of_chosen_cluster');
    size(score)
    figure(765)
    plot3(score(:,1),score(:,2),score(:,3),'.')
    prompt = 'How many clusters? ';
    NumOfSubtypesForCurrentState = input(prompt);
    
    ClusterInd_2st_Iter=zeros(1,size(score,1));
    switch ManualClustering2_flug
        case 0
            
            [ClusterInd_2st_Iter]=kmeans(score(:,1:3),NumOfSubtypesForCurrentState);
            SubClustersSilhouette = silhouette(score(:,1:3),ClusterInd_2st_Iter);
            size(SubClustersSilhouette)
        case 1
            dim1=1;
            dim2=2;
            figure, plot(score(:,dim1),score(:,dim2),'.')
            
            if NumOfSubtypesForCurrentState==1
                prompt2 = 'Do you want to manually cluster (1/0)? ';
                Clustering_of_single_cluster = input(prompt2)
            end
            
            NumOfSubtypesForCurrentState
            Clustering_of_single_cluster
            if NumOfSubtypesForCurrentState==1 && Clustering_of_single_cluster==0
                ClusterInd_2st_Iter=ones(1,size(score,1));
            else            
                for run=1:NumOfSubtypesForCurrentState
                    [xx_WithinCurrentSeg{run} yy_WithinCurrentSeg{run}]=ginput(6);
                    hold on
                    plot([xx_WithinCurrentSeg{run}; xx_WithinCurrentSeg{run}(1)],[yy_WithinCurrentSeg{run}; yy_WithinCurrentSeg{run}(1)],'-')
                    ClusterInd_2st_Iter(inpolygon(score(:,dim1),score(:,dim2),xx_WithinCurrentSeg{run},yy_WithinCurrentSeg{run}))=run;
                end
            end
    end
    
    size(ClusterInd_2st_Iter)
    
    figure
    hold on
    SubTypeColorMap=lines(NumOfSubtypesForCurrentState);
    for run=1:NumOfSubtypesForCurrentState
        plot3(score(ClusterInd_2st_Iter==run,1),...
            score(ClusterInd_2st_Iter==run,2),...
            score(ClusterInd_2st_Iter==run,3),...
            '.','color',SubTypeColorMap(run,:))
    end
    SubTypeClusteringPerType_Array{run_type}=ClusterInd_2st_Iter;
end