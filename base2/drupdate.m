function dr = drupdate(dr, wm, dS)
% ���ܣ�DR��̬��λ�ø���
% ���룺dr - ����֮ǰ��DR�ṹ��
%       wm - ���������е�����������
%       dS - ����Ǿ�������
% �����dr - ���º��DR�ṹ��
    nts = dr.ts*size(wm,1);
    dr.distance = dr.distance + dr.kod*norm(dS);
    phim = cnscl(wm);       %������\phi����Բ׶��������û�н����ٶȲ���
    if length(dS)>1,        %�������ǵı�ʸ��
        dSn = qmulv(dr.qnb, dr.Cbo*dS);
    else
        dSn = qmulv(dr.qnb, dr.prj*dS);
    end
    dr.vn = dSn/nts;                        % �ٶȼ���
    dr.eth = earth(dr.pos, dr.vn);          % dr�ṹ���е����������
    dr.web = phim/nts-dr.Cnb'*dr.eth.wnie;  
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];
    dr.pos = dr.pos + dr.Mpv*dSn;           % λ�ø���
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
