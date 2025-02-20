function bar3withBox(data,varargin)
% 绘制带空心外壳的三维柱状图

% 默认参数顺序及默认值：
% 'index',size(data),'height',1,'lineWidth',0.5,'barWidth',0.8,
% 'customLabels',none
occupy = zeros(1,6);
for i = 1:length(varargin)
    switch class(varargin{i})
        case 'char'
            if strcmp(varargin{i},'index')
                index = varargin{i+1};
                occupy(1) = 1;
            elseif strcmp(varargin{i},'height')
                height = varargin{i+1};
                occupy(2) = 1;
            elseif strcmp(varargin{i},'lineWidth')
                lineWidth = varargin{i+1};
                occupy(3) = 1;
            elseif strcmp(varargin{i},'barWidth')
                barWidth = varargin{i+1};
                occupy(4) = 1;
            elseif strcmp(varargin{i},'customLabels')
                customLabels = varargin{i+1};
                occupy(5) = 1;
            elseif strcmp(varargin{i},'zLim')
                zLim = varargin{i+1};
                occupy(6) = 1;
    end
end
if occupy(1) == 0
    [m,n] = size(data);
    index = [reshape(repmat(1:m,n,1),1,[]);
             repmat(1:n,1,m)]; % 2 行 N 列的 index 矩阵，每一列表示一个柱体的坐标
else
    if size(index,1) ~= 2
        index = index';
    end
    if size(index,1) ~= 2
        disp('坐标矩阵的形状不合适')
        return;
    end
end
if occupy(2) == 0
    height = 1;
end
if occupy(3) == 0
    lineWidth = 0.5;  % 默认线宽
end
if occupy(4) == 0
    barWidth = 0.8;   % 默认柱宽
end

hBar = bar3(data);  % 绘制三维柱状图
hold on;

if occupy(5) == 1
    if size(customLabels,1) ~= 2
        customLabels = customLabels';
    end
    xticklabels(customLabels(1,:));
    yticklabels(customLabels(2,:));
end
if occupy(6) == 1
    zlim(zLim);
end

% set(gca,'YDir','normal')


% 对每个柱体循环
for k = 1:size(index,2)
    i = index(1,k);
    j = index(2,k);

     % 计算柱子中心（默认 bar3 会将柱子中心安排在整数位置）
     x_center = j;
     y_center = i;
     % 根据默认柱宽计算底面左下角坐标
     x0 = x_center - barWidth/2;
     y0 = y_center - barWidth/2;
     % 定义空心柱体顶面四个角的坐标（高度固定为1）
     Xtop = [x0, x0+barWidth, x0+barWidth, x0];
     Ytop = [y0, y0, y0+barWidth, y0+barWidth];
     Ztop = height*ones(1,4);  % 顶面高度为1

     % 用 patch 绘制顶面轮廓（FaceColor设为 'none' 仅显示边框）
     patch(Xtop, Ytop, Ztop, 'w', 'FaceColor', 'none', ...
           'EdgeColor', 'k', 'LineWidth', lineWidth);

     % 获取该柱体原始数据的高度（即 bar3 绘制的高度）
     zBar = data(i,j);
     % 绘制四条垂直边，连接原始柱顶和空心柱体顶
     for k = 1:4
         plot3([Xtop(k), Xtop(k)], [Ytop(k), Ytop(k)], [zBar, height], ...
               'k', 'LineWidth', lineWidth);
     end

end

hold off;

end