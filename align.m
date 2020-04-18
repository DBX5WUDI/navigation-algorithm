clear
glvf
global glv;
ts = 0.01;                                      % ��������
pnn = 4;                                        % ����׼��������
t_align = 960;                                  % �ܶ�׼ʱ��
t_coarse = 180;                                 % �ֶ�׼ʱ��
attset = [ -56; -103; 123];                     % ��ʼ��̬���趨������Ƕ�ֵ

fprintf('\n************ʵ��ֵ************\n');
fprintf('      ������  %f ��\n',attset(1) );
fprintf('      �����  %f ��\n',attset(2) );
fprintf('      ƫ����  %f ��\n',attset(3) );

imuerr = imuerrset(0.01, 50, 0.001, 5);                 % imu����趨
[imu,mag]= imumagstatic(attset,imuerr,t_align,ts);      % imu��������
imu_coarse = imu(1:t_coarse/ts,:);                      % imu�����ֶ�׼������
mag_coarse = mag(1:t_coarse/ts,:);                      % imu�����ֶ�׼������
imu_precise = imu(t_coarse/ts+1:t_align/ts,:);          % imu���ھ���׼������

attsb = alignsb(imu_coarse, glv.pos0);                  % ���дֶ�׼
[attk,Xkpk] = alignvn(imu_precise, attsb, glv.pos0, imuerr, ts);    % ���о���׼
figure;
subplot(311), plot(imu_precise(4:4:end,end),Xkpk(:,1)/glv.deg,'-b',imu_precise(4:4:end,end),repmat((attsb(1)/glv.deg-attset(1)),size(Xkpk,1),1),'k--');
subplot(312), plot(imu_precise(4:4:end,end),Xkpk(:,2)/glv.deg,'-b',imu_precise(4:4:end,end),repmat((attsb(2)/glv.deg-attset(2)),size(Xkpk,1),1),'k--');
subplot(313), plot(imu_precise(4:4:end,end),Xkpk(:,3)/glv.deg,'-b',imu_precise(4:4:end,end),repmat((attsb(3)/glv.deg-attset(3)),size(Xkpk,1),1),'k--');
att0 = attk(end,:)';

fprintf('\n************����׼���************\n');   
fprintf('      ������  %f ��\n',att0(1)/glv.deg );
fprintf('      �����  %f ��\n',att0(2)/glv.deg );
fprintf('      ƫ����  %f ��\n',att0(3)/glv.deg );



