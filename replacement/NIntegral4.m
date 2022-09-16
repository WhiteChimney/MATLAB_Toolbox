function res = NIntegral4(F,x,y,z,w)
% 用 trapz 函数嵌套求解 4 重积分

[X,Y,Z] = meshgrid(x,y,z);
X = repmat(X,1,1,1,length(w));
Y = repmat(Y,1,1,1,length(w));
Z = repmat(Z,1,1,1,length(w));
W = repmat(reshape(w,1,1,1,[]),length(y),length(x),length(z));

integrand = F(X,Y,Z,W);

res = trapz(y,trapz(x,trapz(z,trapz(w,integrand,4),3),2));

end