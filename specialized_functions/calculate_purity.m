function p = calculate_purity(JSA,l_s,l_i)
% 计算纯度
% 默认单位：μm，fs

c = 0.299792458;

if (length(l_s) < 2) or (length(l_i) < 2)
    return;
else
    if length(l_s) < 3
        l_s = linspace(l_s(1),l_s(2),1001);
    end
    if length(l_i) < 3
        l_i = linspace(l_i(1),l_i(2),1001);
    end
end

w_s = 2*pi*c./l_s; w_s = reshape(w_s,[],1); size_s = length(w_s);
w_i = 2*pi*c./l_i; w_i = reshape(w_i,1,[]); size_i = length(w_i);

w_ss = repmat(w_s,1,size_i); w_ii = repmat(w_i,size_s,1);

[~,S,~] = svd(JSA(w_ss,w_ii));
S = S./sqrt(sum(diag(abs(S).^2)));
p = sum(diag(abs(S)).^4);

end