function [attk,Xkpk] = alignvn(imu, mag, att, pos, imuerr, ts)
%��  �ܣ���VnΪ����ֵ�����ÿ������˲���������SINS��ʼ��׼��
%        ״̬��Ϊ[��;��V;��b;�� ]
%��  ��: imu - IMU����
%        att - �ֶ�׼��̬��
%        pos - ��ʼλ��
%        phi0 - ��ʼʧ׼�ǹ���
%        imuerr - IMU����������
%        wvn - �ٶ���������
%        ts - IMU�������
%��  ��: att0 - ����׼���
global glv
    qnb = a2qua(att);       % ��̬��ת��Ϊ��̬��Ԫ��
    vn = zeros(3,1);        % ����������׼��SINS�ٶ�Ϊ0
    eth = earth(pos,vn);    % ��������
    nn = 4; nts = nn*ts;    % SINS��̬���²����������㷨
    len = fix(length(imu)/nn)*nn;       % ����IMU���ݳ���
    attk = zeros(length(imu)/nn,3);     % Ԥ��att�洢�ռ�
    Xkpk = zeros(length(imu)/nn,30);    % Ԥ��״̬���Ƽ���������洢�ռ� 
      
    %%  �������˲���ʼ��
    % ״̬���Ƴ�ʼֵ�;�������ʼֵ����
    t = 100;
    Xk = zeros(15, 1);                  % ״̬��Xk=[��; ��V; ��b; ��;Psy ]  
    Pk = diag([[ 1; 1; 1]*glv.deg; [1; 1; 1]; imuerr.eb; imuerr.db; 435; 435; 435])^2;   % ϵͳ�ٶ�������������
    Qk = diag([imuerr.web; imuerr.wdb; zeros(6,1); 200; 200; 200])^2*nts;             % ϵͳ����������
    Rk = diag([1; 1; 1; 200; 200; 200])^2;   % ��������������
    Ft = zeros(15);                     % ������ϵͳ����F���ʼ��  
    
    [Bn(2),Bn(1),Bn(3)] = igrf('31-Dec-2019 12:00:00',glv.pos0(1)/glv.deg,...
        glv.pos0(2)/glv.deg, glv.pos0(3)/glv.km);   % �Ÿ�Ӧǿ�ȼ���[BN, BE, BU]
    Hk = zeros(3,15);  % ������
    Hk(1:3,4:6) = eye(3);
    Hk(4:6,1:3) = askew(Bn');    
      
    for k=1:nn:len-nn+1
        wvm = imu(k:k+nn-1,1:6);
        [phim, dvbm] = cnscl(wvm,0);
        Cnb = q2mat(qnb);
        dvn = qmulv(rv2q(-eth.wnin*nts/2),qmulv(qnb,dvbm));
        vn = vn+dvn+eth.gn*nts;                      % SINS�ٶȸ���,��sins�����vn����
        qnb = qmul(qnb, rv2q(phim-qmulv(qconj(qnb),eth.wnin*nts)));  % ��̬��Ԫ������
        
        M = Cnb*mag(k,1:3)';
        dM = M - Bn';
        
       %%  ����F����
        Ft(1:3,1:3) = askew(-eth.wnie);
        Ft(1:3,7:9) = -Cnb;
        Ft(4:6,1:3) = askew(dvn/nts);  % ���Ŷ�����£�Ft=-fn������F(4,2)=-g;Ft(5,1)=g;
        Ft(4:6,10:12) = Cnb;
        Ft(13:15,13:15) = -eye(3)/t;
        
       %%  ʱ�����
        Phikk_1 = eye(15)+Ft*nts;       % ����һ��ת���󡪡���k/k-1
        Pk = Phikk_1*(Pk)*Phikk_1'+Qk;  % ����һ��Ԥ���������Pk/k-1
        Xk = Phikk_1*Xk;                % ����״̬һ��Ԥ�⡪��Xk/k-1 

       %%  �������
        Z = [vn;dM];                    % ��������SINS�ٶ����
        K = Pk*Hk'*invbc(Hk*Pk*Hk'+Rk); % �����˲����桪��Kk
        rk = Z-Hk*Xk;                   % ����в��r_k
        Xk = Xk+K*rk;                   % ����״̬���ơ���Xk
        Pk = (eye(15)-K*Hk)*Pk;         % ������ƾ�������Pk
        Pk = (Pk+Pk')/2;                % Pk������
       
       %% ����У��ϵ��Ϊ0.1
        qnb = qmul(rv2q(0.1*Xk(1:3)), qnb); Xk(1:3) = 0.9*Xk(1:3);  
        vn = vn-0.1*Xk(4:6);  Xk(4:6) = 0.9*Xk(4:6);
        
       %% ���ݴ洢
        attk((k+nn-1)/nn,:) = q2att(qnb)';
        Xkpk((k+nn-1)/nn,:) = [Xk; diag(Pk)]';
    end
