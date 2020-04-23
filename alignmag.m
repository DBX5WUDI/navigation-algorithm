clc
clear
glvf
global glv;

ts = 0.01;                                      % ��������
pnn = 4;                                        % ����׼��������
t_align = 960;                                  % �ܶ�׼ʱ��
t_coarse = 180;                                 % �ֶ�׼ʱ��
attset = [ 12; 13; 60];                         % ��ʼ��̬���趨������Ƕ�ֵ

fprintf('\n************ʵ��ֵ************\n');
fprintf('      ������  %f ��\n',attset(1) );
fprintf('      �����  %f ��\n',attset(2) );
fprintf('      ƫ����  %f ��\n',attset(3) );

imuerr = adiserrset();                                  % imu����趨
% imuerr = imuerrset(0.01, 50, 0.001, 5);               % imu����趨
[imu,mag]= imumagstatic(attset,imuerr,t_align,ts);      % imu��������

imu_coarse = imu(1:t_coarse/ts,:);              % imu�����ֶ�׼������
mag_coarse = mag(1:t_coarse/ts,:);              % imu�����ֶ�׼������
imu_precise = imu(t_coarse/ts+1:t_align/ts,:);  % imu���ھ���׼������

attsb = alignmagsb(imu_coarse, mag_coarse, glv.pos0, ts);                      % ���дֶ�׼

% [attk,Xkpk] = alignvn(imu_precise, attsb, glv.pos0, imuerr, ts);   % ���о���׼
% 
% figure;plot(imu(t_coarse/ts+1:pnn:t_align/ts,7),attk(:,3)/glv.deg,'-b');xygo('y');
% figure;plot(imu(t_coarse/ts+1:pnn:t_align/ts,7),Xkpk(:,1:3)/glv.min);xygo('phi');
% 
% att0 = attk(end,:)';
% fprintf('\n************����׼���************\n');    %��ʾ��ʼ��׼��� 
% fprintf('      ������  %f ��\n',att0(1)/glv.deg );
% fprintf('      �����  %f ��\n',att0(2)/glv.deg );
% fprintf('      ƫ����  %f ��\n',att0(3)/glv.deg );




