function davp = avpseterr(phi, dvn, dpos)
% 功能：设置导航数值误差
% 输入：失准角(Φ1,Φ2为角秒，Φ3为角分)
%       速度误差（米/秒）
%       位置误差（米）
% 输出：9维导航数值误差列向量
global glv
    phi = phi(:); dvn = dvn(:); dpos = dpos(:);
    if length(phi)==1,   phi = [phi*60; phi*60; phi];   end  % phi is scalar, then all in arcmin
    if length(dvn)==1,   dvn = [dvn; dvn; dvn];      end
    if length(dpos)==1,  dpos = [dpos; dpos; dpos];  end
    davp = [phi(1:2)*glv.sec; phi(3)*glv.min; dvn; posseterr(dpos)]; %返回误差值
