%% 向量叉乘 cros
% 
% $${{\bf{V}}_1} \times {{\bf{V}}_2} = \left[ {\begin{array}{*{20}{c}}
% {{V_{1y}}{V_{2z}} - {V_{1y}}{V_{2z}}}\\
% {{V_{1z}}{V_{2x}} - {V_{1x}}{V_{2z}}}\\
% {{V_{1x}}{V_{2y}} - {V_{1y}}{V_{2x}}}
% \end{array}} \right]$$
% 
function c = cros(a, b)
% 功能：向量叉乘
% 输入：向量a,b
% 输出：向量a×b
    c = a;
    c(1) = a(2)*b(3)-a(3)*b(2);
    c(2) = a(3)*b(1)-a(1)*b(3);
    c(3) = a(1)*b(2)-a(2)*b(1);