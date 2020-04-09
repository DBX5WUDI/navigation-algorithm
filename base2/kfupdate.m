function kf = kfupdate(kf, yk, TimeMeasBoth)
% 功能：离散时间的卡尔曼滤波
% 输入：kf - 卡尔曼滤波结构体
%       yk - 量测向量
%       TimeMeasBoth - 更新模式，'T'- 时间更新，'M'- 量测更新，'B'- 两者均更新
% 输出：时间/量测更新后的卡尔曼滤波结构体
    if nargin==1;
        TimeMeasBoth = 'T';
    elseif nargin==2
        TimeMeasBoth = 'B';
    end
    
    if TimeMeasBoth=='T'            % 时间更新
        kf.xk = kf.Phikk_1*kf.xk;   %状态一步更新
        kf.Pxk = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak';    %一步预测均方误差
    else
        if TimeMeasBoth=='M'        % Meas Updating
            kf.xkk_1 = kf.xk;    
            kf.Pxkk_1 = kf.Pxk; 
        elseif TimeMeasBoth=='B'    % Time & Meas Updating
            kf.xkk_1 = kf.Phikk_1*kf.xk;    %状态一步更新
            kf.Pxkk_1 = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak'; %一步预测均方误差
        else
            error('TimeMeasBoth input error!');
        end
        kf.Pxykk_1 = kf.Pxkk_1*kf.Hk';  
        kf.Py0 = kf.Hk*kf.Pxykk_1;
        kf.ykk_1 = kf.Hk*kf.xkk_1;
        kf.rk = yk-kf.ykk_1;
        kf.Pykk_1 = kf.Py0 + kf.Rk;
        kf.Kk = kf.Pxykk_1*invbc(kf.Pykk_1);            % 滤波增益
        kf.xk = kf.xkk_1 + kf.Kk*kf.rk;                 % 状态估计
        kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';    % 估计均方误差
        kf.Pxk = (kf.Pxk+kf.Pxk')*(kf.fading/2);        % symmetrization & forgetting factor 'fading'
    end
