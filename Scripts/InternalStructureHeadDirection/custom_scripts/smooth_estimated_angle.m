function smoothed_estimated_angle_by_clustering = smooth_estimated_angle(estimated_angle_by_clustering, filter_mask)

    sigma = 2;
    hsize = 5;
    gaussian_kernel=exp(-(([1:hsize]-(hsize+1)/2).^2)/(2*sigma^2));
    gaussian_kernel=gaussian_kernel./sum(gaussian_kernel);

    %smoothed_estimated_angle_by_clustering=angle(conv2(exp(1i*estimated_angle_by_clustering),gaussian_kernel,'same'));
    % Perform smoothing by convolution only with samples which passed our
    % thresholds.
    
    masked_estimated_angle_by_clustering = filter_mask .* estimated_angle_by_clustering;
    smoothed_estimated_angle_by_clustering = angle(conv2(exp(1i*masked_estimated_angle_by_clustering)',gaussian_kernel,'same'));
    smoothed_estimated_angle_by_clustering = smoothed_estimated_angle_by_clustering(filter_mask);

    smoothed_estimated_angle_by_clustering=mod(smoothed_estimated_angle_by_clustering,2*pi);

end