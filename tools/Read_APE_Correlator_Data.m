function [time_delay, intensity] = Read_APE_Correlator_Data(filename,nbrHeadlines)
% 读取 APE 自相关仪的数据文件，导出时间轴与强度

if nargin < 2
    nbrHeadlines = 12;
end

f = fopen(filename,'r');

for i = 1:nbrHeadlines
    fgetl(f);
end

time_delay = []; intensity = [];
line = fgetl(f);
while (line ~= -1)
    line = split(strip(line),'	  ');
    if (length(line) == 2)
        time_delay = [time_delay; str2double(line(1))];
        intensity = [intensity; str2double(line(2))];
    end
    line = fgetl(f);
end

fclose(f);

end