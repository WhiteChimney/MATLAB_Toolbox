function res = binomial(n,k)
% �����汾�� nchoosek���� Gamma ���������˽׳�
res = gamma(n+1)./(gamma(k+1).*gamma(n-k+1));
end