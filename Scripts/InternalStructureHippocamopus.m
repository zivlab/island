PathRawData='D:\Alon\Work\Butterflies\VerForPublic\ForGitHubTemp\SampleData';

ActivityThreshold=1;
downsample_flag=2;
ActvitySmoothingSize=2;
NumOfBins=24;

p_neighbors_vec=[0.075/15 0.075];

ChosenDirectionArray={'Positive' 'Negative'};

global cmap_position
cmap_position=jet(24);

global SubTypeColorMapArrayByNumer
SubTypeColorMapArrayByNumer{1}=[0 0 0];
SubTypeColorMapArrayByNumer{2}=[1 0 0; 0 0 1];
SubTypeColorMapArrayByNumer{3}=[1 0 0; 0 1 0; 0 0 1];
SubTypeColorMapArrayByNumer{4}=[1 0 0; 0 1 0; 0 0 1; 1 0 1];

%% Load data
load([PathRawData '\neuronal_activity_mat'])
load([PathRawData '\position_per_frame'])
load([PathRawData '\velocity_per_frame'])
%%
[all_trials_activity_smoothed_mat position_active_frames activity_mat_active_frames legitimacy_vec]=...
    SoothingAndThresholdingData(position_per_frame,neuronal_activity_mat,downsample_flag,ActvitySmoothingSize,ActivityThreshold);

TotalNumOfCells=size(neuronal_activity_mat,1);
TimeVec=[1:size(neuronal_activity_mat,2)];
TimeVec=TimeVec(legitimacy_vec);

%% Dimentionality Reduction
rand('seed',0)
ReducedDataArray=DimentionalityReduction_Ver1(activity_mat_active_frames,p_neighbors_vec);

v2=ReducedDataArray{3};

