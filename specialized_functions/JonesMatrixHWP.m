function res = JonesMatrixHWP(th)
% 半波片的琼斯变换矩阵

res = [cos(2*th),  sin(2*th);...
       sin(2*th), -cos(2*th)];

end