function ReducedDataArray=DimentionalityReduction_LEM(activity_mat_active_frames,p_neighbors_vec)
%Inputs:

%activity_mat_active_frames: N-by-T activity matrix, N is number of neurons
%and T is number of time frames (includes only active frames)

%p_neighbors_vec: 1-by-2 vector of portion of neighbors that are considered close. First
%entry for the first iteraion and second for second iteration.

%Output:
%ReducedDataArray: Array of the data. First Cell original data, second cell data after first 
%iteration of dimentionality reduction, and third cell after second iteration of dimentionality reduction. 


p_neighbors1=p_neighbors_vec(1);
p_neighbors2=p_neighbors_vec(2);

data = activity_mat_active_frames';
N = size(data,1);

knn    = ceil(p_neighbors1*N); 
sigma2 = 25;

m = size(data,1);
dt = squareform(pdist(data));
[srtdDt,srtdIdx] = sort(dt,'ascend');
dt = srtdDt(1:knn+1,:);
nidx = srtdIdx(1:knn+1,:);

tempW  = ones(size(dt));

% build weight matrix
i = repmat(1:m,knn+1,1);
W = sparse(i(:),double(nidx(:)),tempW(:),m,m); 
W = max(W,W'); % for undirected graph.

% The original normalized graph Laplacian, non-corrected for density
ld = diag(sum(W,2).^(-1/2));
DO = ld*W*ld;
DO = max(DO,DO');

% get eigenvectors
[v,d] = eigs(DO,10,'la');

data2 = [v(:,1:10)];
N                = size(data2,1);
knn    = ceil(p_neighbors2*N); % each patch will only look at its knn nearest neighbors in R^d

m                = size(data2,1);
dt               = squareform(pdist(data2));
[srtdDt,srtdIdx] = sort(dt,'ascend');
dt               = srtdDt(1:knn+1,:);
nidx             = srtdIdx(1:knn+1,:);

tempW  = ones(size(dt));

i = repmat(1:m,knn+1,1);
W = sparse(i(:),double(nidx(:)),tempW(:),m,m); 
W = max(W,W');

ld = diag(sum(W,2).^(-1/2));
DO = ld*W*ld;
DO = max(DO,DO');

[v2,d2] = eigs(DO,10,'la');

ReducedDataArray{1}=data;
ReducedDataArray{2}=v;
ReducedDataArray{3}=v2;