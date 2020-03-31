function kf = kfinit0(kf, nts)
% 功能：kf结构体中其它量的初始化
% 输入：kf-只有Qt，Rk，Pxk,Hk的卡尔曼滤波参数结构体，nts-总采样周期
% 输出：更新后的kf结构体
    kf.nts = nts;               %采样总周期
    [kf.m, kf.n] = size(kf.Hk); %量测阵的大小
    kf.I = eye(kf.n);           %量测阵的列数
    kf.Kk = zeros(kf.n, kf.m);  %量测阵转置大小的零矩阵
    if ~isfield(kf, 'xk'),  kf.xk = zeros(kf.n, 1);  end    
    if ~isfield(kf, 'Qk'),  kf.Qk = kf.Qt*kf.nts;  end              %系统噪声序列方差阵Qk
    if ~isfield(kf, 'Gammak'),  kf.Gammak = 1; kf.l = kf.n;  end    %系统噪声驱动阵
    if ~isfield(kf, 'fading'),  kf.fading = 1;  end
    if ~isfield(kf, 'adaptive'),  kf.adaptive = 0;  end
    if kf.adaptive==1
        if ~isfield(kf, 'b'),  kf.b = 0.9;  end
        if ~isfield(kf, 'beta'),  kf.beta = 1;  end
        if ~isfield(kf, 'Rmin'),  kf.Rmin = 0.01*kf.Rk;  end
        if ~isfield(kf, 'Rmax'),  kf.Rmax = 100*kf.Rk;  end
        if ~isfield(kf, 'Qmin'),  kf.Qmin = 0.01*kf.Qk;  end
        if ~isfield(kf, 'Qmax'),  kf.Qmax = 100*kf.Qk;  end
    end
    if ~isfield(kf, 'xtau'),  kf.xtau = ones(size(kf.xk))*eps;   end    % eps = 2^(-52)
    if ~isfield(kf, 'T_fb'),  kf.T_fb = 1;   end
    if ~isfield(kf, 'xconstrain'),  kf.xconstrain = 0;  end % 状态估计驱动
    if ~isfield(kf, 'pconstrain'),  kf.pconstrain = 0;  end %
    kf.xfb = zeros(kf.n, 1);
    xtau = kf.xtau;
    xtau(kf.xtau<kf.T_fb) = kf.T_fb; 
    kf.coef_fb = kf.T_fb./xtau;  %2015-2-22