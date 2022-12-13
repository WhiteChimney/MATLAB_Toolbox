function max_brightness = plot_JSA(JSA,l_s,l_i,mode)
% 默认单位：μm，fs
% mode 为模式选择，可选 'Intensity' 或 'Phase'

c = 0.299792458;

if nargin < 4
    mode = 'Intensity';
end

if (length(l_s) < 2) or (length(l_i) < 2)
    return;
else
    if length(l_s) < 3
        l_s = linspace(l_s(1),l_s(2),1001);
    end
    if length(l_i) < 3
        l_i = linspace(l_i(1),l_i(2),1001);
    end
end

w_s = 2*pi*c./l_s; w_s = reshape(w_s,1,[]); size_s = length(w_s);
w_i = 2*pi*c./l_i; w_i = reshape(w_i,[],1); size_i = length(w_i);

w_ss = repmat(w_s,size_i,1); w_ii = repmat(w_i,1,size_s);

JSI = abs(JSA(w_ss,w_ii)).^2;
max_brightness = max(JSI,[],'all');
JSP = JSA(w_ss,w_ii)./abs(JSA(w_ss,w_ii));

if strcmp(mode,'Phase')
    imagesc(l_s,l_i,JSP);
else
    imagesc(l_s,l_i,JSI);
end
set(gca,'YDir','normal')
xlabel('\lambda_s (μm)')
ylabel('\lambda_i (μm)')
colorbar

end
