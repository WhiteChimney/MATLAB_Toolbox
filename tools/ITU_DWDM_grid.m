function [l_s_grid, l_i_grid] = ITU_DWDM_grid(l_s,l_i)
% 给出 DWDM 通道坐标点

c = 299792458;
l_s_min = min(abs(l_s)); l_s_max = max(abs(l_s));
l_i_min = min(abs(l_i)); l_i_max = max(abs(l_i));
channel_s_max = find_ITU_DWDM_channel(l_s_min);
channel_s_min = find_ITU_DWDM_channel(l_s_max);
channel_i_max = find_ITU_DWDM_channel(l_i_min);
channel_i_min = find_ITU_DWDM_channel(l_i_max);

l_s_grid = ITU_DWDM((channel_s_max+0.5):-1:(channel_s_min-0.5));
l_i_grid = ITU_DWDM((channel_i_max+0.5):-1:(channel_i_min-0.5));

if l_s_grid(1) < l_s_min
    l_s_grid = l_s_grid(2:end);
end
if l_s_grid(end) > l_s_max
    l_s_grid = l_s_grid(1:end-1);
end
if l_i_grid(1) < l_i_min
    l_i_grid = l_i_grid(2:end);
end
if l_i_grid(end) > l_i_max
    l_i_grid = l_i_grid(1:end-1);
end

end
