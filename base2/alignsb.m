function att = alignsb(imu, pos)
%��  �ܣ�SINS�ֶ�׼
%��  ��: imu - IMU����
%��  ��: att - �ֶ�׼���
global glv
    wbib = mean(imu(:,1:3),1)'; fbsf = mean(imu(:,4:6),1)';  %��ֶ�׼ʱ�䷶Χ�ڵ�wbib��fbsfƽ��ֵ
    lat = asin(wbib'*fbsf/norm(wbib)/norm(fbsf));  %ͨ�����ݺͼ��ٶȼ����������γ��
    if nargin<2  % ��ʼλ��δ֪ʱ��ʹ�ü���γ�Ƚ��дֶ�׼
        pos = [lat;0;0];
    end 
    eth = earth(pos);  %���㵱��ˮƽ����ϵ���������ٶȡ�������ת���ٶ�
    att = dv2atti(eth.gn, eth.wnie, -fbsf, wbib);  %ͨ��nϵ��bϵ���������Ա�ȷ��������̬��
        fprintf('\n************�ֶ�׼���************\n');
        fprintf('      ������  %f ��\n',att(1)/glv.deg );
        fprintf('      �����  %f ��\n',att(2)/glv.deg );
        fprintf('      ƫ����  %f ��\n',att(3)/glv.deg );
    
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