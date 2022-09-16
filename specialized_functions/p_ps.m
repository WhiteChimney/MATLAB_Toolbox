function res = p_ps(mu,n)
% 平均光子数为 mu 的泊松分布函数，描述 n 粒子数态的概率

if (mu==0)
    res = 1.0*(n==0);
else
    res = exp(-mu).*mu.^n./gamma(n+1);
end

end