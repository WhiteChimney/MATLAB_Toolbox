function [t,temp] = ReadEasyHostTemp(filename)
% 读取淘宝温控数据，t 为时间，temp 为温度

data = readtable(filename,"NumHeaderLines",1,"Delimiter","\t");
t = data{:,2};
temp = data{:,3};



end
