%% SINS_DR��ϵ���������
clear
glvf
%% ��ϵ�����ʼ��׼����ʼ��׼ģ�飬�ɵ���ע�ͣ�
%{
t_align = 100;
t_coarse = 40;
imu_coarse = imu(1:t_coarse/ts,:);
attsb = alignsb(imu_coarse, trj.avp0(7:9,1)); 
imu_precise = imu(t_coarse/ts+1:t_align/ts,:); 
phi = [0.05; 0.05; 0.1]*glv.deg;
wvn = [0.001;0.001;0.001];                      % SINS�ٶ��������
trjod.avp0(1,1:3) = alignvn(imu_precise, attsb, trj.avp0(7:9,1), phi, imuerr, wvn, ts); % ��׼��������ʼ��̬����
%}
%% SINS_DR������ʼ������ֵ����
trjod = trjfile('trjod.mat');
[nn, ts, nts] = nnts(2, trjod.ts); 
inst = [3;60;6];  kod = 1;dT = 0.01;
davp = avpseterr([30;30;10], 0, 10); 
imuerr = adiserrset(); % ������������趨
dinst = [15;0;10]; dkod = 0.01; % ����ǰ�װ���壬����ǿ̶�ϵ������

imu = trjod.imu;
ins = insinit(avpadderr(trjod.avp0,davp), ts);  % INS��ʼ���룬INS�ṹ���ʼ��
dr = drinit(avpadderr(trjod.avp0,davp), d2r((inst+dinst)/60), kod*(1+dkod), ts);    % DR��ʼ���룬DR�ṹ���ʼ��

kf = kfinit(nts, davp, imuerr, dinst, dkod, dT);                    % �������˲���ʼ��
len = length(imu);                                                  % IMU���ݵ�����
[dravp, insavp, xkpk] = prealloc(fix(len/nn), 10, 10, 2*kf.n+1);    % DR������ֵ��INS������ֵ���ռ�Ԥ���䣨fix-���㿿£��ȡ����
ki = timebar(nn, len, 'SINS/DR simulation.');                       % ���ӻ�������

for k=1:nn:len-nn+1                             % ��ʼ˫����ѭ��
    k1 = k+nn-1;                                % ���һ����������Ϊ�ڶ�������
    wvm = imu(k:k1,1:6);  dS = sum(trjod.od(k:k1,1)); t = imu(k1,end);  % ȡ��IMU���ݣ�OD���ݣ�t-��ʾʵʱʱ��
    ins = insupdate(ins, wvm);                  % INS��ֵ����
    dr.qnb = ins.qnb;                           % DRϵͳ��̬������INS��̬�������
    dr = drupdate(dr, wvm(:,1:3), dS);          % DR ��ֵ����
    kf.Phikk_1 = kffk(ins);                     % ��k��k-1ֵ����
    kf = kfupdate(kf);                          % �������˲����£���������ʱ�����
    if mod(k1,10)==0                            % k1����10����0����k1Ϊ10�ı���
        kf.Hk(:,22) = -ins.Mpvvn;     
        kf = kfupdate(kf, ins.pos-dr.pos);      % �������˲�ʱ��������������
        [kf, ins] = kffeedback(kf, ins, 1);     % ���ٶ���Ϊ����ֵ���������˲�������INSϵͳ
    end
    insavp(ki,:) = [ins.avp; t]';               % ����ֵ
    dravp(ki,:) = [dr.avp; t]';                 % ����������ֵ
    xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';     % ״̬���ƺ�һ��Ԥ��������ֵ�洢
    ki = timebar;                               % ki����ֵ
end
i_ref1 = find(trjod.avp(:,end)==insavp(1,end));
i_ref2 = find(trjod.avp(:,end)==insavp(ki-1,end));
avperr = [aa2phi(insavp(:,1:3),trjod.avp(i_ref1:nn:i_ref2,1:3)),insavp(:,4:9)-trjod.avp(i_ref1:nn:i_ref2,4:9),insavp(:,end)-insavp(1,end)];
fprintf('\n       ��������̣�%.2fm\n\n',dr.distance);  % DR������� 

insdrplot(insavp,dravp,trjod.avp,avperr,xkpk);                        % ������ֵ����
