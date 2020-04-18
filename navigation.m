clear
glvf
%% 初始值导入与设定
trjod = trjfile('trjod.mat');
nn = 2; 
nts = nn*trjod.ts;
inst = [3;60;6]; 
kod = 1;
%% 误差值设定
davp = avpseterr([30;30;10], 0, 10); 
% imuerr = imuerrset(0.01, 50, 0.001, 5);
imuerr = adiserrset(); 
dinst = [15;0;300];
dkod = 0.05; 
%% SINS，DR，KF初始化
ins = insinit(avpadderr(trjod.avp0,davp), trjod.ts);                
dr  =  drinit(avpadderr(trjod.avp0,davp), d2r((inst+dinst)/60), kod*(1+dkod), trjod.ts);
kf  =  kfinit(nts, davp, imuerr, dinst, dkod);                  
%% SINS，DR，KF状态量内存分配
len = length(trjod.imu);                                
[dravp, insavp, xkpk] = prealloc(fix(len/nn), 10, 10, 2*kf.n+1);    
%% SINS，DR，KF更新
ki = 1;
for k  = 1:nn:len-nn+1
    k1 = k+nn-1;
    t  = trjod.imu(k1,end);     % 时间数据
    wvm = trjod.imu(k:k1,1:6);  % IMU数据
    dS = sum(trjod.od(k:k1,1)); % OD数据
    %% SINS、DR、KF计算
    ins = insupdate(ins, wvm);
    dr.qnb = ins.qnb;
    dr = drupdate(dr, wvm(:,1:3), dS);
    kf.Phikk_1 = kffk(ins);
    kf = kfupdate(kf,ins.pos-dr.pos);
    %% KF速度反馈
    ins.vn  = ins.vn - kf.xk(4:6);
    kf.xk(4:6) = zeros(3,1);        
    if mod(ki*nts,1) == 0  
        fprintf('Navigation time : %d s\n',ki*nts) ;
    end 
    %% 数据存储
    insavp(ki,:) = [ins.avp; t]';
    dravp(ki,:)  = [dr.avp; t]';
    xkpk(ki,:)   = [kf.xk; diag(kf.Pxk); t]';
    ki = ki+1;
end
%% 打印导航里程和图
fprintf('\n       导航总里程：%.2fm\n\n',dr.distance);
avptrue = trjod.avp(2:nn:end,:);
insdrplot(insavp,dravp,avptrue,imuerr,xkpk);