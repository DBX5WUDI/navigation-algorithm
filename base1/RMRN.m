function [RMh, clRNh, RNh] = RMRN(pos)
% ���ܣ����㵱�ص������
% ���룺����λ��ʸ��
% �������������Ȧ����Ȧ�������ʰ뾶������î��Ȧ�����ʰ뾶��γȦ�����ʰ뾶
global glv
	sl=sin(pos(:,1)); cl=cos(pos(:,1)); sl2=sl.*sl;
	sq = 1-glv.e2*sl2; sq2 = sqrt(sq);
	RMh = glv.Re*(1-glv.e2)./sq./sq2+pos(:,3);
	RNh = glv.Re./sq2+pos(:,3);    
    clRNh = cl.*RNh;
