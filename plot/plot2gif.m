function plot2gif(X,Y,Legend,myPlot,delayTime,file_name)
% 自定义 gif 图制作函数
% 需要使用自定义画图函数 myPlot(x,y,legendText)
% X, Y, Legend 均为 cell 形式
% delayTime 为帧间间隔时间
% file_name 为保存的文件名，缺省时为当前目录下的 'test.git'

if nargin < 6
    file_name = 'test.gif';
end

for i = 1:length(Legend)
    myPlot(X{i},Y{i},Legend{i});
    drawnow;
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    if i == 1
        imwrite(I, map, file_name, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
    else
        imwrite(I, map, file_name, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end

end