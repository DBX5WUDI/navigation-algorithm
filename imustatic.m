%% �趨һ���ϳ�ʱ��ľ�ֹimu���ݽ��ж�׼���൱�ڹ켣������һֱ��ֹ
function imu = imustatic(att,imuerr,T,ts)
    global glv;
    att0 = att*glv.deg; % ��̬����
    Cbn = a2mat(att0(:))';
    imu = [Cbn*glv.eth.wnie; -Cbn*glv.eth.gn]';
    len = round(T/ts);
    imu = repmat(imu*ts, len, 1);
    imu = imuadderr(imu, imuerr, ts);
    imu(:,7) = (1:len)'*ts;