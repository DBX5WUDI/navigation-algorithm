function eth = ethinit(pos, vn)
% ���ܣ�������ز�����ʼ��
% ���룺pos-����λ�ò�����vn-�����ٶȲ���
% �����eth�ṹ��
global glv
    eth.Re = glv.Re;    % ����볤��
    eth.e2 = glv.e2;    % �������ƽ��
    eth.wie = glv.wie;  % ��ת������
    eth.g0 = glv.g0;    % ����ֵ
    eth = ethupdate(eth, pos, vn);                      % ��֪�������λ�����ٶȼ������������ز���
    % �����൱������ת�ã�������->������
    eth.wnie = eth.wnie(:);   eth.wnen = eth.wnen(:);   % ������ת���ٶȣ�������ת���ٶ�
    eth.wnin = eth.wnin(:);   eth.wnien = eth.wnien(:); % ������Թ���ϵ���ٶȣ�������Թ���ϵ���ٶ�+��������ڵ���ϵ���ٶ�
    eth.gn = eth.gn(:);       eth.gcc = eth.gcc(:);     % �������� 
