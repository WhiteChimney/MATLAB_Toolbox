function channelNo = find_ITU_DWDM_channel(lambda)
% ITU 100GHz DWDM 标准通道，SI unit

c = 299792458;

freq_0 = 193400*1e9;
channelNo_0 = 34;

freq = c./lambda;
channelNo = channelNo_0 + ceil((freq - freq_0)./1e11-0.5);

end