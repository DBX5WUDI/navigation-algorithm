%% 设定一个较长时间的静止imu数据进行对准，相当于轨迹仿真器一直静止
function imu = imustatic(att,imuerr,T,ts)
    global glv;
    att0 = att*glv.deg; % 姿态设置
    Cbn = a2mat(att0(:))';
    imu = [Cbn*glv.eth.wnie; -Cbn*glv.eth.gn]';
    len = round(T/ts);
    imu = repmat(imu*ts, len, 1);
    imu = imuadderr(imu, imuerr, ts);
    imu(:,7) = (1:len)'*ts;