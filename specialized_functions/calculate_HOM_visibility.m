function [V_HOM,p4_0,p4_infty] = calculate_HOM_visibility(l,mu0,d_I,d_S,eta_I,eta_S,p_n,kmax)

l = reshape(l,1,[]);
l = abs(l);
l = l./sum(l);
lN = length(l);

mu_A = mu0(1).*l;
mu_B = mu0(end).*l;

d_I_A = d_I(1); eta_I_A = eta_I(1); 
d_I_B = d_I(end); eta_I_B = eta_I(end); 
d_S_A = d_S(1); eta_S_A = eta_S(1); 
d_S_B = d_S(end); eta_S_B = eta_S(end); 

p_d_I_A = @(n) 1-(1-d_I_A).*(1-eta_I_A).^n;
p_d_I_B = @(n) 1-(1-d_I_B).*(1-eta_I_B).^n;
p_d_S_A = @(n) 1-(1-d_S_A).*(1-eta_S_A).^n;
p_d_S_B = @(n) 1-(1-d_S_B).*(1-eta_S_B).^n;

p_source = @(M,N) p_d_I_A(sum(M)).*p_d_I_B(sum(N)).*prod(p_n(mu_A,M).*p_n(mu_B,N));
p_detect = @(M,N,R) p_d_S_A(sum(M+N-R)).*p_d_S_B(sum(R));

lk = (kmax+1)^lN;

M = generate_M(kmax,lN);
N = M;
MN = generate_MN(M,N);
Rmax = MN(:,1:lN) + MN(:,lN+1:end);
[R,lR] = generate_R(Rmax);
[S,lS] = generate_R(M);
[T,lT] = generate_R(N);
%  MN 与 R 的组合对应关系
% MN(i,:) <--> R(lR(i)+1:lR(i+1),:)

% 下面正式开始计算各种组合下的概率之和
% 当时延为 0 时，干涉低谷处的 4 探测器符合概率
p4_0 = zeros(1,lk^2);
parfor i = 1:lk^2
    r_sum = 0;
    for j = 1:(lR(i+1)-lR(i))
        p_d = p_detect(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        p_i = p_intefere_0(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        r_sum = r_sum + p_d.*p_i;
    end
    p4_0(i) = p_source(MN(i,1:lN),MN(i,lN+1:end)).*r_sum;
end
p4_0 = sum(p4_0);

% 当时延为无穷时，干涉低谷处的 4 探测器符合概率
p4_infty = zeros(lk);
for mi = 1:lk
    for ni = 1:lk
        st_sum = 0;
        for si = 1:(lS(mi+1)-lS(mi))
            for ti = 1:(lT(ni+1)-lT(ni))
                p_d = p_detect(M(mi,:),N(ni,:),S(lS(mi)+si,:)+T(lT(ni)+ti,:));
                p_i = p_intefere_infty(M(mi,:),N(ni,:),S(lS(mi)+si,:),T(lT(ni)+ti,:));
                st_sum = st_sum + p_d.*p_i;
            end
        end
        p4_infty(mi,ni) = p_source(M(mi,:),N(ni,:)).*st_sum;
    end
end
p4_infty = sum(sum(p4_infty));

V_HOM = (p4_infty - p4_0)./p4_infty;


end


%% 自定义子函数
function res = p_intefere_0(M,N,R)
% 干涉项的概率计算，时延为 0
    Ref = 0.5; Trans = 0.5; 
    res = zeros(1,length(M));

    for i = 1:length(M)
        m = M(i); n = N(i); r = R(i);
        s_sum = 0;
        s_min = max([0,r-n]); s_max = min([r,m]);
        for s = s_min:s_max
            s_sum = s_sum + ...
                nchoosek(m,s).*nchoosek(n,r-s).*(-1).^s.*(Ref./Trans).^s;
        end
        res(i) = factorial(m+n-r)./factorial(m).*factorial(r)./factorial(n).*...
                (Trans./Ref).^r.*Trans.^m.*Ref.^n.*s_sum.^2;
    end
    res = prod(res);
end

function res = p_intefere_infty(M,N,S,T)
% 干涉项的概率计算，时延为无穷
    Ref = 0.5; Trans = 0.5; 
    res = zeros(1,length(M));

    for i = 1:length(M)
        m = M(i); n = N(i); s = S(i); t = T(i);
        res(i) = ...
            1./factorial(m).*factorial(m-s).*factorial(s).*...
            1./factorial(n).*factorial(n-t).*factorial(t).*...
            (nchoosek(m,s).*nchoosek(n,t)).^2.*...
            (Ref./Trans).^(s-t).*Trans.^m.*Ref.^n;
    end
    res = prod(res);
end

function M = generate_M(kmax,lN)
% 生成 M 矩阵
lk = (kmax+1)^lN;
M = zeros(lk,lN);
M_count = 0:lk-1;
for i = 1:lk
    M(i,:) = change_base(M_count(i),kmax+1,lN);
end
end

function MN = generate_MN(M,N)
% 生成 MN 矩阵
lkM = size(M,1);
lkN = size(N,1);
lNM = size(M,2);
lNN = size(N,2);
MN = zeros(lkM*lkN,lNM+lNN);
for i = 1:lkM
    for j = 1:lkN
        MN((i-1)*lkM+j,:) = [M(i,:),N(j,:)];
    end
end
end

function [R,lR] = generate_R(Rmax)
% 生成 R 矩阵
lN = size(Rmax,2);
lkk = size(Rmax,1);

lR = zeros(1,lkk);
temp = 0;
for i = 1:lkk
    lR(i) = temp;
    temp = temp + change_base_back(Rmax(i,:),1+Rmax(i,:)) + 1;
end
lR = [lR,temp];

R = zeros(lR(end),lN);
for i = 1:lkk
    lR_count = 0;
    while lR_count < (lR(i+1)-lR(i))
        R(lR(i)+lR_count+1,:) = change_base(lR_count,1+Rmax(i,:),lN);
        lR_count = lR_count + 1;
    end
end

end

