function res = find_FWHM(x,y)
% ��һ�����ߵİ�߿�ֻ�����ڵ�������

max_index = find(y==max(y));
x_l = interp1(y(1:max_index),x(1:max_index),max(y)/2,'spline');
x_r = interp1(y(max_index:end),x(max_index:end),max(y)/2,'spline');
res = abs(x_r - x_l);

end