%% 卡尔曼滤波初始化
function kf = kfinit(varargin)
% 功能：卡尔曼滤波初始化，生成'kf'结构体，这段代码通常包括以下参数的设定：Qk,Rk,Pxk,Hk
% 输入：SINS结构体
% 输出：卡尔曼滤波结构体
global glv                              
    kf = [];
    r = 2.000;
    [nts, davp, imuerr, dinst, dKod, dT] = setvals(varargin);
    kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(9+3+4*1,1)])^2;             % 系统噪声序列方差阵Qt
    kf.Rk = diag([r/glv.Re;r/glv.Re; r])^2;
%    kf.Rk = diag(davp(7:9))^2;                                              % 量测噪声序列方差阵Rk
    kf.Pxk = diag([davp; imuerr.eb; imuerr.db; davp(7:9); dinst([1,3])*glv.min; dKod; dT]*10)^2;    
    kf.Hk = zeros(3,22); kf.Hk(:,7:9) = eye(3); kf.Hk(:,16:18) = -eye(3);   %量测阵Hk
    kf = kfinit0(kf, nts);
    