%% 姿态角转换为四元数 a2qua
% 
% $${\bf{Q}}_b^n\, = \left[ {\begin{array}{*{20}{c}}
% {{c_{\psi /2}}{c_{\theta /2}}{c_{\gamma /2}} - {s_{\psi /2}}{s_{\theta /2}}{s_{\gamma /2}}}\\
% {{c_{\psi /2}}{s_{\theta /2}}{c_{\gamma /2}} - {s_{\psi /2}}{c_{\theta /2}}{s_{\gamma /2}}}\\
% {{s_{\psi /2}}{s_{\theta /2}}{c_{\gamma /2}} + {c_{\psi /2}}{c_{\theta /2}}{s_{\gamma /2}}}\\
% {{s_{\psi /2}}{c_{\theta /2}}{c_{\gamma /2}} + {c_{\psi /2}}{s_{\theta /2}}{s_{\gamma /2}}}
% \end{array}} \right]$$
%  
function qnb = a2qua(att)
% 功能：姿态角转换为四元数
% 输入：att - 姿态角
% 输出：qnb - 四元数
    att2 = att/2;
    s = sin(att2); c = cos(att2);
    sp = s(1); sr = s(2); sy = s(3); 
    cp = c(1); cr = c(2); cy = c(3); 
    qnb = [ cp*cr*cy - sp*sr*sy;
            sp*cr*cy - cp*sr*sy;
            cp*sr*cy + sp*cr*sy;
            cp*cr*sy + sp*sr*cy ];