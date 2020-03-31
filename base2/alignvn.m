function att0 = alignvn(imu, att, pos, phi0, imuerr, wvn, ts)
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
    Xkpk = zeros(length(imu)/nn,24);    % Ԥ��״̬���Ƽ���������洢�ռ� 
    
    %%  �������˲���ʼ��
    Xk = zeros(12, 1);              % ״̬��Xk=[��; ��V; ��b; �� ]  
    Pk = diag([phi0; [0.01;0.01;0.01]; imuerr.eb; imuerr.db])^2;  %�ֶ�׼��
    Qk = diag([imuerr.web; imuerr.wdb; zeros(6,1)])^2*nts;  %����������
    Rk = diag(wvn)^2;               % ������������SINS�ٶ��������������
    Ft = zeros(12);                 % ������ϵͳ����F���ʼ��  
    Hk = [zeros(3),eye(3),zeros(3,6)];  % ������
    
    for k=1:nn:len-nn+1
        wvm = imu(k:k+nn-1,1:6);
        [phim, dvbm] = cnscl(wvm,0);
        Cnb = q2mat(qnb);
        dvn = qmulv(rv2q(-eth.wnin*nts/2),qmulv(qnb,dvbm));
        vn = vn+dvn+eth.gn*nts;     % SINS�ٶȸ���,��sins�����vn����
        qnb = qmul(qnb, rv2q(phim-qmulv(qconj(qnb),eth.wnin*nts)));  % ��̬��Ԫ������
        
       %%  ����F����
        Ft(1:3,1:3) = askew(-eth.wnie);
        Ft(1:3,7:9) = -Cnb;
        Ft(4:6,1:3) = askew(dvn/nts);  % ���Ŷ�����£�Ft=-fn������F(4,2)=-g;Ft(5,1)=g;
        Ft(4:6,10:12) = Cnb;
        
       %%  ʱ�����
        Phikk_1 = eye(12)+Ft*nts;       % ����һ��ת���󡪡���k/k-1
        Pk = Phikk_1*(Pk)*Phikk_1'+Qk;  % ����һ��Ԥ���������Pk/k-1
        Xk = Phikk_1*Xk;                % ����״̬һ��Ԥ�⡪��Xk/k-1 
 
       %%  �������
        Z = vn;                         % ��������SINS�ٶ����
        K = Pk*Hk'*invbc(Hk*Pk*Hk'+Rk);   % �����˲����桪��Kk
        rk = Z-Hk*Xk;                   % ����в��r_k
        Xk = Xk+K*rk;                   % ����״̬���ơ���Xk
        Pk = (eye(12)-K*Hk)*Pk;         % ������ƾ�������Pk
        Pk = (Pk+Pk')/2;                % Pk������
        qnb = qmul(rv2q(0.1*Xk(1:3)), qnb); Xk(1:3) = 0.9*Xk(1:3);  % ����У��ϵ��Ϊ0.1
        vn = vn-0.1*Xk(4:6);  Xk(4:6) = 0.9*Xk(4:6);
        attk((k+nn-1)/nn,:) = q2att(qnb)';
        Xkpk((k+nn-1)/nn,:) = [Xk; diag(Pk)]';
        % waitbar(k/len,hwait,'���ڽ��г�ʼ��׼����ȴ�...');
    end
    att0 = attk(end,:)';
    fprintf('\n************����׼���************\n');    %��ʾ��ʼ��׼��� 
    fprintf('      ������  %f ��\n',att0(1)/glv.deg );
    fprintf('      �����  %f ��\n',att0(2)/glv.deg );
    fprintf('      ƫ����  %f ��\n',att0(3)/glv.deg );
