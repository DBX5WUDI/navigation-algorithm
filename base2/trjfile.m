%% ���ػ��߱���*.mat�ļ�
function trj = trjfile(fname, trj)
% ���ܣ����ػ��߱���*.mat�ļ�
% ���룺fname - ����Ĭ����չ'.mat'�������ļ�
%       trj - �������ļ������뱣��������ļ�
% �����trj - �������ļ����������������ļ�
% �÷���
%    ����: trjfile(fname, trj);
%    ����: trj = trjfile(fname);
global glv
    if isempty(strfind(fname, '.'))     % ����淶���
        fname = [fname, '.', 'mat']; 
    end
    if ~exist(['.\',fname],'file')      % ��鹤��·�������޹켣�ļ�
        fname = [glv.datapath, fname];  % ���ޣ���data·����Ѱ��
    end
    
    if nargin<2                         % ����
        trj = load(fname);
        trj = trj.trj;
    else                                % ����
        save(fname, 'trj');
    end

