function dpos = posseterr(dpos0)
% ���ܣ�λ����λת��
% ���룺λ���������(m)
% �����λ���������(��γ�����Ϊrad���߶������Ϊm)
global glv
    dpos0 = dpos0(:);
    if length(dpos0)==1,     dpos0=[dpos0;dpos0;dpos0];
    elseif length(dpos0)==2, dpos0=[dpos0(1);dpos0(1);dpos0(2)];  end
    dpos=[dpos0(1:2)/glv.Re; dpos0(3)];
