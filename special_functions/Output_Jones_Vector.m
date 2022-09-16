% ����V�⣬�󾭹�һ��HWP��QWP��ĳ���̬


%% Ԥ�����
HWP_angle = 0:22.5:180;      % �벨Ƭ��ת�Ƕ�
QWP_angle = 0:45:180;        % �ķ�֮һ��Ƭ��ת�Ƕ�
JV_in = [1;0];               % �����Jones����[V;H]


%% ��Ƭ�������̬�Ĳ���
% ��Jones���󶼷��ڶ�άƽ���ϣ���������������ά
HWP_angle = reshape(HWP_angle,1,1,[])*pi/180;
QWP_angle = reshape(QWP_angle,1,1,[])*pi/180;

% �벨Ƭ��Jones����
JV_HWP = [cos(2*HWP_angle),  sin(2*HWP_angle);...
          sin(2*HWP_angle), -cos(2*HWP_angle)];

% �ķ�֮һ��Ƭ��Jones����
JV_QWP = [1i+cos(2*QWP_angle),    sin(2*QWP_angle);...
             sin(2*QWP_angle), 1i-cos(2*QWP_angle)] / sqrt(2);

% ����Ĳ�Ƭ���Jones����
JV_WP = zeros(2,2,length(HWP_angle),length(QWP_angle));

% ��������Jones��������������Ԫ����
JV_out = cell(length(HWP_angle),length(QWP_angle));

for i = 1:length(HWP_angle)
    for j = 1:length(QWP_angle)
        JV_WP(:,:,i,j) = JV_QWP(:,:,j) * JV_HWP(:,:,i);
        JV_out{i,j} = JV_WP(:,:,i,j) * JV_in;
    end
end