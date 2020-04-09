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
imuerr = imuerrset(0.01, 50, 0.001, 5);
dinst = [15;0;10];
dkod = 0.01; 
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
%     ins.vn  = ins.vn - kf.xk(4:6);
%     kf.xk(4:6) = zeros(3,1);     
    
    if mod(ki*nts,1) == 0  
        fprintf('Navigation time : %d s\n',ki*nts) ;
    end 
    %% 数据存储
    insavp(ki,:) = [ins.avp; t]';
    dravp(ki,:)  = [dr.avp; t]';
    xkpk(ki,:)   = [kf.xk; diag(kf.Pxk); t]';
    ki = ki+1;
end

i_ref1 = find(trjod.avp(:,end)==insavp(   1,end));
i_ref2 = find(trjod.avp(:,end)==insavp(ki-1,end));
avperr = [aa2phi(insavp(:,1:3),trjod.avp(i_ref1:nn:i_ref2,1:3)),insavp(:,4:9)-trjod.avp(i_ref1:nn:i_ref2,4:9),insavp(:,end)-insavp(1,end)];
fprintf('\n       导航总里程：%.2fm\n\n',dr.distance);

insdrplot(insavp,dravp,trjod.avp,avperr,xkpk);







