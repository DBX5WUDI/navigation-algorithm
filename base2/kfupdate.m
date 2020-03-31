function kf = kfupdate(kf, yk, TimeMeasBoth)
% 功能：离散时间的卡尔曼滤波
% 输入：kf - 卡尔曼滤波结构体
%       yk - 量测向量
%       TimeMeasBoth - 更新模式，'T'- 时间更新，'M'- 量测更新，'B'- 两者均更新
% 输出：时间/量测更新后的卡尔曼滤波结构体
% Notes: (1) the Kalman filter stochastic models is
%      xk = Phikk_1*xk_1 + wk_1
%      yk = Hk*xk + vk
%    where E[wk]=0, E[vk]=0, E[wk*wk']=Qk, E[vk*vk']=Rk, E[wk*vk']=0
%    (2) If kf.adaptive=1, then use Sage-Husa adaptive method (but only for 
%    measurement noise 'Rk'). The 'Rk' adaptive formula is:
%      Rk = b*Rk_1 + (1-b)*(rk*rk'-Hk*Pxkk_1*Hk')
%    where  minimum constrain 'Rmin' and maximum constrain 'Rmax' are
%    considered to avoid divergence.
%    (3) If kf.fading>1, the use fading memory filtering method.
%    (4) Using Pmax&Pmin to constrain Pxk, such that Pmin<=diag(Pxk)<=Pmax.
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
        if kf.adaptive==1  % 自适应卡尔曼滤波标记
            for k=1:kf.m
                ry = kf.rk(k)^2-kf.Py0(k,k);
                if ry<kf.Rmin(k,k), ry = kf.Rmin(k,k); end
                if ry>kf.Rmax(k,k),     kf.Rk(k,k) = kf.Rmax(k,k);
                else                	kf.Rk(k,k) = (1-kf.beta)*kf.Rk(k,k) + kf.beta*ry;
                end
            end
            kf.beta = kf.beta/(kf.beta+kf.b);
        end
        kf.Pykk_1 = kf.Py0 + kf.Rk;
        kf.Kk = kf.Pxykk_1*invbc(kf.Pykk_1);            % 滤波增益
        kf.xk = kf.xkk_1 + kf.Kk*kf.rk;                 % 状态估计
        kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';    % 估计均方误差
        kf.Pxk = (kf.Pxk+kf.Pxk')*(kf.fading/2);        % symmetrization & forgetting factor 'fading'
        if kf.xconstrain==1 
            for k=1:kf.n
                if kf.xk(k)<kf.xmin(k)
                    kf.xk(k)=kf.xmin(k);
                elseif kf.xk(k)>kf.xmax(k)
                    kf.xk(k)=kf.xmax(k);
                end
            end
        end
        if kf.pconstrain==1 
            for k=1:kf.n
                if kf.Pxk(k,k)<kf.Pmin(k)
                    kf.Pxk(k,k)=kf.Pmin(k);
                elseif kf.Pxk(k,k)>kf.Pmax(k)
                    ratio = sqrt(kf.Pmax(k)/kf.Pxk(k,k));
                    kf.Pxk(:,k) = kf.Pxk(:,k)*ratio;  kf.Pxk(k,:) = kf.Pxk(k,:)*ratio;
                end
            end
        end
    end
