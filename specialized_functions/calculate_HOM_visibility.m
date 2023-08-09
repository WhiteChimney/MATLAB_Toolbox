function [V_HOM_ap,p4,p2,p1] = calculate_HOM_visibility...
                                (l,mu0,d_I,d_S,eta_I,eta_S,p_n,kmax,p_ap)
% 简易光路图
% 源A  源B
%   /\/\
% IA BS IB
%    /\
%  SA  SB
% 
% HOM 干涉可见度计算
% l 为本征值向量
% mu0 为两光源的总平均光子数
% d_I,d_S,eta_I,eta_S 为探测器参数
% 四个探测器的探测效率和暗计数可以不一致
% 但两个源的 signal 从光源到 BS 处的效率需要相同
% 这样可以将光路损耗均纳入探测效率中
% p_n 为光源的光子数分布
% kmax 为计算阶数，一般取 3 的计算量就已经很大了
% p_ap 为后脉冲概率
% 
% 为方便整理，固定变量名的顺序为 iA > iB > sA > sB

l = reshape(l,1,[]);
l = abs(l);
l = l./sum(l);
lN = length(l);

mu_A = mu0(1).*l;
mu_B = mu0(end).*l;

d_I_A = d_I(1);   eta_I_A = eta_I(1); 
d_I_B = d_I(end); eta_I_B = eta_I(end); 
d_S_A = d_S(1);   eta_S_A = eta_S(1); 
d_S_B = d_S(end); eta_S_B = eta_S(end); 

if nargin < 9
    p_ap = 0;
end
if length(p_ap) > 3
    p_ap_iA = p_ap(1);
    p_ap_iB = p_ap(2);
    p_ap_sA = p_ap(3);
    p_ap_sB = p_ap(4);
else
    p_ap_iA = p_ap(1);
    p_ap_iB = p_ap(1);
    p_ap_sA = p_ap(end);
    p_ap_sB = p_ap(end);
end

p_d_I_A = @(n) 1-(1-d_I_A).*(1-eta_I_A).^n;
p_d_I_B = @(n) 1-(1-d_I_B).*(1-eta_I_B).^n;
p_d_S_A = @(n) 1-(1-d_S_A).*(1-eta_S_A).^n;
p_d_S_B = @(n) 1-(1-d_S_B).*(1-eta_S_B).^n;

% source 产生的光子数为 (M,N) 并被不同组合标记的概率
p_source_0 = @(M,N) (1-p_d_I_A(sum(M))).*(1-p_d_I_B(sum(N))).*prod(p_n(mu_A,M).*p_n(mu_B,N));
p_source_A = @(M,N) p_d_I_A(sum(M)).*(1-p_d_I_B(sum(N))).*prod(p_n(mu_A,M).*p_n(mu_B,N));
p_source_B = @(M,N) (1-p_d_I_A(sum(M))).*p_d_I_B(sum(N)).*prod(p_n(mu_A,M).*p_n(mu_B,N));
p_source_AB = @(M,N) p_d_I_A(sum(M)).*p_d_I_B(sum(N)).*prod(p_n(mu_A,M).*p_n(mu_B,N));

% detect 部分对 (M,N,R) 光子组合的响应率
p_detect_0 = @(M,N,R) (1-p_d_S_A(sum(M+N-R))).*(1-p_d_S_B(sum(R)));
p_detect_A = @(M,N,R) p_d_S_A(sum(M+N-R)).*(1-p_d_S_B(sum(R)));
p_detect_B = @(M,N,R) (1-p_d_S_A(sum(M+N-R))).*p_d_S_B(sum(R));
p_detect_AB = @(M,N,R) p_d_S_A(sum(M+N-R)).*p_d_S_B(sum(R));

lk = (kmax+1)^lN;

M = generate_M(kmax,lN);
N = M;
MN = generate_MN(M,N);
Rmax = MN(:,1:lN) + MN(:,lN+1:end);
[R,lR] = generate_R(Rmax);
[S,lS] = generate_R(M);
[T,lT] = generate_R(N);
% MN 与 R 的组合对应关系
% MN(i,:) <--> R(lR(i)+1:lR(i+1),:)

% 下面正式开始计算各种组合下的概率之和

