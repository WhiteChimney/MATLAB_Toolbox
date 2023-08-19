function my_surf(f_z,x_m,y_m,x_label,y_label,dx,dy)
% 自定义的 surf 函数，方便使用
if length(x_m) == 1
    x_min = -abs(x_m); x_max = abs(x_m);
else
    x_min = min(x_m); x_max = max(x_m);
end
if length(y_m) == 1
    y_min = -abs(y_m); y_max = abs(y_m);
else
    y_min = min(y_m); y_max = max(y_m);
end

if nargin < 6
    dx = (x_max-x_min)/200;
    dy = (y_max-y_min)/200;
end

x = x_min:dx:x_max; y = y_min:dy:y_max;
[X,Y] = meshgrid(x,y);
p_Z = surf(X,Y,f_z(X,Y));
p_Z.EdgeColor = 'none';
xlabel(x_label);
ylabel(y_label);
end