function reduced_data = reduce_data_by_laplacian_eigenmap(data, p_neighbors, number_of_reduced_dimensions)
    rng(0);

    N = size(data, 1);
    
    % Changing these values will lead to different nonlinear embeddings
    knn = ceil(p_neighbors*N); % each patch will only look at its knn nearest neighbors in R^d
    %sigma2 = 25; % determines strength of connection in graph... see below

    % now let's get pairwise distance info and create graph 
    m             = N;
    distances_mat = squareform(pdist(data)); % Create NxN matrix of the distance
    [~, srtdIdx]  = sort(distances_mat, 'ascend');
    nidx          = srtdIdx(1:knn + 1,:);

    % Weights matrix
    tempW = ones(size(nidx));

    % Build weight matrix
    i = repmat(1:m, knn + 1, 1);
    % i - sample number, nidx - sample number of nearest neighbor,
    % tempW - weight of connectivity between near neighbors (in our case
    % always 1).
    W = sparse(i(:), double(nidx(:)), tempW(:), m, m);
    W = max(W, W'); % for undirected graph.

    % The original normalized graph Laplacian, non-corrected for density
    ld = diag(sum(W,2).^(-1/2));
    DO = ld*W*ld;
    DO = max(DO,DO');%(DO + DO')/2;
    %DO = diag(sum(W,2))/length(W)-W;

    % get eigenvectors
    [v,d] = eigs(DO,number_of_reduced_dimensions,'la');
    
    reduced_data = v;
