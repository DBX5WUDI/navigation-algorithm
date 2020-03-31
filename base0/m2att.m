%% ��̬��ת��Ϊ��̬�� m2att
%
% $$\left\{ \begin{array}{l}
% \theta  = \arcsin ({C_{32}})\\
% \gamma  =  - {\rm{atan}}2({C_{31}},{C_{33}})\\
% \psi  =  - {\rm{atan}}2({C_{12}},{C_{22}})
% \end{array} \right.$$
%
function att = m2att(Cnb)
% ���ܣ���̬��ת��Ϊ��̬��
% ���룺Cnb - ��̬��
% �����att - ��̬��
    att = [ asin(Cnb(3,2)); 
            atan2(-Cnb(3,1),Cnb(3,3));  % �����޷����к���
            atan2(-Cnb(1,2),Cnb(2,2)) ];% atan2(x,y);x,yΪ����ֵ