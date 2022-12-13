function [wl,inten] = Read_Horiba_Spectrum(file_name,configured_center_wavelength,wavelength_offset)
% 读取 Horiba 单光子谱仪的数据，并将光谱翻转回正确的形状
% 输入参数为：光谱数据文件名，测量时设定的中心波长，波长偏移修正量
% 函数执行步骤：读取数据文件后，将 x 轴（波长）关于设定的中心波长翻转，然后加上波长偏移量

if nargin < 3
    wavelength_offset = 0;
end

data = readmatrix(file_name);
wl = data(:,1);
inten = data(:,2);
wl = wl - configured_center_wavelength;
wl = wl(end:-1:1);
wl = wl + configured_center_wavelength;
wl = wl + wavelength_offset;

end