function davp = avpseterr(phi, dvn, dpos)
% ���ܣ����õ�����ֵ���
% ���룺ʧ׼��(��1,��2Ϊ���룬��3Ϊ�Ƿ�)
%       �ٶ�����/�룩
%       λ�����ף�
% �����9ά������ֵ���������
global glv
    phi = phi(:); dvn = dvn(:); dpos = dpos(:);
    if length(phi)==1,   phi = [phi*60; phi*60; phi];   end  % phi is scalar, then all in arcmin
    if length(dvn)==1,   dvn = [dvn; dvn; dvn];      end
    if length(dpos)==1,  dpos = [dpos; dpos; dpos];  end
    davp = [phi(1:2)*glv.sec; phi(3)*glv.min; dvn; posseterr(dpos)]; %�������ֵ
