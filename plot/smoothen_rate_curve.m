function [R,index] = smoothen_rate_curve(R0,varargin)
% 去除码率仿真曲线中因算法而出现的毛刺

% 默认参数顺序及默认值：'MaxSlope',0,'StepSize',1,'Rank',1
occupy = [0,0,0];
for i = 1:length(varargin)
    switch class(varargin{i})
        case 'char'
            if strcmp(varargin{i},'MaxSlope')
                kmax = varargin{i+1};
                occupy(1) = 1;
            elseif strcmp(varargin{i},'StepSize')
                dL = varargin{i+1};
                occupy(2) = 1;
            elseif strcmp(varargin{i},'Rank')
                k0 = varargin{i+1};
                occupy(3) = 1;
            end
    end
end
if occupy(1) == 0
    kmax = 0;
end
if occupy(2) == 0
    dL = 1;
end
if occupy(3) == 0
    k0 = 1;
end

% 进行去噪
R = R0;
index = true(size(R0));
for i = (k0+1):length(R0)
    for k = 1:k0
        dk = (R0(i)-R0(i-k))/dL;
        if dk > kmax
            R(i) = nan;
            index(i) = false;
            break;
        end
    end
end

end