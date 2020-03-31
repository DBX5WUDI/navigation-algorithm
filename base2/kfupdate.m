function kf = kfupdate(kf, yk, TimeMeasBoth)
% ���ܣ���ɢʱ��Ŀ������˲�
% ���룺kf - �������˲��ṹ��
%       yk - ��������
%       TimeMeasBoth - ����ģʽ��'T'- ʱ����£�'M'- ������£�'B'- ���߾�����
% �����ʱ��/������º�Ŀ������˲��ṹ��
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
    
    if TimeMeasBoth=='T'            % ʱ�����
        kf.xk = kf.Phikk_1*kf.xk;   %״̬һ������
        kf.Pxk = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak';    %һ��Ԥ��������
    else
        if TimeMeasBoth=='M'        % Meas Updating
            kf.xkk_1 = kf.xk;    
            kf.Pxkk_1 = kf.Pxk; 
        elseif TimeMeasBoth=='B'    % Time & Meas Updating
            kf.xkk_1 = kf.Phikk_1*kf.xk;    %״̬һ������
            kf.Pxkk_1 = kf.Phikk_1*kf.Pxk*kf.Phikk_1' + kf.Gammak*kf.Qk*kf.Gammak'; %һ��Ԥ��������
        else
            error('TimeMeasBoth input error!');
        end
        kf.Pxykk_1 = kf.Pxkk_1*kf.Hk';  
        kf.Py0 = kf.Hk*kf.Pxykk_1;
        kf.ykk_1 = kf.Hk*kf.xkk_1;
        kf.rk = yk-kf.ykk_1;
        if kf.adaptive==1  % ����Ӧ�������˲����
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
        kf.Kk = kf.Pxykk_1*invbc(kf.Pykk_1);            % �˲�����
        kf.xk = kf.xkk_1 + kf.Kk*kf.rk;                 % ״̬����
        kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';    % ���ƾ������
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
