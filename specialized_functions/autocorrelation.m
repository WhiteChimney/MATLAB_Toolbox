function [tau,I_2w] = autocorrelation(t,I)
% 求实际测得的脉冲去做自相关后得到的曲线

t = reshape(t,1,[]);
L = length(t);

tau = [t - max(t), t - min(t)];
tau = [tau(1:L-1),tau(L+1:end)];

I_2w = zeros(size(tau));
for i = 1:L
    I_2w(i) = I(1:i).*I(L-i+1:L);
    I_2w(end-i+1) = I_2w(i);
end

I_2w = I_2w./max(I_2w);

end