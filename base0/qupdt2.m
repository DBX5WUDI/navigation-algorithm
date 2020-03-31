%% ʹ�õ�Ч��תʸ������̬��Ԫ������
% 
% $$\begin{array}{l}
% {\bf{C}}_{b(m)}^{b(m - 1)} = {{\bf{M}}_{RV}}(\phi _{ib(m)}^b)\\\\
% {\bf{C}}_{n(m - 1)}^{n(m)} = {\bf{M}}_{RV}^T(T{\bf{\omega
% }}_{in(m)}^n)\\\\
% {\bf{C}}_{b(m)}^{n(m)} = {\bf{C}}_{n(m - 1)}^{n(m)}{\bf{C}}_{b(m - 1)}^{n(m - 1)}{\bf{C}}_{b(m)}^{b(m - 1)}
% \end{array}$$
% 
function qnb1 = qupdt2(qnb0, rv_ib, rv_in)

% ���ܣ�ʹ�õ�Ч��תʸ������̬��Ԫ������
% ���룺qnb0 - ����ǰ����̬��Ԫ��
%       rv_ib - ����ϵ������ϵ�ĵ�Ч��תʸ��
%       rv_in - ����ϵ������ϵ�ĵ�Ч��תʸ��
% �����qnb1 - ���º����̬��Ԫ��

	% rv2q(rv_ib)��Ч��תʸ��ת��Ϊ��Ԫ��
    n2 = rv_ib(1)*rv_ib(1)+rv_ib(2)*rv_ib(2)+rv_ib(3)*rv_ib(3);
    if n2<1.0e-8
        rv_ib0 = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        rv_ib0 = cos(n_2); s = sin(n_2)/n; % nΪfai���ǵ�Ч��תʸ���Ĵ�С��rv_ib/nʸ���ǵ�Ч��תʸ���ķ���
    end % �õ�����Ԫ���ǵ�λ��Ԫ��
    rv_ib(1) = s*rv_ib(1); rv_ib(2) = s*rv_ib(2); rv_ib(3) = s*rv_ib(3);
    
    % qb = qmul(qnb0, qib);��Ԫ�����
    qb1 = qnb0(1) * rv_ib0   - qnb0(2) * rv_ib(1) - qnb0(3) * rv_ib(2) - qnb0(4) * rv_ib(3);
    qb2 = qnb0(1) * rv_ib(1) + qnb0(2) * rv_ib0   + qnb0(3) * rv_ib(3) - qnb0(4) * rv_ib(2);
    qb3 = qnb0(1) * rv_ib(2) + qnb0(3) * rv_ib0   + qnb0(4) * rv_ib(1) - qnb0(2) * rv_ib(3);
    qb4 = qnb0(1) * rv_ib(3) + qnb0(4) * rv_ib0   + qnb0(2) * rv_ib(2) - qnb0(3) * rv_ib(1);
    
    % rv2q(-rv_in) ��Ч��תʸ��ת��Ϊ��Ԫ��
    n2 = rv_in(1)*rv_in(1)+rv_in(2)*rv_in(2)+rv_in(3)*rv_in(3);
    if n2<1.0e-8
        rv_in0 = 1-n2*(1/8-n2/384); s = -1/2+n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        rv_in0 = cos(n_2); s = -sin(n_2)/n;
    end
    rv_in(1) = s*rv_in(1); rv_in(2) = s*rv_in(2); rv_in(3) = s*rv_in(3); 
    
    % qnb1 = qmul(qnb, qb);��Ԫ�����
    qnb1 = qnb0;    
    qnb1(1) = rv_in0 * qb1 - rv_in(1) * qb2 - rv_in(2) * qb3 - rv_in(3) * qb4;
    qnb1(2) = rv_in0 * qb2 + rv_in(1) * qb1 + rv_in(2) * qb4 - rv_in(3) * qb3;
    qnb1(3) = rv_in0 * qb3 + rv_in(2) * qb1 + rv_in(3) * qb2 - rv_in(1) * qb4;
    qnb1(4) = rv_in0 * qb4 + rv_in(3) * qb1 + rv_in(1) * qb3 - rv_in(2) * qb2;
    
    % normalization ��̬��Ԫ��������
    n2 = qnb1(1)*qnb1(1)+qnb1(2)*qnb1(2)+qnb1(3)*qnb1(3)+qnb1(4)*qnb1(4);
    if (n2>1.000001 || n2<0.999999)
        nq = 1/sqrt(n2); 
        qnb1(1) = qnb1(1)*nq; qnb1(2) = qnb1(2)*nq; qnb1(3) = qnb1(3)*nq; qnb1(4) = qnb1(4)*nq;
    end


