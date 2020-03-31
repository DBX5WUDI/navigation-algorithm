%% 绘制卡尔曼滤波结果，包含状态和方差
function kfplot(varargin)
% 功能：绘制卡尔曼滤波结果，包含状态和方差
% 输入：xkpk - 卡尔曼滤波状态估计和方差
% 输出：图形
global glv
        [xkpk, avp, insavp, dravp, imuerr, dinst, dkod, dT] = setvals(varargin);
        
        insavperr = avpcmp(insavp, avp);
        dravperr = avpcmp(dravp, avp);
        tt = xkpk(:,end); len = length(tt);
        
        inserrplot([xkpk(:,1:15),tt]);      %第二个图 误差估计值和误差实际值
        subplot(321), hold on, plot(tt, insavperr(:,1:2)/glv.sec, 'm--');
        subplot(322), hold on, plot(tt, insavperr(:,3)/glv.min, 'm--');
        subplot(323), hold on, plot(tt, insavperr(:,4:6), 'm--');
        subplot(324), hold on, plot(tt, [insavperr(:,7:8)*glv.Re,insavperr(:,9)], 'm--');
        subplot(325), hold on, plot(tt, repmat(imuerr.eb'/glv.dph,len,1), 'm--');
        subplot(326), hold on, plot(tt, repmat(imuerr.db'/glv.ug,len,1), 'm--');
        myfigure,                           %第三个图
        subplot(221), plot(tt, [xkpk(:,16:17)*glv.Re,xkpk(:,18)]), xygo('dP')
            hold on,  plot(tt, [dravperr(:,7:8)*glv.Re,dravperr(:,9)], 'm--');
        subplot(222), plot(tt, xkpk(:,19:20)/glv.min), xygo('dinst')
            hold on,  plot(tt, repmat(dinst([1,3])',len,1), 'm--');
        subplot(223), plot(tt, xkpk(:,21)), xygo('dkod');
            hold on,  plot(tt, repmat(dkod,len,1), 'm--');
        subplot(224), plot(tt, xkpk(:,22)), xygo('dT');
            hold on,  plot(tt, repmat(dT,len,1), 'm--');
            
        xkpk = [sqrt(xkpk(:,23:end-1)),xkpk(:,end)];    %取估计均方误差随时间 作图，可以看出Pk都是减小的
        inserrplot([xkpk(:,1:15),tt]);      %第四个图 
        myfigure,                           %第五个图 
        subplot(221), plot(tt, [xkpk(:,16:17)*glv.Re,xkpk(:,18)]), xygo('dP')
        subplot(222), plot(tt, xkpk(:,19:20)/glv.min), xygo('dinst')
        subplot(223), plot(tt, xkpk(:,21)), xygo('dkod');
        subplot(224), plot(tt, xkpk(:,22)), xygo('dT');