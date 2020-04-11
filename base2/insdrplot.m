function insdrplot(insavp, dravp, avptrue, imuerr, xk)
% 功能：导航数值绘图
% 输入：dravp - 导航数值（姿态、速度、位置），ptype：导航类型定义
% 输出：图
global glv;
    i_ref1 = find(avptrue(:,end)==insavp(   1,end));
    i_ref2 = find(avptrue(:,end)==insavp( end,end));
    avperr = [aa2phi(insavp(:,1:3),avptrue(i_ref1:i_ref2,1:3)),insavp(:,4:9)-avptrue(i_ref1:i_ref2,4:9),insavp(:,end)-insavp(1,end)];    
    t = insavp(:,end);t1 = dravp(:,end); t2 = avptrue(:,end); 

%{
    % 速度
    figure('name','Velocity');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);% 窗口大小设定
    subplot(411);plot(t,insavp(:,4),'k-',t1,dravp(:,4),'b-',t2,avptrue(:,4),'-r');xygo('VE');legend('SINS/DR','DR','TRUE');
    subplot(412);plot(t,insavp(:,5),'k-',t1,dravp(:,5),'b-',t2,avptrue(:,5),'-r');xygo('VN');
    subplot(413);plot(t,insavp(:,6),'k-',t1,dravp(:,6),'b-',t2,avptrue(:,6),'-r');xygo('VU');
    subplot(414);plot(t,normv(avp(:,4:6)),'k-',t1, normv(dravp(:,4:6)),'-b', t2, normv(avptrue(:,4:6)),'-r'); xygo('V'); % 合成速度

    % 位置
    figure('name','Position');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    subplot(311);plot(t, insavp(:,7), 'k-',t1, dravp(:,7), 'b-', t2, avptrue(:,7), '-r');xygo('lat');legend('SINS/DR','DR','TRUE');
    subplot(312);plot(t, insavp(:,8), 'k-',t1, dravp(:,8), 'b-', t2, avptrue(:,8), '-r');xygo('lon');
    subplot(313);plot(t, insavp(:,9), 'k-',t1, dravp(:,9), 'b-', t2, avptrue(:,9), '-r');xygo('H');
%}    
    % 轨迹    
    figure('name','trajectory');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    plot(r2d(insavp(:,8)), r2d(insavp(:,7)),'k-',r2d(dravp(:,8)), r2d(dravp(:,7)),'b-',...
        r2d(avptrue(:,8)), r2d(avptrue(:,7)),'r-'); xygo('lon', 'lat'); 
    plot(r2d(avptrue(1,8)), r2d(avptrue(1,7)), 'rp');  
    legend('SINS/DR', 'DR','TRUE', 'Location','Best');   

    figure('name','Misalignment Angle');%姿态失准角  
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    subplot(311), plot(avperr(:,end),avperr(:,1)/glv.sec,'b',t, xk(:,1)/glv.sec,'k--'), xygo('phiE'); legend('\phi','\phi1'); % 
    subplot(312), plot(avperr(:,end),avperr(:,2)/glv.sec,'b',t, xk(:,2)/glv.sec,'k--'), xygo('phiN'); 
    subplot(313), plot(avperr(:,end),avperr(:,3)/glv.min,'b',t, xk(:,1)/glv.min,'k--'), xygo('phiU');   
    figure('name','Velocity Error');    %SINS导航东、北、天速度误差   
    set(gcf,'unit','centimeters','position',[1,2,48,24]);    
    subplot(311);plot(avperr(:,end),avperr(:,4),'b',t,xk(:,4), 'k--'); xygo('dVE');grid on;legend('\DeltaV','\deltaV');
    subplot(312);plot(avperr(:,end),avperr(:,5),'b',t,xk(:,5), 'k--'); xygo('dVN');grid on;
    subplot(313);plot(avperr(:,end),avperr(:,6),'b',t,xk(:,6), 'k--'); xygo('dVU');grid on;
    figure('name','Position Error');    %SINS导航东、北、天位置误差
    set(gcf,'unit','centimeters','position',[1,2,48,24]);    
    subplot(311);plot(avperr(:,end),avperr(:,7)*glv.Re,'b',t,xk(:,7)*glv.Re,'k--'); xygo('dlat');grid on;legend('\DeltaP','\deltaP');
    subplot(312);plot(avperr(:,end),avperr(:,8)*glv.Re,'b',t,xk(:,8)*glv.Re,'k--'); xygo('dlon');grid on;	
    subplot(313);plot(avperr(:,end),avperr(:,9),'b',t,xk(:,9),'k--'); xygo('dH');grid on;
    len = size(t,1);
    figure('name','MIMU Error');    %  陀螺误差  
    set(gcf,'unit','centimeters','position',[1,2,48,24]); 
    subplot(321);plot(t,repmat(imuerr.eb(1)/glv.dph,len,1),'b',t,xk(:,10)/glv.dph,'k--'); grid on;xygo('eb');
    subplot(323);plot(t,repmat(imuerr.eb(2)/glv.dph,len,1),'b',t,xk(:,11)/glv.dph,'k--'); grid on;xygo('eb');	
    subplot(325);plot(t,repmat(imuerr.eb(3)/glv.dph,len,1),'b',t,xk(:,12)/glv.dph,'k--'); grid on;xygo('eb');    
    subplot(322);plot(t,repmat(imuerr.db(1)/glv.ug,len,1),'b',t,xk(:,13)/glv.dph,'k--'); grid on;xygo('db');
    subplot(324);plot(t,repmat(imuerr.db(2)/glv.ug,len,1),'b',t,xk(:,14)/glv.dph,'k--'); grid on;xygo('db');	
    subplot(326);plot(t,repmat(imuerr.db(3)/glv.ug,len,1),'b',t,xk(:,15)/glv.dph,'k--'); grid on;xygo('db');   
    
    drperr = dravp(:,7:9)-avptrue(i_ref1:i_ref2,7:9);
    figure('name','DR Position Error');    %SINS导航东、北、天位置误差
    set(gcf,'unit','centimeters','position',[1,2,48,24]);    
    subplot(311);plot(t1,drperr(:,1)*glv.Re,'b',t,xk(:,16)*glv.Re,'k--'); xygo('dlat');grid on;
    subplot(312);plot(t1,drperr(:,2)*glv.Re,'b',t,xk(:,17)*glv.Re,'k--'); xygo('dlon');grid on;	
    subplot(313);plot(t1,drperr(:,3),'b',t,xk(:,18),'k--'); xygo('dH');grid on;
    