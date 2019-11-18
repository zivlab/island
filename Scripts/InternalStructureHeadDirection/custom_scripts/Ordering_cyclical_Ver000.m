if 1 %that can be pre-produced (and then reused each time)
    n=NUMBER_OF_CLUSTERS; %there is a way to make it more efficient, becomes relevant for higher n 
    shuffle_mat=nan(factorial(n),n);
    for run_shuffle=1:factorial(n)
        temp_shuffle_vec=nan(1,n);
        index_n=run_shuffle;
        for run_shuffle_index=n:-1:2
            shuffle_index_digit=ceil(index_n/factorial(run_shuffle_index-1));
            index_n=index_n-(shuffle_index_digit-1)*factorial(run_shuffle_index-1);
            temp_shuffle_vec(run_shuffle_index)=shuffle_index_digit;
        end
        temp_shuffle_vec(1)=1;
        shuffle_vec=nan(1,n);
        for run_shuffle_index=n:-1:1
            nan_vec=nan(1,run_shuffle_index);
            nan_vec(temp_shuffle_vec(run_shuffle_index))=run_shuffle_index;
            shuffle_vec(isnan(shuffle_vec))=nan_vec;
        end
        shuffle_mat(run_shuffle,:)=shuffle_vec;
    end
    rowSub=[shuffle_mat(:,1:n) shuffle_mat(:,2:n) shuffle_mat(:,1)];
    colSub=[shuffle_mat(:,2:n) shuffle_mat(:,1) shuffle_mat(:,1:n)];
    ind_mat=sub2ind([n n], rowSub, colSub);    
    %ind_mat=sub2ind([n n], shuffle_mat(:,1:n-1)', shuffle_mat(:,2:n)');
end

% you have to load transition_mat
diagonals_values_per_shuffle=transition_mat(ind_mat);
[max_value, max_ind]=max(sum(diagonals_values_per_shuffle,2));
chosen_shuffle=shuffle_mat(max_ind,:);