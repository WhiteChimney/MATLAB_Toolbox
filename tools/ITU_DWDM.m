function lambda = ITU_DWDM(channelNo)
% ITU 100GHz DWDM 标准通道，SI unit

c = 299792458;

freq_0 = 193400*1e9;
channelNo_0 = 34;
freq = freq_0 + (channelNo - channelNo_0)*100*1e9;

lambda = c./freq;

end