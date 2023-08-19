function [lambda,U,V] = schmidt_decom(f,wx_m,wy_m,sizeN)
% 对输入函数 f 作 Schimidt 分解，求其特征值

wx_min = min(wx_m); wx_max = max(wx_m);
wy_min = min(wy_m); wy_max = max(wy_m);

dwx = linspace(wx_min,wx_max,sizeN);
dwy = linspace(wy_min,wy_max,sizeN);
wx = repmat(dwx',1,sizeN); wy = repmat(dwy,sizeN,1);

f = f(wx,wy);
[U,S,V] = svd(f);
S = abs(diag(S)).^2;
lambda = S./sum(S);
lambda = sort(lambda,'descend');

end