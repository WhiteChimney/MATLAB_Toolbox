function [fval,x] = fmaxbnd(fun,x1,x2,options)
% 求解在区间 (x1,x2) 上的单变量函数的最大值，由 fminbnd 修改而来

if nargin < 4
    options = optimset('fminbnd');
end

fun1 = @(x) -fun(x);
[x,fval1] = fminbnd(fun1,x1,x2,options);
fval = -fval1;

end