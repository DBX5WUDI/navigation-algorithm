function [attk,Xkpk] = alignvn(imu, att, pos, imuerr, ts)
%功  能：以Vn为量测值，运用卡尔曼滤波方法进行SINS初始对准，
%        状态量为[φ;δV;εb;▽ ]
%输  入: imu - IMU数据
%        att - 粗对准姿态角
%        pos - 初始位置
%        phi0 - 初始失准角估计
%        imuerr - IMU误差参数设置
%        wvn - 速度量测噪声
%        ts - IMU采样间隔
%输  出: att0 - 精对准结果
global glv
    qnb = a2qua(att);       % 姿态角转换为姿态四元数
    vn = zeros(3,1);        % 静基座精对准，SINS速度为0
    eth = earth(pos,vn);    % 参数计算
    nn = 4; nts = nn*ts;    % SINS姿态更新采用四子样算法
    len = fix(length(imu)/nn)*nn;       % 调整IMU数据长度
    attk = zeros(length(imu)/nn,3);     % 预设att存储空间
    Xkpk = zeros(length(imu)/nn,24);    % 预设状态估计及其均方误差存储空间 
      
    %%  卡尔曼滤波初始化
    % 状态估计初始值和均方误差初始值给定
    Xk = zeros(12, 1);                  % 状态量Xk=[φ; δV; εb; ▽ ]  
    Pk = diag([[1; 1; 1]*glv.deg; [1;1;1]; imuerr.eb; imuerr.db])^2;   % 系统速度误差激励噪声序列
    Qk = diag([imuerr.web; imuerr.wdb; zeros(6,1)])^2*nts;             % 系统噪声方差阵
    Rk = diag([1;1;0.1])^2;   % 量测噪声方差阵
    Ft = zeros(12);                     % 连续型系统方程F阵初始化  
    Hk = [zeros(3),eye(3),zeros(3,6)];  % 量测阵
    
    for k=1:nn:len-nn+1
        wvm = imu(k:k+nn-1,1:6);
        [phim, dvbm] = cnscl(wvm,0);
        Cnb = q2mat(qnb);
        dvn = qmulv(rv2q(-eth.wnin*nts/2),qmulv(qnb,dvbm));
        vn = vn+dvn+eth.gn*nts;     % SINS速度更新,或sins计算后vn重置
        qnb = qmul(qnb, rv2q(phim-qmulv(qconj(qnb),eth.wnin*nts)));  % 姿态四元数更新
        
       %%  构造F矩阵
        Ft(1:3,1:3) = askew(-eth.wnie);
        Ft(1:3,7:9) = -Cnb;
        Ft(4:6,1:3) = askew(dvn/nts);  % 无扰动情况下，Ft=-fn×，即F(4,2)=-g;Ft(5,1)=g;
        Ft(4:6,10:12) = Cnb;
        
       %%  时间更新
        Phikk_1 = eye(12)+Ft*nts;       % 计算一步转移阵——φk/k-1
        Pk = Phikk_1*(Pk)*Phikk_1'+Qk;  % 计算一步预测均方误差——Pk/k-1
        Xk = Phikk_1*Xk;                % 计算状态一步预测——Xk/k-1 
 
       %%  量测更新
        Z = vn;                         % 量测量，SINS速度输出
        K = Pk*Hk'*invbc(Hk*Pk*Hk'+Rk);   % 计算滤波增益——Kk
        rk = Z-Hk*Xk;                   % 计算残差——r_k
        Xk = Xk+K*rk;                   % 计算状态估计——Xk
        Pk = (eye(12)-K*Hk)*Pk;         % 计算估计均方误差——Pk
        Pk = (Pk+Pk')/2;                % Pk正交化
       
       %% 反馈校正系数为0.1
        qnb = qmul(rv2q(0.1*Xk(1:3)), qnb); Xk(1:3) = 0.9*Xk(1:3);  
        vn = vn-0.1*Xk(4:6);  Xk(4:6) = 0.9*Xk(4:6);
       
       %% 数据存储
        attk((k+nn-1)/nn,:) = q2att(qnb)';
        Xkpk((k+nn-1)/nn,:) = [Xk; diag(Pk)]';
    end
