%% ʸ��ͨ����Ԫ��ת��
%
% $${{\bf{r}}^n} = {\bf{Q}}_b^n \circ {{\bf{r}}^b} \circ {\bf{Q}}_n^b$$
%
function vo = qmulv(q, vi)
% ���ܣ�ʸ��ͨ����Ԫ��ת��
% ���룺q -  ��̬��Ԫ��
%       vi - ������̬ʸ��
% �����vo - �����̬ʸ��
    qi = [0;vi];
    qo1 = qmul(q,qi); 
    q(2) = -q(2);  q(3) = -q(3);  q(4) = -q(4);
    qo = qmul(qo1,q);
    vo = qo(2:4,1);