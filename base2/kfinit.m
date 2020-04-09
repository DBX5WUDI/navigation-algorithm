%% �������˲���ʼ��
function kf = kfinit(nts, davp, imuerr, dinst, dKod)
% ���ܣ��������˲���ʼ��������'kf'�ṹ�壬��δ���ͨ���������²������趨��Qk,Rk,Pxk,Hk
% ���룺SINS�ṹ��
% ������������˲��ṹ��
global glv                              
    kf = [];
    kf.nts = nts;               % ����������
    kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(15,1)])^2;                  % ϵͳ�������з�����Qt
    kf.Rk = diag(davp(7:9))^2;                                              % �����������з�����Rk
    kf.Pxk = diag([davp; imuerr.eb; imuerr.db; davp(7:9); dinst([1,3])*glv.min; dKod]*10)^2;    
    kf.Hk = zeros(3,21); kf.Hk(:,7:9) = eye(3); kf.Hk(:,16:18) = -eye(3);   %������Hk
    
    [kf.m, kf.n] = size(kf.Hk); % ������Ĵ�С
    kf.Kk = zeros(kf.n, kf.m);  % ������ת�ô�С�������
    kf.xk = zeros(kf.n, 1);     % ϵͳ״̬����
    kf.Qk = kf.Qt*kf.nts;       % ϵͳ�������з�����Qk
    kf.Gammak = 1;              %ϵͳ����������
    kf.fading = 1;