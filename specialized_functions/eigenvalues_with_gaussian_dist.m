function lambda = eigenvalues_with_gaussian_dist(l1,N)

if l1 >= 1
    lambda = 1;
    return;
end

n = 1:N;

l = @(c) exp(-n.^2/c^2)
lambda = l./sum(l);

end
