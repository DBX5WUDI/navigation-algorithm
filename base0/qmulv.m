%% 矢量通过四元数转换
%
% $${{\bf{r}}^n} = {\bf{Q}}_b^n \circ {{\bf{r}}^b} \circ {\bf{Q}}_n^b$$
%
function vo = qmulv(q, vi)
% 功能：矢量通过四元数转换
% 输入：q -  姿态四元数
%       vi - 输入姿态矢量
% 输出：vo - 输出姿态矢量
    qi = [0;vi];
    qo1 = qmul(q,qi); 
    q(2) = -q(2);  q(3) = -q(3);  q(4) = -q(4);
    qo = qmul(qo1,q);
    vo = qo(2:4,1);