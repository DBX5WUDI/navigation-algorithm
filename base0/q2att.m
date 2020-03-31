%% 四元数转换为姿态角 q2att
% 
% $${\bf{C}}_b^n = \left[ {\begin{array}{*{20}{c}}
% {q_0^2 + q_1^2 - q_2^2 - q_3^2}&{2({q_1}{q_2} - {q_0}{q_3})}&{2({q_1}{q_3} + {q_0}{q_2})}\\
% {2({q_1}{q_2} + {q_0}{q_3})}&{q_0^2 - q_1^2 + q_2^2 - q_3^2}&{2({q_2}{q_3} - {q_0}{q_1})}\\
% {2({q_1}{q_3} - {q_0}{q_2})}&{2({q_2}{q_3} + {q_0}{q_1})}&{q_0^2 - q_1^2 - q_2^2 + q_3^2}
% \end{array}} \right]$$
% $$\left\{ \begin{array}{l}
% \theta  = \arcsin ({C_{32}})\\
% \gamma  =  - {\rm{atan}}2({C_{31}},{C_{33}})\\
% \psi  =  - {\rm{atan}}2({C_{12}},{C_{22}})
% \end{array} \right.$$
%    
 function att = q2att(qnb)
% 功能：四元数转化为姿态角
% 输入：anb - 四元数
% 输出：att - 姿态角
    q11 = qnb(1)*qnb(1); q12 = qnb(1)*qnb(2); q13 = qnb(1)*qnb(3); q14 = qnb(1)*qnb(4); 
    q22 = qnb(2)*qnb(2); q23 = qnb(2)*qnb(3); q24 = qnb(2)*qnb(4);     
    q33 = qnb(3)*qnb(3); q34 = qnb(3)*qnb(4);  
    q44 = qnb(4)*qnb(4);
    C12=2*(q23-q14);
    C22=q11-q22+q33-q44;
    C31=2*(q24-q13); C32=2*(q34+q12); C33=q11-q22-q33+q44;
    att = [ asin(C32); 
            atan2(-C31,C33); 
            atan2(-C12,C22) ];