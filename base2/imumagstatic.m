%% �趨һ���ϳ�ʱ��ľ�ֹimu���ݽ��ж�׼���൱�ڹ켣������һֱ��ֹ
function [imu,mag] = imumagstatic(att,imuerr,T,ts)
    global glv;
    att0 = att*glv.deg; % ��̬����
    Cbn = a2mat(att0(:))';
    imu = [Cbn*glv.eth.wnie; -Cbn*glv.eth.gn]';
    len = round(T/ts);
    imu = repmat(imu*ts, len, 1);
    imu = imuadderr(imu, imuerr, ts);
    imu(:,7) = (1:len)'*ts;
    
    Bn = zeros(3,1);
    [Bn(2),Bn(1),Bn(3)] = igrf('31-Dec-2019 12:00:00',glv.pos0(1)/glv.deg,...
        glv.pos0(2)/glv.deg, glv.pos0(3)/glv.km);   % �Ÿ�Ӧǿ�ȼ���[BN, BE, BU]
    mag = repmat((Cbn*Bn)', len, 1);
    mag = magerrset(435, 200, mag);         
end

% ��ǿ������趨���㶨ƫ��������λ��nT
function mag = magerrset(mb,wmb,mag)
    [m,n] = size(mag);     
    drift = [ mb + wmb*randn(m,1), mb + wmb*randn(m,1), mb + wmb*randn(m,1)];  
    mag(:,1:3) = mag(:,1:3) + drift;
end