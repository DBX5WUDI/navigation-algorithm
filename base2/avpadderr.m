function avp = avpadderr(avp0, davp)
% 功能：初始导航数值误差设定
% 输入：avp0 - 初始导航数值
%       davp0 - 导航误差
% 输出：avp - 设定误差后的初始导航数值
    avp0 = avp0(:); davp = davp(:);
	[phi, dvn, dpos] = setvals(davp(1:3), davp(4:6), davp(7:9));
    avp(1:3,1) = q2att(qaddphi(a2qua(avp0(1:3)), phi));
    avp(4:9,1) = avp0(4:9)+[dvn; dpos];
