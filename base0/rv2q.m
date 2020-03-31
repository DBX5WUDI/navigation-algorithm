%% 旋转矢量转换为变换四元数
%
% $${\bf{Q}} = \cos \frac{\phi }{2} + \frac{\bf{\phi} }{\phi }\sin \frac{\phi }{2}$$
%
function q = rv2q(rv)
% 功能：旋转矢量转换为变换四元数
% 输入：rv - 等效旋转矢量
% 输出：q  - 姿态四元数
% 公式：q = [ cos(|rv|/2); sin(|rv|/2)/|rv|*rv ]
    q = zeros(4,1);
    n2 = rv(1)*rv(1) + rv(2)*rv(2) + rv(3)*rv(3);% 旋转矢量的模方
    if n2<1.0e-8    % 如果模方很小，则可用泰勒展开前几项求三角函数
        q(1) = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        q(1) = cos(n_2); s = sin(n_2)/n;
    end
    q(2) = s*rv(1); q(3) = s*rv(2); q(4) = s*rv(3);
