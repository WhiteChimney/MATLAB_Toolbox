function [avgX, avgY] = averageOverTime(x, y, avgTime)
% 对输入变量 x, y 进行时间累积求平均

data_used = floor(length(x)/avgTime)*avgTime;
avgX = mean(reshape(x(1:data_used),avgTime,[]),1);
avgY = mean(reshape(y(1:data_used),avgTime,[]),1);
end