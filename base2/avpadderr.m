function avp = avpadderr(avp0, davp)
% ���ܣ���ʼ������ֵ����趨
% ���룺avp0 - ��ʼ������ֵ
%       davp0 - �������
% �����avp - �趨����ĳ�ʼ������ֵ
    avp0 = avp0(:); davp = davp(:);
	[phi, dvn, dpos] = setvals(davp(1:3), davp(4:6), davp(7:9));
    avp(1:3,1) = q2att(qaddphi(a2qua(avp0(1:3)), phi));
    avp(4:9,1) = avp0(4:9)+[dvn; dpos];
