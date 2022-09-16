function res = p_th(mu,n)
% 平均光子数为 mu 的热态分布函数，描述 n 粒子数态的概率
if (mu == 0)
    res = 1.0*(n==0);
else
    res = 1./(1+mu).*(mu./(1+mu)).^n;
end
end