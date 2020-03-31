%% 反对称阵公式 askew
% 
% $$\bf{M} = \left[ {\begin{array}{*{20}{c}}0&{ - U}&N\\U&0&{ - E}\\{ -
% N}&E&0\end{array}} \right]$$
% 
function m = askew(v)
% 功能：3x1维向量的反对称矩阵计算
   m = [ 0,     -v(3),   v(2); 
          v(3),   0,     -v(1); 
         -v(2),   v(1),   0     ];






    
