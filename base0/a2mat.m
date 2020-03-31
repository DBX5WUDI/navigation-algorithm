%% 姿态角转化为姿态阵 a2mat
%
% $${\bf{C}}_b^n{\rm{ = }}\left[ {\begin{array}{*{20}{c}}{{c_\psi
% }{c_\gamma } - {s_\psi }{s_\theta }{s_\gamma }}&{ - {s_\psi }{c_\theta
% }}&{{c_\psi }{s_\gamma } + {s_\psi }{s_\theta }{c_\gamma }}\\{{s_\psi }
% {c_\gamma } + {c_\psi }{s_\theta }{s_\gamma }}&{{c_\psi }{c_\theta }}&
% {{s_\psi }{s_\gamma } - {c_\psi }{s_\theta }{c_\gamma }}\\{ - {c_\theta }
% {s_\gamma }}&{{s_\theta }}&{{c_\theta }{c_\gamma }}\end{array}} \right]$$
%
function Cnb = a2mat(att)
% 功能：姿态角转化为姿态阵
% 输入：att - 姿态角
% 输出：Cnb - 姿态阵
    s = sin(att); c = cos(att);
    si = s(1); sj = s(2); sk = s(3); 
    ci = c(1); cj = c(2); ck = c(3);
    Cnb = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
            cj*sk+si*sj*ck,  ci*ck,  sj*sk-si*cj*ck;
           -ci*sj,           si,     ci*cj           ];