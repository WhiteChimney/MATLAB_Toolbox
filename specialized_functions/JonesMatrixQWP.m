function res = JonesMatrixQWP(th)
% 四分之一波片的琼斯变换矩阵

res = [cos(th)^2+1i*sin(th)^2, (1-1i)*sin(th)*cos(th);...
       (1-1i)*sin(th)*cos(th), 1i*cos(th)^2+sin(th)^2];

end