%% ���Գ���ʽ askew
% 
% $$\bf{M} = \left[ {\begin{array}{*{20}{c}}0&{ - U}&N\\U&0&{ - E}\\{ -
% N}&E&0\end{array}} \right]$$
% 
function m = askew(v)
% ���ܣ�3x1ά�����ķ��Գƾ������
   m = [ 0,     -v(3),   v(2); 
          v(3),   0,     -v(1); 
         -v(2),   v(1),   0     ];






    
