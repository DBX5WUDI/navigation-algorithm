function insdrplot(insavp, dravp, avptrue, imuerr, xk)
% 功能：导航数值绘图
% 输入：dravp - 导航数值（姿态、速度、位置），ptype：导航类型定义
% 输出：图
global glv;
    i_ref1 = find(avptrue(:,end)==insavp(   1,end));
    i_ref2 = find(avptrue(:,end)==insavp( end,end));
    avperr = [aa2phi(insavp(:,1:3),avptrue(i_ref1:i_ref2,1:3)),insavp(:,4:9)-avptrue(i_ref1:i_ref2,4:9),insavp(:,end)-insavp(1,end)];    
    t = insavp(:,end);t1 = dravp(:,end); t2 = avptrue(:,end); 
    linewidth = 1.5;  % 绘制线条粗细
%{
    % 速度
    figure('name','Velocity');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);% 窗口大小设定
    subplot(411);plot(t,insavp(:,4),'k-',t1,dravp(:,4),'b-',t2,avptrue(:,4),'-r','LineWidth',linewidth);xygo('VE');legend('SINS/DR','DR','TRUE');
    subplot(412);plot(t,insavp(:,5),'k-',t1,dravp(:,5),'b-',t2,avptrue(:,5),'-r','LineWidth',linewidth);xygo('VN');
    subplot(413);plot(t,insavp(:,6),'k-',t1,dravp(:,6),'b-',t2,avptrue(:,6),'-r','LineWidth',linewidth);xygo('VU');
    subplot(414);plot(t,normv(avp(:,4:6)),'k-',t1, normv(dravp(:,4:6)),'-b', t2, normv(avptrue(:,4:6)),'-r'); xygo('V'); % 合成速度

    % 位置
    figure('name','Position');
    set(gcf,'unit','centimeters','position',[1,2,48,24]);
    subplot(311);plot(t, insavp(:,7), 'k-',t1, dravp(:,7), 'b-', t2, avptrue(:,7), '-r','LineWidth',linewidth);xygo('lat');legend('SINS/DR','DR','TRUE');
    subplot(312);plot(t, insavp(:,8), 'k-',t1, dravp(:,8), 'b-', t2, avptrue(:,8), '-r','LineWidth',linewidth);xygo('lon');
    subplot(313);plot(t, insavp(:,9), 'k-',t1, dravp(:,9), 'b-', t2, avptrue(:,9), '-r','LineWidth',linewidth);xygo('H');
