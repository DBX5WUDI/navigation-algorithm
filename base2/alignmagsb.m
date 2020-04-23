function attsb = alignmagsb(imu, mag, pos, ts)
%��  �ܣ�SINS�ֶ�׼
%��  ��: imu - IMU����
%��  ��: att - �ֶ�׼���
global glv;
    wbib = mean(imu(:,1:3),1)'; 
    fbsf = mean(imu(:,4:6),1)';                         % ��ֶ�׼ʱ�䷶Χ�ڵ�wbib��fbsfƽ��ֵ
    Bb = mean(mag(:,1:3),1)';
    if nargin<2                                         % ��ʼλ��δ֪ʱ��ʹ�ü���γ�Ƚ��дֶ�׼
        lat = asin(wbib'*fbsf/norm(wbib)/norm(fbsf));   % ͨ�����ݺͼ��ٶȼ����������γ��
        pos = [lat;0;0];
    end 
    eth = earth(pos);                                   % ���㵱��ˮƽ����ϵ���������ٶȡ�������ת���ٶ�
    Bn = zeros(3,1);
    [Bn(2),Bn(1),Bn(3)] = igrf('31-Dec-2019 12:00:00',pos(1)/glv.deg, pos(2)/glv.deg, pos(3)/glv.km);   % �Ÿ�Ӧǿ�ȼ���[BN, BE, BU]
    attsb = dv2atti(eth.gn, Bn, -fbsf/ts, Bb);             % ͨ��nϵ��bϵ���������Ա�ȷ��������̬��
    fprintf('\n************�ֶ�׼���************\n');
    fprintf('        ˫ʸ������������  %f ��\n',attsb(1)/glv.deg );
    fprintf('        ˫ʸ�����������  %f ��\n',attsb(2)/glv.deg );
    fprintf('        ˫ʸ������ƫ����  %f ��\n',attsb(3)/glv.deg );
    attsb1 = euleralign(fbsf/ts, Bb, eth.g);
end

    
function att = dv2atti(vn1, vn2, vb1, vb2)
    vb1 = norm(vn1)/norm(vb1)*vb1;  %��bϵ��ͶӰ��������Ԥ����
    vb2 = norm(vn2)/norm(vb2)*vb2;
    vntmp = cross(vn1,vn2);  %����nϵ�ڵ�������vn1��vn2
    vbtmp = cross(vb1,vb2);  %����bϵ�ڵ�������vn1��vn2
    Cnb = [vn1'; vntmp'; cross(vntmp,vn1)']^-1 * [vb1'; vbtmp'; cross(vbtmp,vb1)'];  %��ȡ��̬����
    for k=1:5  %��̬����λ������
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
    fprintf('      ��ͨ������׼������  %f ��\n',att(1)/glv.deg );
    fprintf('      ��ͨ������׼�����  %f ��\n',att(2)/glv.deg ); 
    fprintf('      ��ͨ������׼�����  %f ��\n',att(3)/glv.deg ); 
end