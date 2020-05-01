clear
glvf
global glv;
ts = 0.01;                                      % 采样周期
pnn = 4;                                        % 精对准子样个数
t_align = 2000;                                  % 总对准时间
t_coarse = 180;                                 % 粗对准时间
attset = [ 10; 10; 30];                     % 初始姿态角设定，填入角度值

fprintf('\n************实际值************\n');
fprintf('      俯仰角  %f °\n',attset(1) );
fprintf('      横滚角  %f °\n',attset(2) );
fprintf('      偏航角  %f °\n',attset(3) );

imuerr = imuerrset(0.01, 50, 0.001, 5);                 % imu误差设定
[imu,mag]= imumagstatic(attset,imuerr,t_align,ts);      % imu数据生成
imu_coarse = imu(1:t_coarse/ts,:);                      % imu用来粗对准的数据
mag_coarse = mag(1:t_coarse/ts,:);                      % imu用来粗对准的数据
imu_precise = imu(t_coarse/ts+1:t_align/ts,:);          % imu用于精对准的数据

attsb = alignsb(imu_coarse, glv.pos0);                  % 进行粗对准
[attk,Xkpk] = alignvn(imu_precise, attsb, glv.pos0, imuerr, ts);    % 进行精对准
figure;
subplot(221); plot(imu_precise(4:4:end,end), attk(:,1:2)/glv.deg); xygo('pr')
subplot(223); plot(imu_precise(4:4:end,end), attk(:,3)/glv.deg); xygo('y');
subplot(222); plot(imu_precise(4:4:end,end), Xkpk(:,7:9)/glv.dph); xygo('eb'); 
subplot(224); plot(imu_precise(4:4:end,end), Xkpk(:,10:12)/glv.ug); xygo('db'); 

att0 = attk(end,:)';

fprintf('\n************精对准结果************\n');   
fprintf('      俯仰角  %f °\n',att0(1)/glv.deg );
fprintf('      横滚角  %f °\n',att0(2)/glv.deg );
fprintf('      偏航角  %f °\n',att0(3)/glv.deg );



