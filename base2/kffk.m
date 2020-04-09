%% �����������˲�״̬ת����
function [Fk, Ft] = kffk(ins, varargin)
% ���ܣ������������˲�״̬ת����
% ���룺ins - SINS�ṹ��
% �����Fk - ��ɢʱ��ת�ƾ���
%       Ft - ����ʱ��ת�ƾ���
    nts = ins.nts;
    Ft = etm(ins);   Ft(21,21) = 0;             %SINS�����и�������
    Mpp = Ft(7:9,7:9);
    Mpvvn = ins.Mpv*ins.vn;
    Mpvvnx = ins.Mpv*askew(ins.vn);
    MpvvnxCnb = Mpvvnx*ins.Cnb;                                             %DR�����о������
    Ft(16:18,[1:3,16:18,19:20,21]) = [Mpvvnx,Mpp,MpvvnxCnb(:,[1,3]),Mpvvn]; %����ʱ��ת�ƾ���
	Fk = Ft*nts;                                % ��ɢʱ��ת�ƾ��� = ����ʱ��ת�ƾ��� * ������
    if nts>0.1                                  % ���ڳ�ʱ�����ڣ����¼��㷽�����ܸ���ȷ��
        Fk = expm(Fk);                          % ��Ȼָ��exp()
    else                                        % Fk = I + Ft*nts + 1/2*(Ft*nts)^2  , һ��ת����k,k-1����
        Fk = eye(size(Ft)) + Fk;                % + Fk*Fk*0.5; 
    end
    
