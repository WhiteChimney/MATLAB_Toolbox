function out = change_base(in,base,l)
% 根据输入、基底、长度进行进制转换计算（十进制转换自定义进制）
if nargin < 3
    if length(base) == 1
        l = floor(log(in)/log(base))+1;
    else
        l = length(base)+1;
    end
end

if length(base) == 1
    out = zeros(1,l);
    for i = l:-1:1
        out(i) = mod(in,base);
        in = floor(in/base);
    end
else
    out = zeros(1,length(base)+1);
    for i = 1:length(base)+1
        temp = floor(in/prod(base(i:end)));
        out(i) = temp;
        in = in - temp*prod(base(i:end));
    end
    if nargin < 3
        while length(out) > 1 && out(1) == 0
            out = out(2:end);
        end
    else
        if length(out) > l
            out = out(length(out)-l+1:end);
        else
            out = [zeros(1,l-length(out)),out];
        end
    end
end
end

