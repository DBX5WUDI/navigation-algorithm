function trj = odsimu(trj, inst, kod, qe, dt, ifplot)
% 功能：里程仪距离增量模拟器，没有考虑SIMU与OD之间的杆臂
% 输入：trj - 原始轨迹
%       inst - 为里程仪与惯组之间的偏差角
%       kod - 刻度系数误差
%       qe - default 0 meter/pulse, for no quantization
%       dt - 里程仪数据与捷联惯组数据之间延时
%       ifplot - 是否画图
% 输出：trj - 里程仪轨迹结构体

    if length(inst)==1,  inst=[1;1;1]*inst;  end    % 安装偏差参数只有一项，三项OD安装偏差角相等
    Cb1b0 = a2mat(-d2r(inst/60));                   % inst的单位为角分，OD坐标系与SIMU之间的姿态阵，OD坐标系与载体系重合
    Cb0b1 = Cb1b0';                                 % OD坐标系和SIMU坐标系之间的姿态阵
    trj.imu(:,1:6) = [trj.imu(:,1:3)*Cb0b1, trj.imu(:,4:6)*Cb0b1];    %安装误差角导入原始IMU数据，更新陀螺仪数据
    
    % attitude rotation
    trj.avp0(1:3) = m2att(a2mat(trj.avp0(1:3))*Cb0b1);          %安装误差角导入原始导航姿态角初值
    for k=1:length(trj.avp)                                     %b1是载体坐标系，b0是IMU坐标系
        trj.avp(k,1:3) = m2att(a2mat(trj.avp(k,1:3)')*Cb0b1)';  %安装误差角导入原始导航姿态角
    end
    
    % distance increments
    pos = [trj.avp0(7:9)'; trj.avp(:,7:9)];                             % 载体位置矩阵
    [RMh, clRNh] = RMRN(pos);                                           % 计算载体实时的经纬主曲率半径
    dpos = diff(pos);                                                   % 位置增量计算，角度值
    dxyz = [[RMh(1:end-1), clRNh(1:end-1)].*dpos(:,1:2), dpos(:,3)];    % x,y,z的增量
    dS = sqrt(sum(dxyz.^2,2));                                          % 里程增量计算
    t = trj.avp(:,10);                                                  % 时间向量
    dS = interp1([t(1)-1;t;t(end)+1],[dS(1);dS;dS(end)], t+dt);         % time delay
    dS = cumsum([0;dS]);                                                % 里程的累计和
    
    if qe==0
        dS = diff(dS*kod);
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / m');  end
    else
        dS = fix(diff(dS*kod/qe));
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / pulse');  end
    end
    trj.od = [dS,t];
