%% SINS_DR组合导航主程序
clear
glvf
%% 组合导航初始对准（初始对准模块，可单独注释）
%{
t_align = 100;
t_coarse = 40;
imu_coarse = imu(1:t_coarse/ts,:);
attsb = alignsb(imu_coarse, trj.avp0(7:9,1)); 
imu_precise = imu(t_coarse/ts+1:t_align/ts,:); 
phi = [0.05; 0.05; 0.1]*glv.deg;
wvn = [0.001;0.001;0.001];                      % SINS速度输出噪声
trjod.avp0(1,1:3) = alignvn(imu_precise, attsb, trj.avp0(7:9,1), phi, imuerr, wvn, ts); % 对准结果导入初始姿态矩阵
%}
%% SINS_DR导航初始化和数值更新
trjod = trjfile('trjod.mat');
[nn, ts, nts] = nnts(2, trjod.ts); 
inst = [3;60;6];  kod = 1;dT = 0.01;
davp = avpseterr([30;30;10], 0, 10); 
imuerr = adiserrset(); % 导航数据误差设定
dinst = [15;0;10]; dkod = 0.01; % 里程仪安装误差定义，里程仪刻度系数误差定义

imu = trjod.imu;
ins = insinit(avpadderr(trjod.avp0,davp), ts);  % INS初始误差导入，INS结构体初始化
dr = drinit(avpadderr(trjod.avp0,davp), d2r((inst+dinst)/60), kod*(1+dkod), ts);    % DR初始误差导入，DR结构体初始化

kf = kfinit(nts, davp, imuerr, dinst, dkod, dT);                    % 卡尔曼滤波初始化
len = length(imu);                                                  % IMU数据的行数
[dravp, insavp, xkpk] = prealloc(fix(len/nn), 10, 10, 2*kf.n+1);    % DR导航数值，INS导航数值，空间预分配（fix-向零靠拢的取整）
ki = timebar(nn, len, 'SINS/DR simulation.');                       % 可视化进度条

for k=1:nn:len-nn+1                             % 开始双子样循环
    k1 = k+nn-1;                                % 最后一个子样，即为第二个子样
    wvm = imu(k:k1,1:6);  dS = sum(trjod.od(k:k1,1)); t = imu(k1,end);  % 取出IMU数据，OD数据，t-显示实时时间
    ins = insupdate(ins, wvm);                  % INS数值更新
    dr.qnb = ins.qnb;                           % DR系统姿态矩阵与INS姿态矩阵相等
    dr = drupdate(dr, wvm(:,1:3), dS);          % DR 数值更新
    kf.Phikk_1 = kffk(ins);                     % Φk，k-1值更新
    kf = kfupdate(kf);                          % 卡尔曼滤波更新，仅仅进行时间更新
    if mod(k1,10)==0                            % k1除以10等于0，即k1为10的倍数
        kf.Hk(:,22) = -ins.Mpvvn;     
        kf = kfupdate(kf, ins.pos-dr.pos);      % 卡尔曼滤波时间更新与量测更新
        [kf, ins] = kffeedback(kf, ins, 1);     % 以速度作为量测值，卡尔曼滤波反馈给INS系统
    end
    insavp(ki,:) = [ins.avp; t]';               % 真数值
    dravp(ki,:) = [dr.avp; t]';                 % 导航计算数值
    xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';     % 状态估计和一步预测均方误差值存储
    ki = timebar;                               % ki运算值
end
i_ref1 = find(trjod.avp(:,end)==insavp(1,end));
i_ref2 = find(trjod.avp(:,end)==insavp(ki-1,end));
avperr = [aa2phi(insavp(:,1:3),trjod.avp(i_ref1:nn:i_ref2,1:3)),insavp(:,4:9)-trjod.avp(i_ref1:nn:i_ref2,4:9),insavp(:,end)-insavp(1,end)];
fprintf('\n       导航总里程：%.2fm\n\n',dr.distance);  % DR距离计算 

insdrplot(insavp,dravp,trjod.avp,avperr,xkpk);                        % 导航数值绘制

