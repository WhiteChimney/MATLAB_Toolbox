% 蒙卡计算死时间对超导连续探测模式下的效率影响

clear;

t_pulse = 10.0;
                % t_pulse < t_dead
mu = 0.1;         % 每脉冲的平均光子数
N_pulse = 1e8;  % 试验的脉冲数
nbrBins = 100;  % bin size

pN = exp(-mu).*mu.^(0:10)./factorial(0:10);
res = zeros(1,N_pulse);

tic;
parfor i = 1:N_pulse
    n = find_N(rand(),pN);
    if (n > 0)
        t = rand(1,n);
        res(i) = t_pulse.*min(t);
    end
end
toc;

histogram(res,nbrBins)
xlim([1 Inf])
ylim([0 1e5])

function n = find_N(p,pN)
    n = 1;
    while (p > pN(n) && n < length(pN))
        p = p - pN(n);
        n = n + 1;
    end
    n = n - 1;
end