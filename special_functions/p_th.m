function res = p_th(mu,n)
% ƽ��������Ϊ mu ����̬�ֲ����������� n ������̬�ĸ���
if (mu == 0)
    res = 1.0*(n==0);
else
    res = 1./(1+mu).*(mu./(1+mu)).^n;
end
end