function lambda = eigenvalues_with_gaussian_dist(l1,N)

if l1 >= 1
    lambda = 1;
    return;
end

n = 1:N;

l = @(c) l1.*exp((1-n.^2)./c.^2);

fun = @(c) sum(exp((1-n.^2)./c.^2)) - 1./l1;

options = optimoptions('fsolve','Display','off');

c0 = fsolve(fun,1,options);

lambda = l(c0);

end
