%% 设定一个较长时间的静止imu数据进行对准，相当于轨迹仿真器一直静止
function [imu,mag] = imumagstatic(att,imuerr,T,ts)
    global glv;
    att0 = att*glv.deg; % 姿态设置
    Cbn = a2mat(att0(:))';
    imu = [Cbn*glv.eth.wnie; -Cbn*glv.eth.gn]';
    len = round(T/ts);
    imu = repmat(imu*ts, len, 1);
    imu = imuadderr(imu, imuerr, ts);
    imu(:,7) = (1:len)'*ts;
    
    Bn = zeros(3,1);
    [Bn(2),Bn(1),Bn(3)] = igrf('31-Dec-2019 12:00:00',glv.pos0(1)/glv.deg,...
        glv.pos0(2)/glv.deg, glv.pos0(3)/glv.km);   % 磁感应强度计算[BN, BE, BU]
    mag = repmat((Cbn*Bn)', len, 1);
    mag = magerrset(435, 200, mag);         
end

% 磁强计误差设定，恒定偏差，随机误差，单位：nT
function mag = magerrset(mb,wmb,mag)
    [m,n] = size(mag);     
    drift = [ mb + wmb*randn(m,1), mb + wmb*randn(m,1), mb + wmb*randn(m,1)];  
    mag(:,1:3) = mag(:,1:3) + drift;
end