function [lambda, power] = Read_EXFO_Spectrum(filename)
% 读取 EXFO-FTB2 光谱分析报告文件中的数据

f = fopen(filename,'r');

line = fgetl(f);
while (line ~= -1)
    if (~isempty(line))
        if (line(1) == "λ")
            break;
        end
    end
    line = fgetl(f);
    line = append(line, ' ');
end

lambda = []; power = [];
line = fgetl(f);
while (line)
    line = split(line,"	");
    if (~isempty(line))
        lambda = [lambda, str2double(line(1))];
        power = [power, str2double(line(2))];
    end
    line = fgetl(f);
end

fclose(f);

end
