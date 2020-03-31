%% 旋转矢量转换为变换矩阵 rv2m
% 
% $${\bf{C}}_b^i = {\bf{I}} + \frac{{\sin \phi }}{\phi }(\phi  \times ) + \frac{{1 - \cos \phi }}{{{\phi ^2}}}{(\phi  \times )^2}$$
% 
function m = rv2m(rv)
% 功能：旋转矢量转换为变换矩阵
% 输入：rv - 等效旋转矢量
% 输出：m  - 姿态矩阵
% 公式：m = I + sin(|rv|)/|rv|*(rvx) + [1-cos(|rv|)]/|rv|^2*(rvx)^2
	xx = rv(1)*rv(1); yy = rv(2)*rv(2); zz = rv(3)*rv(3);
	n2 = xx+yy+zz;      % 旋转矢量的模方
    if n2<1.e-8         % 如果模方很小，则可用泰勒展开前几项求三角函数
        a = 1-n2*(1/6-n2/120); b = 0.5-n2*(1/24-n2/720);  
    else
        n = sqrt(n2);
        a = sin(n)/n;  b = (1-cos(n))/n2;
    end
	arvx = a*rv(1);  arvy = a*rv(2);  arvz = a*rv(3);
	bxx = b*xx;  bxy = b*rv(1)*rv(2);  bxz = b*rv(1)*rv(3);
	byy = b*yy;  byz = b*rv(2)*rv(3);  bzz = b*zz;
	m = zeros(3,3);
	% m = I + a*(rvx) + b*(rvx)^2;
	m(1)=1     -byy-bzz; m(4)= -arvz+bxy;     m(7)=  arvy+bxz;
	m(2)=  arvz+bxy;     m(5)=1     -bxx-bzz; m(8)= -arvx+byz;
	m(3)= -arvy+bxz;     m(6)=  arvx+byz;     m(9)=1     -bxx-byy;

