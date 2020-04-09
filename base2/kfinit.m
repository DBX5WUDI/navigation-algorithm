%% 卡尔曼滤波初始化
function kf = kfinit(nts, davp, imuerr, dinst, dKod)
% 功能：卡尔曼滤波初始化，生成'kf'结构体，这段代码通常包括以下参数的设定：Qk,Rk,Pxk,Hk
% 输入：SINS结构体
% 输出：卡尔曼滤波结构体
global glv                              
    kf = [];
    kf.nts = nts;               % 采样总周期
    kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(15,1)])^2;                  % 系统噪声序列方差阵Qt
    kf.Rk = diag(davp(7:9))^2;                                              % 量测噪声序列方差阵Rk
    kf.Pxk = diag([davp; imuerr.eb; imuerr.db; davp(7:9); dinst([1,3])*glv.min; dKod]*10)^2;    
    kf.Hk = zeros(3,21); kf.Hk(:,7:9) = eye(3); kf.Hk(:,16:18) = -eye(3);   %量测阵Hk
    
    [kf.m, kf.n] = size(kf.Hk); % 量测阵的大小
    kf.Kk = zeros(kf.n, kf.m);  % 量测阵转置大小的零矩阵
    kf.xk = zeros(kf.n, 1);     % 系统状态向量
    kf.Qk = kf.Qt*kf.nts;       % 系统噪声序列方差阵Qk
    kf.Gammak = 1;              %系统噪声驱动阵
    kf.fading = 1;