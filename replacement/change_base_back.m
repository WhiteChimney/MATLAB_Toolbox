function out = change_base_back(in,base)
% 根据输入、基底、长度进行进制转换计算（自定义进制转换十进制）
in = reshape(in,1,[]);
base = [reshape(base,1,[]),1];
l = length(base);
if length(in) > l 
    in = in(length(in)-l+1:end);
else
    in = [zeros(1,l-length(in)),in];
end

out = 0;
for i = 1:l
    out = out + in(i)*prod(base(i:end));
end
end

function M = generate_M(kmax,lN)
% 生成 M 矩阵
lk = (kmax+1)^lN;
M = zeros(lk,lN);
M_count = 0:lk-1;
for i = 1:lk
    M(i,:) = change_base(M_count(i),kmax+1,lN);
end
end

