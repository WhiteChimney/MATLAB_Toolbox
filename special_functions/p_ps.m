function res = p_ps(mu,n)
% ƽ��������Ϊ mu �Ĳ��ɷֲ����������� n ������̬�ĸ���

if (mu==0)
    res = 1.0*(n==0);
else
    res = exp(-mu).*mu.^n./gamma(n+1);
end

end