%}    
    % 轨迹    
    figure('name','SINS/DR Trajectory');
    plot(r2d(insavp(:,8)), r2d(insavp(:,7)),'k-',...
        r2d(avptrue(:,8)), r2d(avptrue(:,7)),'r-','LineWidth',linewidth); xygo('lon', 'lat');setplt;
    plot(r2d(avptrue(1,8)), r2d(avptrue(1,7)), 'rp','LineWidth',linewidth);setplt;axis equal;
    l = legend('SINS/DR','TRUE', 'Location','Best');   set(l,'FontName','Times New Roman','FontSize',10.5);
    
    figure('name','SINS Trajectory');
    plot(r2d(insavp(:,8)), r2d(insavp(:,7)),'k-',...
        r2d(avptrue(:,8)), r2d(avptrue(:,7)),'r-','LineWidth',linewidth); xygo('lon', 'lat');setplt;
    plot(r2d(avptrue(1,8)), r2d(avptrue(1,7)), 'rp','LineWidth',linewidth);setplt;axis equal;
    l = legend('SINS','TRUE', 'Location','Best');   set(l,'FontName','Times New Roman','FontSize',10.5);
    
    figure('name','DR Trajectory');
    plot(r2d(dravp(:,8)), r2d(dravp(:,7)),'color',[0 0 0.5451],'LineWidth',linewidth);hold on;
    plot(r2d(avptrue(:,8)), r2d(avptrue(:,7)),'r-','LineWidth',linewidth); 
    plot(r2d(avptrue(1,8)), r2d(avptrue(1,7)), 'rp','LineWidth',linewidth);xygo('lon', 'lat');setplt;axis equal;
    l = legend('DR','TRUE', 'Location','Best');   set(l,'FontName','Times New Roman','FontSize',10.5);   
    
    
    figure('name','Misalignment angle of SINS');%姿态失准角      
    subplot(311), plot(avperr(:,end),avperr(:,1)/glv.sec,'b',t, xk(:,1)/glv.sec,'k--','LineWidth',linewidth), xygo('phiE'); setplt;
    l = legend('\phi_{TRUE}','\phi'); set(l,'FontName','Times New Roman','FontSize',10.5);
    subplot(312), plot(avperr(:,end),avperr(:,2)/glv.sec,'b',t, xk(:,2)/glv.sec,'k--','LineWidth',linewidth), xygo('phiN'); setplt;
    subplot(313), plot(avperr(:,end),avperr(:,3)/glv.min,'b',t, xk(:,1)/glv.min,'k--','LineWidth',linewidth), xygo('phiU'); setplt;    
    figure('name','Velocity error of SINS');%姿态失准角  
    subplot(311);plot(avperr(:,end),avperr(:,4),'b',t,xk(:,4), 'k--','LineWidth',linewidth); xygo('dVE');setplt;
    l = legend('\DeltaV','\deltaV'); set(l,'FontName','Times New Roman','FontSize',10.5);
    subplot(312);plot(avperr(:,end),avperr(:,5),'b',t,xk(:,5), 'k--','LineWidth',linewidth); xygo('dVN');setplt;
    subplot(313);plot(avperr(:,end),avperr(:,6),'b',t,xk(:,6), 'k--','LineWidth',linewidth); xygo('dVU');setplt;

    figure('name','Position Error of SINS');    %SINS导航东、北、天位置误差
    subplot(311);plot(avperr(:,end),avperr(:,7)*glv.Re,'b',t,xk(:,7)*glv.Re,'k--','LineWidth',linewidth); xygo('dlat');legend('\DeltaP','\deltaP');setplt;
    subplot(312);plot(avperr(:,end),avperr(:,8)*glv.Re,'b',t,xk(:,8)*glv.Re,'k--','LineWidth',linewidth); xygo('dlon');	setplt;
    subplot(313);plot(avperr(:,end),avperr(:,9),'b',t,xk(:,9),'k--','LineWidth',linewidth); xygo('dH');setplt;
    pn = max(abs(avperr(:,7)*glv.Re)); pe = max(abs(avperr(:,8)*glv.Re));
    dperr = max(sqrt((avperr(:,7)*glv.Re).^2+(avperr(:,8)*glv.Re).^2)); 
    fprintf('北向最大位置误差 : %d m，东向最大位置误差 : %d m，最大位置误差 : %d m\n',pn,pe,dperr);

    drperr = dravp(:,7:9)-avptrue(i_ref1:i_ref2,7:9); 
    figure('name','Position Error of DR');    %SINS导航东、北、天位置误差
    subplot(311);plot(t1,drperr(:,1)*glv.Re,'b',t,xk(:,16)*glv.Re,'k--','LineWidth',linewidth); xygo('dlat');legend('\DeltaP_D','\deltaP_D');setplt;
    subplot(312);plot(t1,drperr(:,2)*glv.Re,'b',t,xk(:,17)*glv.Re,'k--','LineWidth',linewidth); xygo('dlon');setplt;
    subplot(313);plot(t1,drperr(:,3),'b',t,xk(:,18),'k--','LineWidth',linewidth); xygo('dH');setplt;
    
    len = size(t,1);
    figure('name','gyroscopes Error');    %  陀螺误差  
    subplot(311);plot(t,repmat(imuerr.eb(1)/glv.dph,len,1),'b',t,xk(:,10)/glv.dph,'k--','LineWidth',linewidth); xygo('eb');setplt;
    subplot(312);plot(t,repmat(imuerr.eb(2)/glv.dph,len,1),'b',t,xk(:,11)/glv.dph,'k--','LineWidth',linewidth); xygo('eb');setplt;
    subplot(313);plot(t,repmat(imuerr.eb(3)/glv.dph,len,1),'b',t,xk(:,12)/glv.dph,'k--','LineWidth',linewidth); xygo('eb');setplt;
   
    figure('name','accelerations Error');    %  陀螺误差 
    subplot(311);plot(t,repmat(imuerr.db(1)/glv.ug,len,1),'b',t,xk(:,13)/glv.ug,'k--','LineWidth',linewidth); xygo('db');setplt;
    subplot(312);plot(t,repmat(imuerr.db(2)/glv.ug,len,1),'b',t,xk(:,14)/glv.ug,'k--','LineWidth',linewidth); xygo('db');setplt;
    subplot(313);plot(t,repmat(imuerr.db(3)/glv.ug,len,1),'b',t,xk(:,15)/glv.ug,'k--','LineWidth',linewidth); xygo('db');setplt;   