function ins = insinit(avp0, ts)
% ���ܣ�SINS�ṹ���ʼ��
% ���룺avp0-��ʼ��λ����Ϣ
%       ts-��������
% �����SINS�ṹ��
% See also  insupdate, avpset, kfinit.
global glv
    avp0 = avp0(:);
    [qnb0, vn0, pos0] = setvals(a2qua(avp0(1:3)), avp0(4:6), avp0(7:9));% ��ʼ��̬��Ԫ�������ٶȣ���ʼλ��
	ins = [];
	ins.ts = ts; ins.nts = [];
    [ins.qnb, ins.vn, ins.pos] = setvals(qnb0, vn0, pos0);              % ��ʼֵ������ʼֵע��
	[ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);  ins.Cnb0 = ins.Cnb; % ��̬�Ĳ�ͬ��ʾ����
    ins.avp  = [ins.att; ins.vn; ins.pos];                              % �ߵ���ֵͳһ��ͬһ��������
    
    ins.eth = ethinit(ins.pos, ins.vn);                                 % ������ز����ṹ���ʼ��
    ins.wib = ins.Cnb'*ins.eth.wnin;                                    % ����ϵ����ڹ���ϵ�Ľ��ٶ�
    ins.fn = -ins.eth.gn;  ins.fb = ins.Cnb'*ins.fn;                    % ����ϵ�еı���������ϵ�еı���
	[ins.wnb, ins.web, ins.an] = setvals(zeros(3,1));                   % ����ϵ����ڵ���ϵ�Ľ��ٶȣ�����ϵ����ڵ���ϵ�Ľ��ٶȳ�ʼ��
	ins.Mpv = [0, 1/ins.eth.RMh, 0; 1/ins.eth.clRNh, 0, 0; 0, 0, 1];    % �ߵ������е�Mpv����
    ins.MpvCnb = ins.Mpv*ins.Cnb;  ins.Mpvvn = ins.Mpv*ins.vn;          % Mpv����
	[ins.Kg, ins.Ka] = setvals(eye(3));                                 % ��Ȳ�����Ĭ�ϵ�λ����
    [ins.eb, ins.db] = setvals(zeros(3,1));                             % ��������ӱ��Ư�ƾ���Ĭ����3*1������
    [ins.tauG, ins.tauA] = setvals(inf(3,1));                           % gyro & acc correlation time ����ɷ����
    ins.lever = zeros(3,1); ins = inslever(ins);                        % lever arm
	ins.tDelay = 0;% time delay
    glv.wm_1 = zeros(3,1)';  glv.vm_1 = zeros(3,1)';  % for 'single sample+previous sample' coning algorithm
    ins.an0 = zeros(3,1);