%%
max_v2_2=max(v2(:,2));
min_v2_2=min(v2(:,2));
normed_v2_2=24*(v2(:,2)-min_v2_2)/(max_v2_2-min_v2_2);
if corr(normed_v2_2,position_active_frames')<0
    normed_v2_2=25-normed_v2_2;
end

figure, plot3(v2(:,2),v2(:,3),v2(:,4),'k.','markersize',5)
view([20,20])
xlabel('Comp. 1')
ylabel('Comp. 2')
zlabel('Comp. 3')
Panel1A_lim=0.025;
xlim([-Panel1A_lim Panel1A_lim])
ylim([-Panel1A_lim Panel1A_lim])
zlim([-Panel1A_lim Panel1A_lim])
set(gca,'XTick',[])
set(gca,'XTickLabel',[]);
set(gca,'YTick',[])
set(gca,'YTickLabel',[]);
set(gca,'ZTick',[])
set(gca,'ZTickLabel',[]);
axis square

figure, scatter3(v2(:,2),v2(:,3),v2(:,4),5,cmap_position(position_active_frames,:),'fill')
view([20,20])
xlabel('Comp. 1')
ylabel('Comp. 2')
zlabel('Comp. 3')
Panel1A_lim=0.025;
xlim([-Panel1A_lim Panel1A_lim])
ylim([-Panel1A_lim Panel1A_lim])
zlim([-Panel1A_lim Panel1A_lim])
set(gca,'XTick',[])
set(gca,'XTickLabel',[]);
set(gca,'YTick',[])
set(gca,'YTickLabel',[]);
set(gca,'ZTick',[])
set(gca,'ZTickLabel',[]);
axis square
%%
load('TopoClustringData') %the saved clustering is the output of TopoClustering.m on the data

TopoClusterVer=1;
Indexing_Ver=3;
ChosenType=3; %cluster of running

NumOfClusters=max(TopoClustering.global.ind)-1;
%cmap_clusters=lines(NumOfClusters+1);
cmap_clusters=jet(NumOfClusters+1);

switch Indexing_Ver
    case 0
        cluster_ind=TopoClustering.global.ind;
    case 1
        cluster_ind=TopoClustering.global.ind_augmented;
    case 2
        cluster_ind=TopoClustering.global.ind_augmented2;
    case 3
        cluster_ind=TopoClustering.global.ind_augmented3;
end

figure
scatter3(v2(:,2),v2(:,3),v2(:,4),5,cmap_position(position_active_frames,:),'fill')

figure
scatter3(v2(:,2),v2(:,3),v2(:,4),5,cmap_clusters(cluster_ind,:),'fill')
%%
figure
NumOfRows=ceil(sqrt(NumOfClusters));
NumOfColumns=ceil(NumOfClusters/NumOfRows);
for run_cluster=1:NumOfClusters
    subplot(NumOfRows,NumOfColumns,run_cluster)
    scatter3(v2(cluster_ind~=run_cluster,2),v2(cluster_ind~=run_cluster,3),v2(cluster_ind~=run_cluster,4),...
        1)
end

figure
NumOfRows=ceil(sqrt(NumOfClusters));
NumOfColumns=ceil(NumOfClusters/NumOfRows);
for run_cluster=1:NumOfClusters
    subplot(NumOfRows,NumOfColumns,run_cluster)
    scatter3(v2(cluster_ind==run_cluster,2),v2(cluster_ind==run_cluster,3),v2(cluster_ind==run_cluster,4),...
        5,cmap_position(position_active_frames(cluster_ind==run_cluster),:),'fill')
    hold on
    scatter3(v2(cluster_ind~=run_cluster,2),v2(cluster_ind~=run_cluster,3),v2(cluster_ind~=run_cluster,4),...
        1)
end
%%
state_per_frame=cluster_ind;
state_per_frame(state_per_frame>NumOfClusters)=nan;

figure; 
plot(TimeVec(state_per_frame<=NumOfClusters),state_per_frame(state_per_frame<=NumOfClusters)*24/NumOfClusters,'*'); 
hold on; 
plot(position_per_frame,'k.')
%% SubTypeClusteringPerType_Array.mat - can be loaded instead of running this block

gap_threshold_vec=[7 7 5 7 7];
long_segmet_threshold_vec=[5 7 20 7 5];

[segmet_start_time_Array segmet_end_time_Array activity_per_segment_Array]=...
    TimeSegmentation_Ver1(TimeVec,NumOfClusters,state_per_frame,all_trials_activity_smoothed_mat,gap_threshold_vec,long_segmet_threshold_vec);

figure
hold on
for chosen_cluster_index=1:NumOfClusters
    for run_segment_ind=1:length(segmet_start_time_Array{chosen_cluster_index})
        start_frame=segmet_start_time_Array{chosen_cluster_index}(run_segment_ind);
        end_frame=segmet_end_time_Array{chosen_cluster_index}(run_segment_ind);
        current_segmet_length=end_frame-start_frame+1;
        plot([start_frame:end_frame],(NumOfClusters+1)-chosen_cluster_index*ones(1,current_segmet_length),'k*')
    end
end
hold on
plot(position_per_frame*NumOfClusters/24,'b.')

ylim([0 NumOfClusters+1])

%%
if 1
ManualClustering2_flug=1;
SubTypeClusteringPerType_Array=SubClusteringPerSegment(NumOfClusters,activity_per_segment_Array,segmet_start_time_Array,segmet_end_time_Array,ManualClustering2_flug);
else
    load('SubTypeClusteringPerType_Array')
end
%%
figure
hold on
for chosen_cluster_index=1:NumOfClusters
    NumOfSubTypesCurrentType=max(SubTypeClusteringPerType_Array{chosen_cluster_index});
    for run_segment_ind=1:length(segmet_start_time_Array{chosen_cluster_index})
        start_frame=segmet_start_time_Array{chosen_cluster_index}(run_segment_ind)-15;
        end_frame=segmet_end_time_Array{chosen_cluster_index}(run_segment_ind)+15;
        current_segmet_length=end_frame-start_frame+1;
        current_segmet_subtype=SubTypeClusteringPerType_Array{chosen_cluster_index}(run_segment_ind);
        if current_segmet_subtype==0
            current_color=[0.5 0.5 0.5];
        elseif NumOfSubTypesCurrentType==1
            current_color=[0 0 0];
        else           
            %current_color=SubTypeColorMapArray{chosen_cluster_index}(current_segmet_subtype,:);
            current_color_map=lines(NumOfSubTypesCurrentType);
            current_color=current_color_map(current_segmet_subtype,:);
        end
        plot([start_frame:end_frame],(NumOfClusters+1)-chosen_cluster_index*ones(1,current_segmet_length),'*','color',current_color)
    end
end

plot(position_per_frame*NumOfClusters/24,'m.')
ylim([0 NumOfClusters+1])