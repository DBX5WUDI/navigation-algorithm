function kf = kfupdate(kf, yk, TimeMeasBoth)
% ���ܣ���ɢʱ��Ŀ������˲�
% ���룺kf - �������˲��ṹ��
%       yk - ��������
%       TimeMeasBoth - ����ģʽ��'T'- ʱ����£�'M'- ������£�'B'- ���߾�����
% �����ʱ��/������º�Ŀ������˲��ṹ��
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
        kf.Pykk_1 = kf.Py0 + kf.Rk;
        kf.Kk = kf.Pxykk_1*invbc(kf.Pykk_1);            % �˲�����
        kf.xk = kf.xkk_1 + kf.Kk*kf.rk;                 % ״̬����
        kf.Pxk = kf.Pxkk_1 - kf.Kk*kf.Pykk_1*kf.Kk';    % ���ƾ������
        kf.Pxk = (kf.Pxk+kf.Pxk')*(kf.fading/2);        % symmetrization & forgetting factor 'fading'
    end
