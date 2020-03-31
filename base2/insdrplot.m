function insdrplot(avp, dravp, avptrue, avperr, xk)
% 功能：导航数值绘图
% 输入：dravp - 导航数值（姿态、速度、位置），ptype：导航类型定义
% 输出：图
global glv;
    t = avp(:,end);t1 = dravp(:,end); t2 = avptrue(:,end); 
    % 速度
    figure('name','Velocity');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);% 窗口大小设定
    subplot(411);plot(t,avp(:,4),'k-',t1,dravp(:,4),'b-',t2,avptrue(:,4),'-r');xygo('VE');legend('SINS/DR','DR','TRUE');
    subplot(412);plot(t,avp(:,5),'k-',t1,dravp(:,5),'b-',t2,avptrue(:,5),'-r');xygo('VN');
    subplot(413);plot(t,avp(:,6),'k-',t1,dravp(:,6),'b-',t2,avptrue(:,6),'-r');xygo('VU');
    subplot(414);plot(t,normv(avp(:,4:6)),'k-',t1, normv(dravp(:,4:6)),'-b', t2, normv(avptrue(:,4:6)),'-r'); xygo('V'); % 合成速度

    % 位置
    figure('name','Position');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    subplot(311);plot(t, avp(:,7), 'k-',t1, dravp(:,7), 'b-', t2, avptrue(:,7), '-r');xygo('lat');legend('SINS/DR','DR','TRUE');
    subplot(312);plot(t, avp(:,8), 'k-',t1, dravp(:,8), 'b-', t2, avptrue(:,8), '-r');xygo('lon');
    subplot(313);plot(t, avp(:,9), 'k-',t1, dravp(:,9), 'b-', t2, avptrue(:,9), '-r');xygo('H');
    % 轨迹
    
    figure('name','trajectory');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    plot(r2d(avp(:,8)), r2d(avp(:,7)),'k-',r2d(dravp(:,8)), r2d(dravp(:,7)),'b-',...
        r2d(avptrue(:,8)), r2d(avptrue(:,7)),'r-'); xygo('lon', 'lat'); 
    plot(r2d(avptrue(1,8)), r2d(avptrue(1,7)), 'rp');  
    legend('SINS/DR', 'DR','TRUE', 'Location','Best');   

    figure('name','Misalignment Angle'); %姿态失准角  
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    subplot(311), plot(avperr(:,end),avperr(:,1)/glv.sec,'b',t, xk(:,1)/glv.sec,'k--'), xygo('phiE'); legend('\phi','\phi1'); % 
    subplot(312), plot(avperr(:,end),avperr(:,2)/glv.sec,'b',t, xk(:,2)/glv.sec,'k--'), xygo('phiN'); 
    subplot(313), plot(avperr(:,end),avperr(:,3)/glv.min,'b',t, xk(:,1)/glv.min,'k--'), xygo('phiU');   
    figure('name','Velocity Error'); %SINS导航东、北、天速度误差   
    set(gcf,'unit','centimeters','position',[1,2,48,24]);    
    subplot(311);plot(avperr(:,end),avperr(:,4),'b',t,xk(:,4), 'k--'); xygo('dVE');grid on;legend('\DeltaV','\deltaV');
    subplot(312);plot(avperr(:,end),avperr(:,5),'b',t,xk(:,5), 'k--'); xygo('dVN');grid on;
    subplot(313);plot(avperr(:,end),avperr(:,6),'b',t,xk(:,6), 'k--'); xygo('dVU');grid on;
    figure('name','Position Error'); %SINS导航东、北、天位置误差
    set(gcf,'unit','centimeters','position',[1,2,48,24]);    
    subplot(311);plot(avperr(:,end),avperr(:,7)*glv.Re,'b',t,xk(:,7)*glv.Re,'k--'); xygo('dlat');grid on;legend('\DeltaP','\deltaP');
    subplot(312);plot(avperr(:,end),avperr(:,8)*glv.Re,'b',t,xk(:,8)*glv.Re,'k--'); xygo('dlon');grid on;	
    subplot(313);plot(avperr(:,end),avperr(:,9),'b',t,xk(:,9),'k--'); xygo('dH');grid on;
    
    