% 以下计数为不包括后脉冲的真实符合计数或单道计数
% 当时延为 0 时，干涉低谷处的探测器响应概率
p4_0 = zeros(1,lk^2);          % 四符合
p3XiA_0 = zeros(1,lk^2);       % IA 不响应，其余三符合
p3XiB_0 = zeros(1,lk^2);       % IB 不响应，其余三符合
p3XsA_0 = zeros(1,lk^2);       % SA 不响应，其余三符合
p3XsB_0 = zeros(1,lk^2);       % SB 不响应，其余三符合
p2iAiB_0 = zeros(1,lk^2);      % 仅有两个 i 响应
p2sAsB_0 = zeros(1,lk^2);      % 仅有两个 s 响应
p2iAsA_0 = zeros(1,lk^2);      % 仅有 sA、iA 响应
p2iAsB_0 = zeros(1,lk^2);      % 仅有 sB、iA 响应
p2iBsA_0 = zeros(1,lk^2);      % 仅有 sA、iB 响应
p2iBsB_0 = zeros(1,lk^2);      % 仅有 sB、iB 响应
p1iA_0 = zeros(1,lk^2);        % 仅有 iA 响应
p1iB_0 = zeros(1,lk^2);        % 仅有 iB 响应
p1sA_0 = zeros(1,lk^2);        % 仅有 sA 响应
p1sB_0 = zeros(1,lk^2);        % 仅有 sB 响应
parfor i = 1:lk^2
    r_sum_0 = 0;
    r_sum_A = 0;
    r_sum_B = 0;
    r_sum_AB = 0;
    for j = 1:(lR(i+1)-lR(i))
        p_d_0 = p_detect_0(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        p_d_A = p_detect_A(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        p_d_B = p_detect_B(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        p_d_AB = p_detect_AB(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        p_i = p_intefere_0(MN(i,1:lN),MN(i,lN+1:end),R(lR(i)+j,:));
        r_sum_0 = r_sum_0 + p_d_0.*p_i;
        r_sum_A = r_sum_A + p_d_A.*p_i;
        r_sum_B = r_sum_B + p_d_B.*p_i;
        r_sum_AB = r_sum_AB + p_d_AB.*p_i;
    end
    p4_0(i) = p_source_AB(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_AB;
    p3XiA_0(i) = p_source_B(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_AB;
    p3XiB_0(i) = p_source_A(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_AB;
    p3XsA_0(i) = p_source_AB(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_B;
    p3XsB_0(i) = p_source_AB(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_A;
    p2iAiB_0(i) = p_source_AB(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_0;
    p2sAsB_0(i) = p_source_0(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_AB;
    p2iAsA_0(i) = p_source_A(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_A;
    p2iAsB_0(i) = p_source_A(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_B;
    p2iBsA_0(i) = p_source_B(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_A;
    p2iBsB_0(i) = p_source_B(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_B;
    p1iA_0(i) = p_source_A(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_0;
    p1iB_0(i) = p_source_B(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_0;
    p1sA_0(i) = p_source_0(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_A;
    p1sB_0(i) = p_source_0(MN(i,1:lN),MN(i,lN+1:end)).*r_sum_B;
end
p4_0 = sum(p4_0);
p3XiA_0 = sum(p3XiA_0);
p3XiB_0 = sum(p3XiB_0);
p3XsA_0 = sum(p3XsA_0);
p3XsB_0 = sum(p3XsB_0);
p2iAiB_0 = sum(p2iAiB_0);
p2sAsB_0 = sum(p2sAsB_0);
p2iAsA_0 = sum(p2iAsA_0);
p2iAsB_0 = sum(p2iAsB_0);
p2iBsA_0 = sum(p2iBsA_0);
p2iBsB_0 = sum(p2iBsB_0);
p1iA_0 = sum(p1iA_0);
p1iB_0 = sum(p1iB_0);
p1sA_0 = sum(p1sA_0);
p1sB_0 = sum(p1sB_0);
p_single_iA_0 = p4_0 + ...
              p3XsA_0 + p3XsB_0 + p3XiB_0 + ...
              p2iAiB_0 + p2iAsA_0 + p2iAsB_0 + ...
              p1iA_0;
p_single_iB_0 = p4_0 + ...
              p3XsA_0 + p3XsB_0 + p3XiA_0 + ...
              p2iAiB_0 + p2iBsA_0 + p2iBsB_0 + ...
              p1iB_0;
p_single_sA_0 = p4_0 + ...
              p3XsB_0 + p3XiA_0 + p3XiB_0 + ...
              p2sAsB_0 + p2iAsA_0 + p2iBsA_0 + ...
              p1sA_0;
p_single_sB_0 = p4_0 + ...
              p3XsA_0 + p3XiA_0 + p3XiB_0 + ...
              p2sAsB_0 + p2iAsB_0 + p2iBsB_0 + ...
              p1sB_0;

% 当时延为无穷时，干涉低谷处的 4 探测器符合概率
p4_infty = zeros(1,lk^2);          % 四符合
p3XiA_infty = zeros(1,lk^2);       % IA 不响应，其余三符合
p3XiB_infty = zeros(1,lk^2);       % IB 不响应，其余三符合
p3XsA_infty = zeros(1,lk^2);       % SA 不响应，其余三符合
p3XsB_infty = zeros(1,lk^2);       % SB 不响应，其余三符合
p2iAiB_infty = zeros(1,lk^2);        % 仅有两个 i 响应
p2sAsB_infty = zeros(1,lk^2);        % 仅有两个 s 响应
p2iAsA_infty = zeros(1,lk^2);      % 仅有 sA、iA 响应
p2iAsB_infty = zeros(1,lk^2);      % 仅有 sB、iA 响应
p2iBsA_infty = zeros(1,lk^2);      % 仅有 sA、iB 响应
p2iBsB_infty = zeros(1,lk^2);      % 仅有 sB、iB 响应
p1iA_infty = zeros(1,lk^2);        % 仅有 iA 响应
p1iB_infty = zeros(1,lk^2);        % 仅有 iB 响应
p1sA_infty = zeros(1,lk^2);        % 仅有 sA 响应
p1sB_infty = zeros(1,lk^2);        % 仅有 sB 响应
parfor mi = 1:lk
    for ni = 1:lk
        st_sum_0 = 0;
        st_sum_A = 0;
        st_sum_B = 0;
        st_sum_AB = 0;
        for si = 1:(lS(mi+1)-lS(mi))
            for ti = 1:(lT(ni+1)-lT(ni))
                p_d_0 = p_detect_0(M(mi,:),N(ni,:),S(lS(mi)+si,:)+T(lT(ni)+ti,:));
                p_d_A = p_detect_A(M(mi,:),N(ni,:),S(lS(mi)+si,:)+T(lT(ni)+ti,:));
                p_d_B = p_detect_B(M(mi,:),N(ni,:),S(lS(mi)+si,:)+T(lT(ni)+ti,:));
                p_d_AB = p_detect_AB(M(mi,:),N(ni,:),S(lS(mi)+si,:)+T(lT(ni)+ti,:));
                p_i = p_intefere_infty(M(mi,:),N(ni,:),S(lS(mi)+si,:),T(lT(ni)+ti,:));
                st_sum_0 = st_sum_0 + p_d_0.*p_i;
                st_sum_A = st_sum_A + p_d_A.*p_i;
                st_sum_B = st_sum_B + p_d_B.*p_i;
                st_sum_AB = st_sum_AB + p_d_AB.*p_i;
            end
        end
        p4_infty(mi,ni) = p_source_AB(M(mi,:),N(ni,:)).*st_sum_AB;
        p3XiA_infty(mi,ni) = p_source_B(M(mi,:),N(ni,:)).*st_sum_AB;
        p3XiB_infty(mi,ni) = p_source_A(M(mi,:),N(ni,:)).*st_sum_AB;
        p3XsA_infty(mi,ni) = p_source_AB(M(mi,:),N(ni,:)).*st_sum_B;
        p3XsB_infty(mi,ni) = p_source_AB(M(mi,:),N(ni,:)).*st_sum_A;
        p2iAiB_infty(mi,ni) = p_source_AB(M(mi,:),N(ni,:)).*st_sum_0;
        p2sAsB_infty(mi,ni) = p_source_0(M(mi,:),N(ni,:)).*st_sum_AB;
        p2iAsA_infty(mi,ni) = p_source_A(M(mi,:),N(ni,:)).*st_sum_A;
        p2iAsB_infty(mi,ni) = p_source_A(M(mi,:),N(ni,:)).*st_sum_B;
        p2iBsA_infty(mi,ni) = p_source_B(M(mi,:),N(ni,:)).*st_sum_A;
        p2iBsB_infty(mi,ni) = p_source_B(M(mi,:),N(ni,:)).*st_sum_B;
        p1iA_infty(mi,ni) = p_source_A(M(mi,:),N(ni,:)).*st_sum_0;
        p1iB_infty(mi,ni) = p_source_B(M(mi,:),N(ni,:)).*st_sum_0;
        p1sA_infty(mi,ni) = p_source_0(M(mi,:),N(ni,:)).*st_sum_A;
        p1sB_infty(mi,ni) = p_source_0(M(mi,:),N(ni,:)).*st_sum_B;
    end
end
p4_infty = sum(sum(p4_infty));
p3XiA_infty = sum(sum(p3XiA_infty));
p3XiB_infty = sum(sum(p3XiB_infty));
p3XsA_infty = sum(sum(p3XsA_infty));
p3XsB_infty = sum(sum(p3XsB_infty));
p2sAsB_infty = sum(sum(p2sAsB_infty));
p2iAiB_infty = sum(sum(p2iAiB_infty));
p2iAsA_infty = sum(sum(p2iAsA_infty));
p2iAsB_infty = sum(sum(p2iAsB_infty));
p2iBsA_infty = sum(sum(p2iBsA_infty));
p2iBsB_infty = sum(sum(p2iBsB_infty));
p1iA_infty = sum(sum(p1iA_infty));
p1iB_infty = sum(sum(p1iB_infty));
p1sA_infty = sum(sum(p1sA_infty));
p1sB_infty = sum(sum(p1sB_infty));
p_single_iA_infty = p4_infty + ...
                    p3XsA_infty + p3XsB_infty + p3XiB_infty + ...
                    p2iAiB_infty + p2iAsA_infty + p2iAsB_infty + ...
                    p1iA_infty;
p_single_iB_infty = p4_infty + ...
                    p3XsA_infty + p3XsB_infty + p3XiA_infty + ...
                    p2iAiB_infty + p2iBsA_infty + p2iBsB_infty + ...
                    p1iB_infty;
p_single_sA_infty = p4_infty + ...
                    p3XsB_infty + p3XiA_infty + p3XiB_infty + ...
                    p2sAsB_infty + p2iAsA_infty + p2iBsA_infty + ...
                    p1sA_infty;
p_single_sB_infty = p4_infty + ...
                    p3XsA_infty + p3XiA_infty + p3XiB_infty + ...
                    p2sAsB_infty + p2iAsB_infty + p2iBsB_infty + ...
                    p1sB_infty;

% 通过单道计数率计算后脉冲概率
p_ap_iA_0 = p_ap_iA.*p_single_iA_0;
p_ap_iB_0 = p_ap_iB.*p_single_iB_0;
p_ap_sA_0 = p_ap_sA.*p_single_sA_0;
p_ap_sB_0 = p_ap_sB.*p_single_sB_0;
p_ap_iA_infty = p_ap_iA.*p_single_iA_infty;
p_ap_iB_infty = p_ap_iB.*p_single_iB_infty;
p_ap_sA_infty = p_ap_sA.*p_single_sA_infty;
p_ap_sB_infty = p_ap_sB.*p_single_sB_infty;

% 计算后脉冲影响后的四符合率
p4_0_ap = p4_0 + ...
    p3XsA_0.*p_ap_sA_0 + p3XsB_0.*p_ap_sB_0 + ...
    p3XiA_0.*p_ap_iA_0 + p3XiB_0.*p_ap_iB_0 + ...
    p2sAsB_0.*p_ap_iA_0.*p_ap_iB_0 + p2iAiB_0.*p_ap_sA_0.*p_ap_sB_0 + ...
    p2iAsA_0.*p_ap_sB_0.*p_ap_iB_0 + p2iBsA_0.*p_ap_sB_0.*p_ap_iA_0 + ...
    p2iAsB_0.*p_ap_sA_0.*p_ap_iB_0 + p2iBsB_0.*p_ap_sA_0.*p_ap_iA_0 + ...
    (p1sA_0.*p_ap_iA_0 + p1iA_0.*p_ap_sA_0).*p_ap_sB_0.*p_ap_iB_0 + ...
    (p1sB_0.*p_ap_iB_0 + p1iB_0.*p_ap_sB_0).*p_ap_sA_0.*p_ap_iA_0 + ...
    p_ap_sA_0.*p_ap_iA_0.*p_ap_sB_0.*p_ap_iB_0;

p4_infty_ap = p4_infty + ...
    p3XsA_infty.*p_ap_sA_infty + p3XsB_infty.*p_ap_sB_infty + ...
    p3XiA_infty.*p_ap_iA_infty + p3XiB_infty.*p_ap_iB_infty + ...
    p2sAsB_infty.*p_ap_iA_infty.*p_ap_iB_infty + p2iAiB_infty.*p_ap_sA_infty.*p_ap_sB_infty + ...
    p2iAsA_infty.*p_ap_sB_infty.*p_ap_iB_infty + p2iBsA_infty.*p_ap_sB_infty.*p_ap_iA_infty + ...
    p2iAsB_infty.*p_ap_sA_infty.*p_ap_iB_infty + p2iBsB_infty.*p_ap_sA_infty.*p_ap_iA_infty + ...
    (p1sA_infty.*p_ap_iA_infty + p1iA_infty.*p_ap_sA_infty).*p_ap_sB_infty.*p_ap_iB_infty + ...
    (p1sB_infty.*p_ap_iB_infty + p1iB_infty.*p_ap_sB_infty).*p_ap_sA_infty.*p_ap_iA_infty + ...
    p_ap_sA_infty.*p_ap_iA_infty.*p_ap_sB_infty.*p_ap_iB_infty;

% V_HOM = (p4_infty - p4_0)./p4_infty;

V_HOM_ap = (p4_infty_ap - p4_0_ap)./p4_infty_ap;

% 返回各响应率，用于实验比对
p4 = {p4_0_ap;
      p4_infty_ap};

p2iAiB_0_ap = p2iAiB_0 + p1iA_0.*p_ap_iB_0 + p1iB_0.*p_ap_iA_0 + p_ap_iA_0.*p_ap_iB_0;
p2sAsB_0_ap = p2sAsB_0 + p1sA_0.*p_ap_sB_0 + p1sB_0.*p_ap_sA_0 + p_ap_sA_0.*p_ap_sB_0;
p2iAsA_0_ap = p2iAsA_0 + p1iA_0.*p_ap_sA_0 + p1sA_0.*p_ap_iA_0 + p_ap_iA_0.*p_ap_sA_0;
p2iAsB_0_ap = p2iAsB_0 + p1iA_0.*p_ap_sB_0 + p1sB_0.*p_ap_iA_0 + p_ap_iA_0.*p_ap_sB_0;
p2iBsA_0_ap = p2iBsA_0 + p1iB_0.*p_ap_sA_0 + p1sA_0.*p_ap_iB_0 + p_ap_iB_0.*p_ap_sA_0;
p2iBsB_0_ap = p2iBsB_0 + p1iB_0.*p_ap_sB_0 + p1sB_0.*p_ap_iB_0 + p_ap_iB_0.*p_ap_sB_0;
p2iAiB_infty_ap = p2iAiB_infty + p1iA_infty.*p_ap_iB_infty + p1iB_infty.*p_ap_iA_infty + p_ap_iA_infty.*p_ap_iB_infty;
p2sAsB_infty_ap = p2sAsB_infty + p1sA_infty.*p_ap_sB_infty + p1sB_infty.*p_ap_sA_infty + p_ap_sA_infty.*p_ap_sB_infty;
p2iAsA_infty_ap = p2iAsA_infty + p1iA_infty.*p_ap_sA_infty + p1sA_infty.*p_ap_iA_infty + p_ap_iA_infty.*p_ap_sA_infty;
p2iAsB_infty_ap = p2iAsB_infty + p1iA_infty.*p_ap_sB_infty + p1sB_infty.*p_ap_iA_infty + p_ap_iA_infty.*p_ap_sB_infty;
p2iBsA_infty_ap = p2iBsA_infty + p1iB_infty.*p_ap_sA_infty + p1sA_infty.*p_ap_iB_infty + p_ap_iB_infty.*p_ap_sA_infty;
p2iBsB_infty_ap = p2iBsB_infty + p1iB_infty.*p_ap_sB_infty + p1sB_infty.*p_ap_iB_infty + p_ap_iB_infty.*p_ap_sB_infty;

p2 = {[p2iAiB_0_ap;
       p2sAsB_0_ap;
       p2iAsA_0_ap;
       p2iAsB_0_ap;
       p2iBsA_0_ap;
       p2iBsB_0_ap];
      [p2iAiB_infty_ap;
       p2sAsB_infty_ap;
       p2iAsA_infty_ap;
       p2iAsB_infty_ap;
       p2iBsA_infty_ap;
       p2iBsB_infty_ap]};

p1 = {[p1iA_0 + p_ap_iA_0;
       p1iB_0 + p_ap_iB_0;
       p1sA_0 + p_ap_sA_0;
       p1sB_0 + p_ap_sB_0;];
      [p1iA_infty + p_ap_iA_infty;
       p1iB_infty + p_ap_iB_infty;
       p1sA_infty + p_ap_sA_infty;
       p1sB_infty + p_ap_sB_infty;];};

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

