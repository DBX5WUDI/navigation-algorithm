%% �������˲���ʼ��
function kf = kfinit(varargin)
% ���ܣ��������˲���ʼ��������'kf'�ṹ�壬��δ���ͨ���������²������趨��Qk,Rk,Pxk,Hk
% ���룺SINS�ṹ��
% ������������˲��ṹ��
global glv                              
    kf = [];
    r = 2.000;
    [nts, davp, imuerr, dinst, dKod, dT] = setvals(varargin);
    kf.Qt = diag([imuerr.web; imuerr.wdb; zeros(9+3+4*1,1)])^2;             % ϵͳ�������з�����Qt
    kf.Rk = diag([r/glv.Re;r/glv.Re; r])^2;
%    kf.Rk = diag(davp(7:9))^2;                                              % �����������з�����Rk
    kf.Pxk = diag([davp; imuerr.eb; imuerr.db; davp(7:9); dinst([1,3])*glv.min; dKod; dT]*10)^2;    
    kf.Hk = zeros(3,22); kf.Hk(:,7:9) = eye(3); kf.Hk(:,16:18) = -eye(3);   %������Hk
    kf = kfinit0(kf, nts);
    