function trj = odsimu(trj, inst, kod, qe, dt, ifplot)
% ���ܣ�����Ǿ�������ģ������û�п���SIMU��OD֮��ĸ˱�
% ���룺trj - ԭʼ�켣
%       inst - Ϊ����������֮���ƫ���
%       kod - �̶�ϵ�����
%       qe - default 0 meter/pulse, for no quantization
%       dt - ����������������������֮����ʱ
%       ifplot - �Ƿ�ͼ
% �����trj - ����ǹ켣�ṹ��

    if length(inst)==1,  inst=[1;1;1]*inst;  end    % ��װƫ�����ֻ��һ�����OD��װƫ������
    Cb1b0 = a2mat(-d2r(inst/60));                   % inst�ĵ�λΪ�Ƿ֣�OD����ϵ��SIMU֮�����̬��OD����ϵ������ϵ�غ�
    Cb0b1 = Cb1b0';                                 % OD����ϵ��SIMU����ϵ֮�����̬��
    trj.imu(:,1:6) = [trj.imu(:,1:3)*Cb0b1, trj.imu(:,4:6)*Cb0b1];    %��װ���ǵ���ԭʼIMU���ݣ���������������
    
    % attitude rotation
    trj.avp0(1:3) = m2att(a2mat(trj.avp0(1:3))*Cb0b1);          %��װ���ǵ���ԭʼ������̬�ǳ�ֵ
    for k=1:length(trj.avp)                                     %b1����������ϵ��b0��IMU����ϵ
        trj.avp(k,1:3) = m2att(a2mat(trj.avp(k,1:3)')*Cb0b1)';  %��װ���ǵ���ԭʼ������̬��
    end
    
    % distance increments
    pos = [trj.avp0(7:9)'; trj.avp(:,7:9)];                             % ����λ�þ���
    [RMh, clRNh] = RMRN(pos);                                           % ��������ʵʱ�ľ�γ�����ʰ뾶
    dpos = diff(pos);                                                   % λ���������㣬�Ƕ�ֵ
    dxyz = [[RMh(1:end-1), clRNh(1:end-1)].*dpos(:,1:2), dpos(:,3)];    % x,y,z������
    dS = sqrt(sum(dxyz.^2,2));                                          % �����������
    t = trj.avp(:,10);                                                  % ʱ������
    dS = interp1([t(1)-1;t;t(end)+1],[dS(1);dS;dS(end)], t+dt);         % time delay
    dS = cumsum([0;dS]);                                                % ��̵��ۼƺ�
    
    if qe==0
        dS = diff(dS*kod);
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / m');  end
    else
        dS = fix(diff(dS*kod/qe));
        if ifplot==1,  myfigure; plot(t,dS); xygo('Odometer / pulse');  end
    end
    trj.od = [dS,t];
