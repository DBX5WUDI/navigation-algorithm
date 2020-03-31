function ins = inslever(ins, lever)
% ���ܣ�SINS�˱ۼ����߲���
% ���룺ins-�ߵ��ṹ�����룬lever-�˱�һ�д���һ������
% �����ins-���и˱۲����Ĺߵ��ṹ��
    if nargin<2, lever = ins.lever;  end
    ins.CW = ins.Cnb*askew(ins.web);
    ins.MpvCnb = ins.Mpv*ins.Cnb;
    ins.Mpvvn = ins.Mpv*ins.vn;
    n = size(lever,2);
    if n>1,
        ins.vnL = repmat(ins.vn,1,n) + ins.CW*lever;
        ins.posL = repmat(ins.pos,1,n) + ins.MpvCnb*lever;
    else  % else n==1, the following code is faster
        ins.vnL = ins.vn + ins.CW*lever;
        ins.posL = ins.pos + ins.MpvCnb*lever;
    end
