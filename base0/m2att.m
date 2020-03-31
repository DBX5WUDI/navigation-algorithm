%% 姿态阵转换为姿态角 m2att
%
% $$\left\{ \begin{array}{l}
% \theta  = \arcsin ({C_{32}})\\
% \gamma  =  - {\rm{atan}}2({C_{31}},{C_{33}})\\
% \psi  =  - {\rm{atan}}2({C_{12}},{C_{22}})
% \end{array} \right.$$
%
function att = m2att(Cnb)
% 功能：姿态阵转换为姿态角
% 输入：Cnb - 姿态阵
% 输出：att - 姿态角
    att = [ asin(Cnb(3,2)); 
            atan2(-Cnb(3,1),Cnb(3,3));  % 四象限反正切函数
            atan2(-Cnb(1,2),Cnb(2,2)) ];% atan2(x,y);x,y为坐标值