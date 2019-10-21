%% Create barcodes plot and data
data=DataSet;
'tic'
tic
cluster_size=20; %minimal number of data points per cluster

distances = squareform(pdist(data));
distances(distances == 0) = 1; %
r_vec = 0.0001:0.0001:0.3;
%r_vec = 0:0.01:10;

all_bins_mat=nan(length(distances),length(r_vec));
values_array={};
indices_array={};
occurrences_array={};
for i = 2:length(r_vec)
    
    current_graph = distances < r_vec(i);
    
    bins = conncomp(graph(current_graph));
    all_bins_mat(:,i)=bins;
    [values, indices] = unique(bins);
    occurrences = hist(bins, values);
    values_array{i}=values;
    indices_array{i}=indices;
    occurrences_array{i}=occurrences;
    
    values = values(occurrences > cluster_size);
    indices = indices(occurrences > cluster_size);
   
    num_of_clusters(i)=length(values);
end

% Create fixed indexing arrays by keeping the cluster number of the larger
% cluster when merging

new_ind_array={};
new_ind_array{2} = indices_array{2};
for i = 3:length(r_vec)
    current_indices = indices_array{i};
    current_bins = all_bins_mat(:, i);
    prev_indices = indices_array{i - 1};
    prev_bins = all_bins_mat(:, i - 1);
    prev_occurr = occurrences_array{i - 1};
    
    prev_new_ind = new_ind_array{i - 1};
    
    new_ind_vec = nan(1, length(current_indices));
    for run_cluster=1:length(current_indices)
        sons_of_run_clusters = prev_new_ind(current_bins(prev_indices) == prev_bins(prev_indices(run_cluster)));
        occurr_of_sons = prev_occurr(current_bins(prev_indices) == prev_bins(prev_new_ind(run_cluster)));
        [~, most_freq_son_ind] = max(occurr_of_sons);

        new_ind_vec(run_cluster) = prev_new_ind(prev_new_ind == sons_of_run_clusters(most_freq_son_ind));
            
    end
    
    new_ind_array{i} = new_ind_vec; 
end

% Plot fixed indices barcodes

figure;
hold on;

for i = 2:length(r_vec)
    indices = new_ind_array{i};
    occurrences = occurrences_array{i};
    
    indices = indices(occurrences > cluster_size);
    
    plot(r_vec(i) * ones(length(indices), 1), indices, 'k*');
end

xlabel('Radius')
ylabel('H_0')

TopoClusteringMat=[];
for i = 2:length(r_vec)
    indices = new_ind_array{i};
    occurrences = occurrences_array{i}; 
    indices = indices(occurrences > cluster_size);
    
    for run=1:length(indices)       
    TopoClusteringMat(i,indices(run))=1;
    end
end
toc
%%
active_clusters=find(sum(TopoClusteringMat,1));
figure;
hold on;
for run = 1:length(active_clusters)
    current_cluster_ind=active_clusters(run);
    current_cluster_r_vec=r_vec(~~TopoClusteringMat(:,current_cluster_ind));
    plot(min(current_cluster_r_vec),max(current_cluster_r_vec), 'bo');  
end
plot([0 max(r_vec)],[0 max(r_vec)],'k-')
xlim([0 max(r_vec)])
ylim([0 max(r_vec)])
axis square
xlabel('Birth')
ylabel('Death')

%%
segments_array=nan(length(active_clusters),2);
FatherClusterVec=nan(length(active_clusters),1);
for run = 1:length(active_clusters)
    current_cluster_ind=active_clusters(run);
    current_cluster_r_vec=r_vec(~~TopoClusteringMat(:,current_cluster_ind));
    %plot(current_cluster_r_vec,current_cluster_ind*ones(1,length(current_cluster_r_vec)), 'b-');
    last_frame_cluster_existence=max(find(~~TopoClusteringMat(:,current_cluster_ind)));
    
    IdentityClusterBeforeClusterDie=new_ind_array{last_frame_cluster_existence};
    
    if last_frame_cluster_existence~=length(new_ind_array)
    IdentityClusterAfterClusterDie=new_ind_array{last_frame_cluster_existence+1};
    PointsPerClusterBeforeClusterDie=occurrences_array{last_frame_cluster_existence};
    PointsPerClusterAfterClusterDie=occurrences_array{last_frame_cluster_existence+1};
    DiffPointsPerCluster=PointsPerClusterAfterClusterDie-PointsPerClusterBeforeClusterDie(ismember(IdentityClusterBeforeClusterDie,IdentityClusterAfterClusterDie));
    
    FatherClusterVec(run)=IdentityClusterAfterClusterDie(DiffPointsPerCluster==max(DiffPointsPerCluster));    
    segments_array(run,:)=[min(current_cluster_r_vec) max(current_cluster_r_vec)];
    else
        FatherClusterVec(run)=current_cluster_ind;  %cluster that survive is its own fater  
    segments_array(run,:)=[min(current_cluster_r_vec) max(current_cluster_r_vec)];
    end
