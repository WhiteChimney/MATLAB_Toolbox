function res = H2(x)
% 二元熵函数，x 取值范围为 [0,1]

% res = (x<=0).*0 + (x>=1).*0 + ...
%       (x>0 & x<1).*(- x.*log2(x) - (1-x).*log2(1-x));

res = zeros(size(x));
index = (x<=0) | (x>=1);
x_valid = x(~index);
res(~index) = - x_valid.*log2(x_valid) - (1-x_valid).*log2(1-x_valid);

end