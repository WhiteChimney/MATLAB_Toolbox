function [time_delay, intensity, fit] = Read_APE_Correlator_Data(filename,nbrHeadlines)
% 读取 APE 自相关仪的数据文件，导出时间轴与强度

if nargin < 2
    nbrHeadlines = 12;
end

f = fopen(filename,'r');

for i = 1:nbrHeadlines
    fgetl(f);
end

time_delay = []; intensity = []; fit = [];
line = fgetl(f);
while (line ~= -1)
    line = split(strip(line),'	  ');
    if (length(line) < 4)
        time_delay = [time_delay; str2double(line(1))];
        intensity = [intensity; str2double(line(2))];
        if (length(line) > 2)
            fit = [fit; str2double(line(3))];
        end
    end
    line = fgetl(f);
end

fclose(f);

if (length(intensity) > 19)
    index = intensity == max(intensity);
    time_center = time_delay(index);
    time_center = time_center(1);
    time_delay = time_delay - time_center;

    noise = (sum(intensity(1:10)) + sum(intensity(end-9:end)))/20;
    intensity = intensity - noise;
    intensity = intensity./max(intensity);
end

end