end


FatherClusterVec2=nan(1,length(active_clusters));
for run=1:length(FatherClusterVec)
    FatherClusterVec2(run)=find(active_clusters==FatherClusterVec(run));
end
SonPerCluster={};
for run=1:length(FatherClusterVec)
    SonPerCluster{run}=find(FatherClusterVec2==(run));
end

loc=zeros(1,length(active_clusters));
[~,AncestorInd]=max(segments_array(:,2));
CurrInd=AncestorInd;
CurrLoc=1;
loc(CurrInd)=CurrLoc;
while 1
   %['CurrInd = ' num2str(CurrInd)]
    SonsList=SonPerCluster{CurrInd};
    if length(SonsList)>0 & ~(length(SonsList)==1 & SonsList==AncestorInd)
        [~,Ind]=min(segments_array(SonsList,2));
        CurrInd=SonsList(Ind);
        CurrLoc=CurrLoc+1;
        loc(CurrInd)=CurrLoc;
    else
        if CurrInd==AncestorInd
            break
        else
            PrevInd=CurrInd;
            CurrInd=FatherClusterVec2(CurrInd);
            CurrentSonsList=SonPerCluster{CurrInd};
            SonPerCluster{CurrInd}=CurrentSonsList(CurrentSonsList~=PrevInd);
        end
    end 
end

figure
hold on
for run = 1:length(active_clusters)  
    plot(segments_array(run,:),loc(run)*[1 1],'k-')
    plot([1 1]*segments_array(run,2),[loc(run) loc(FatherClusterVec2(run))],'k-')
end  
xlabel('Radius')
ylabel('H_0')
%% Plot clusters by r
R = 0.2; %chosen threshold neighbor-distance for clustering. Foe example data try 0.2 and 0.05; 

figure;
hold on;

scatter(data(:, 1), data(:, 2), 5, '.');


[~,current_ind]=min(abs(r_vec - R));

indices = new_ind_array{current_ind};
occurrences = occurrences_array{current_ind};
    
indices = indices(occurrences > cluster_size);
NUMBER_OF_CLUSTERS = length(indices);
color_map=hsv(NUMBER_OF_CLUSTERS);

ind = ones(size(data, 1), 1) * (NUMBER_OF_CLUSTERS + 1);

non_chosen_points=ones(1,size(data,1));
for i = 1:length(indices)  
    chosen_points=~~(all_bins_mat(:,current_ind)==all_bins_mat(indices(i),current_ind));
    scatter(data(chosen_points, 1), data(chosen_points, 2), 20, color_map(i,:), '.');
    non_chosen_points(chosen_points)=0;
    ind(chosen_points) = i;
end
title(num2str(R));

%%

figure
NumOfSubPlotsCol=ceil(sqrt(NUMBER_OF_CLUSTERS+1));
NumOfSubPlotsRow=ceil((NUMBER_OF_CLUSTERS+1)/NumOfSubPlotsCol);
for run=1:NUMBER_OF_CLUSTERS+1
    subplot(NumOfSubPlotsRow,NumOfSubPlotsCol,run)
    plot(data(:, 1), data(:, 2),'k.','MarkerSize',1)
    hold on
    plot(data(ind==run, 1), data(ind==run, 2),'ro','markerfacecolor', 'r','markersize',1);
    xticks([])
    yticks([])
    xlim([0 2])
    ylim([-0.5 4])
end
%%
