function res = find_FWHM(x,y)
% 求一个曲线的半高宽，只适用于单峰曲线

max_index = find(y==max(y));
x_l = interp1(y(1:max_index),x(1:max_index),max(y)/2,'spline');
x_r = interp1(y(max_index:end),x(max_index:end),max(y)/2,'spline');
res = abs(x_r - x_l);

end