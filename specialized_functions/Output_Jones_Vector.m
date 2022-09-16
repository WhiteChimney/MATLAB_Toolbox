% 入射V光，求经过一个HWP与QWP后的出射态


%% 预设参数
HWP_angle = 0:22.5:180;      % 半波片旋转角度
QWP_angle = 0:45:180;        % 四分之一波片旋转角度
JV_in = [1;0];               % 输入的Jones向量[V;H]


%% 波片组对入射态的操作
% 将Jones矩阵都放在二维平面上，数组则摞至第三维
HWP_angle = reshape(HWP_angle,1,1,[])*pi/180;
QWP_angle = reshape(QWP_angle,1,1,[])*pi/180;

% 半波片的Jones矩阵
JV_HWP = [cos(2*HWP_angle),  sin(2*HWP_angle);...
          sin(2*HWP_angle), -cos(2*HWP_angle)];

% 四分之一波片的Jones矩阵
JV_QWP = [1i+cos(2*QWP_angle),    sin(2*QWP_angle);...
             sin(2*QWP_angle), 1i-cos(2*QWP_angle)] / sqrt(2);

% 定义的波片组的Jones矩阵
JV_WP = zeros(2,2,length(HWP_angle),length(QWP_angle));

% 定义的输出Jones向量，将其置于元胞内
JV_out = cell(length(HWP_angle),length(QWP_angle));

for i = 1:length(HWP_angle)
    for j = 1:length(QWP_angle)
        JV_WP(:,:,i,j) = JV_QWP(:,:,j) * JV_HWP(:,:,i);
        JV_out{i,j} = JV_WP(:,:,i,j) * JV_in;
    end
end