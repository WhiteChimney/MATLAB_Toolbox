function [w0_,z_] = gaussian_beam_trans(w0,z,f,lambda)
% 求解高斯光束经薄透镜变换后的束腰半径及束腰位置

zR = pi*w0.^2./lambda;

c = (1-z./f).^2 + zR.^2./f.^2;

w0_ = w0./sqrt(c);

z_ = (1-(1-z./f)./c).*f;

end