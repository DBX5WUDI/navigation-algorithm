function attsb = alignmagsb(imu, mag, pos, ts)
%功  能：SINS粗对准
%输  入: imu - IMU数据
%输  出: att - 粗对准结果
global glv;
    wbib = mean(imu(:,1:3),1)'; 
    fbsf = mean(imu(:,4:6),1)';                         % 求粗对准时间范围内的wbib、fbsf平均值
    Bb = mean(mag(:,1:3),1)';
    if nargin<2                                         % 初始位置未知时，使用计算纬度进行粗对准
        lat = asin(wbib'*fbsf/norm(wbib)/norm(fbsf));   % 通过陀螺和加速度计输出，计算纬度
        pos = [lat;0;0];
    end 
    eth = earth(pos);                                   % 计算当地水平坐标系内重力加速度、地球自转角速度
    Bn = zeros(3,1);
    [Bn(2),Bn(1),Bn(3)] = igrf('31-Dec-2019 12:00:00',pos(1)/glv.deg, pos(2)/glv.deg, pos(3)/glv.km);   % 磁感应强度计算[BN, BE, BU]
    attsb = dv2atti(eth.gn, Bn, -fbsf/ts, Bb);             % 通过n系、b系内两向量对比确定载体姿态角
    fprintf('\n************粗对准结果************\n');
    fprintf('        双矢量方法俯仰角  %f °\n',attsb(1)/glv.deg );
    fprintf('        双矢量方法横滚角  %f °\n',attsb(2)/glv.deg );
    fprintf('        双矢量方法偏航角  %f °\n',attsb(3)/glv.deg );
    attsb1 = euleralign(fbsf/ts, Bb, eth.g);
end

    
function att = dv2atti(vn1, vn2, vb1, vb2)
    vb1 = norm(vn1)/norm(vb1)*vb1;  %对b系内投影向量进行预处理
    vb2 = norm(vn2)/norm(vb2)*vb2;
    vntmp = cross(vn1,vn2);  %构造n系内第三向量vn1×vn2
    vbtmp = cross(vb1,vb2);  %构造b系内第三向量vn1×vn2
    Cnb = [vn1'; vntmp'; cross(vntmp,vn1)']^-1 * [vb1'; vbtmp'; cross(vbtmp,vb1)'];  %求取姿态矩阵
    for k=1:5  %姿态矩阵单位正交化
        Cnb = 0.5 * (Cnb + (Cnb')^-1);
    end
    att = m2att(Cnb);
end

function att = euleralign(fbsf, Bb, g)
global glv;
    att(1) = asin(fbsf(2)/g);
    att(2) = asin(-fbsf(1)/cos(att(1))/g);
    B(1) = Bb(1)*cos(att(2))+Bb(3)*sin(att(2));
    B(2) = Bb(1)*sin(att(1))*sin(att(2))+Bb(2)*cos(att(1))-Bb(3)*sin(att(1))*cos(att(2));
    att(3) = atan(B(1)/B(2))+3.1*glv.deg;
    fprintf('      普通方法对准俯仰角  %f °\n',att(1)/glv.deg );
    fprintf('      普通方法对准横滚角  %f °\n',att(2)/glv.deg ); 
    fprintf('      普通方法对准航向角  %f °\n',att(3)/glv.deg ); 
end