clear;

%% 使用说明
% 将待转换的字符串粘贴至本文件的合适位置，并选中后注释（快捷键 Ctrl+R）
% 将 dataPosition 变量中的数字替换为待转换字符串的起、止行数
% 按格式更改 conversionList 变量中的变量名，左为原变量名，右为改后变量名
% 然后运行即可

% -((-1 + da) E^-((t1 + 
%         t2 + \[Eta] \[Eta]s) \[Mu]0) (-((-1 + 
%           da) E^((t1 + t2) \[Eta] \[Eta]s \[Mu]0) eDet) - 
%      E^((t2 + t1 \[Eta] \[Eta]s) \[Mu]0)
%        eDet + (-1 + da) E^(\[Eta] \[Eta]s \[Mu]0) (eDet + e0 Y0) + 
%      E^((t2 + \[Eta] \[Eta]s) \[Mu]0) (eDet + e0 Y0)))

dataPosition = [9,14];

conversionList = {...
    {'\[Eta]a', 'eta_A'},...
    {'\[Eta]s',	'eta_S'},...
    {'\[Eta]',	'eta'},...
    {'\[Mu]0',	'mu_0'},...
    {'\[Mu]',	'mu'},...
    {'\[Epsilon]',	'e'},...
    {'da',	'dA'},...
    {'eDet',	'e_Det'},...
    };

data_edited = mathematica_conversion(dataPosition,conversionList)


%% 转换函数
function data = mathematica_conversion(dataPosition,conversionList)
if nargin < 2
    conversionList = {};
end

% 读取原始字符串
selfFileName = mfilename('fullpath');
selfFileName = [selfFileName, '.m'];
f = fopen(selfFileName,'r');
for i = 1:(dataPosition(1)-1)
    fgetl(f);
end
data = '';
for i = dataPosition(1):dataPosition(end)
    line = fgetl(f);
    line = strtrim(line(3:end));
    data = [data, line];
end
fclose(f);

% 转换 E^ --> exp()
index = strfind(data,'E^');
for i = 1:length(index)
    if data(index(i)+2) ~= '('
        data = insertAfter(data,index(i)+1,'(');
        ind = strfind(data(index(i):end),' ');
        data = insertBefore(data,index(i)+ind(1)-1,')');
        index = index + 2;
    end
end

% 给相邻项加空格，然后把空格替换成 .*
data = strrep(data,')(',') (');
data = strrep(data,')E^',') E^');
data = strrep(data,' + ','+');
data = strrep(data,' - ','-');
data = strrep(data,'E^','exp');
data = strtrim(data);
data = strrep(data,' ','.*');
data = strrep(data,'/','./');
data = strrep(data,'^','.^');
data = strrep(data,'\\','\');

% 替换自定义字符串
for i = 1:length(conversionList)
    data = strrep(data,conversionList{i}{1},conversionList{i}{2});
end

end