clc
clear
glvf
global glv;

ts = 0.01;                                      % 采样周期
pnn = 4;                                        % 精对准子样个数
t_align = 960;                                  % 总对准时间
t_coarse = 180;                                 % 粗对准时间
attset = [ 12; 13; 60];                         % 初始姿态角设定，填入角度值

fprintf('\n************实际值************\n');
fprintf('      俯仰角  %f °\n',attset(1) );
fprintf('      横滚角  %f °\n',attset(2) );
fprintf('      偏航角  %f °\n',attset(3) );

imuerr = adiserrset();                                  % imu误差设定
% imuerr = imuerrset(0.01, 50, 0.001, 5);               % imu误差设定
[imu,mag]= imumagstatic(attset,imuerr,t_align,ts);      % imu数据生成

imu_coarse = imu(1:t_coarse/ts,:);              % imu用来粗对准的数据
mag_coarse = mag(1:t_coarse/ts,:);              % imu用来粗对准的数据
imu_precise = imu(t_coarse/ts+1:t_align/ts,:);  % imu用于精对准的数据

attsb = alignmagsb(imu_coarse, mag_coarse, glv.pos0, ts);                      % 进行粗对准

% [attk,Xkpk] = alignvn(imu_precise, attsb, glv.pos0, imuerr, ts);   % 进行精对准
% 
% figure;plot(imu(t_coarse/ts+1:pnn:t_align/ts,7),attk(:,3)/glv.deg,'-b');xygo('y');
% figure;plot(imu(t_coarse/ts+1:pnn:t_align/ts,7),Xkpk(:,1:3)/glv.min);xygo('phi');
% 
% att0 = attk(end,:)';
% fprintf('\n************精对准结果************\n');    %显示初始对准结果 
% fprintf('      俯仰角  %f °\n',att0(1)/glv.deg );
% fprintf('      横滚角  %f °\n',att0(2)/glv.deg );
% fprintf('      偏航角  %f °\n',att0(3)/glv.deg );




