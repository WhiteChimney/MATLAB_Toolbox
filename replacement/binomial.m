function res = binomial(n,k)
% 连续版本的 nchoosek，用 Gamma 函数代替了阶乘
res = gamma(n+1)./(gamma(k+1).*gamma(n-k+1));
end