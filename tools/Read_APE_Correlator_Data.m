function [time_delay, intensity] = Read_APE_Correlator_Data(filename)

f = fopen(filename,'r');

for i = 1:12
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