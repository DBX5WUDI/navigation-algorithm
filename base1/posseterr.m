function dpos = posseterr(dpos0)
% 功能：位置误差单位转换
% 输入：位置误差向量(m)
% 输出：位置误差向量(经纬度误差为rad，高度误差仍为m)
global glv
    dpos0 = dpos0(:);
    if length(dpos0)==1,     dpos0=[dpos0;dpos0;dpos0];
    elseif length(dpos0)==2, dpos0=[dpos0(1);dpos0(1);dpos0(2)];  end
    dpos=[dpos0(1:2)/glv.Re; dpos0(3)];
