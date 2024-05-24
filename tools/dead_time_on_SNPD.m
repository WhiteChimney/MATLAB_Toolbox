% 蒙卡计算死时间对超导连续探测模式下的效率影响
% 本文件计算的是高平均光子数下长脉冲（～10 ns）使用超导探测时，死时间对探测结果的影响
% 计算时假定死时间大于脉冲持续时间，因此每次脉冲最多造成一次响应

clear;

t_pulse = 10.0;
                % t_pulse < t_dead
mu = 0.1;         % 每脉冲的平均光子数
N_pulse = 1e8;  % 试验的脉冲数
nbrBins = 100;  % 最终直方图的 bin size

pN = exp(-mu).*mu.^(0:10)./factorial(0:10);
                % 光子数分布，这里最多计算到 10 光子
res = zeros(1,N_pulse);

tic;
parfor i = 1:N_pulse
    n = find_N(rand(),pN);  % 此次实验的光子数
    if (n > 0)
        t = rand(1,n);      % 这 n 个光子在时域上的分布情况
        res(i) = t_pulse.*min(t);
                            % 探测器仅响应时域上第一个到达的脉冲
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