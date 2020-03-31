function dr = drinit(avp0, inst, kod, ts)
% ���ܣ���λ����ṹ���ʼ��
% ���룺avp0-��ʼ������λ�ò���
%       inst-��������������֮��İ�װ�����к��ƫ���Ϊ��(rad)
%       kod-����ǿ̶�ϵ�����  ��m/pulse��
%       ts-
	dr = [];
    avp0 = avp0(:);
	dr.qnb = a2qua(avp0(1:3)); dr.vn = zeros(3,1); dr.pos = avp0(7:9);
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
    
	dr.kod = kod;
    dr.Cbo = a2mat(-inst)*kod;      %����ǿ̶�ϵ�����
	dr.prj = dr.Cbo*[0;1;0];        % from OD to SIMU
	dr.ts = ts;
	dr.distance = 0;
	dr.eth = earth(dr.pos);
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];

