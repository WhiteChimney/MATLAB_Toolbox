function res = JonesMatrixQWPInverse(th)
% 四分之一波片的琼斯变换矩阵的逆

res = [1+1i*cos(2*th),   1i*sin(2*th);...
         1i*sin(2*th), 1-1i*cos(2*th)]/(1+1i);

end