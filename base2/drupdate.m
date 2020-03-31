function dr = drupdate(dr, wm, dS)
% 功能：DR姿态和位置更新
% 输入：dr - 更新之前的DR结构体
%       wm - 捷联惯组中的陀螺仪数据
%       dS - 里程仪距离增量
% 输出：dr - 更新后的DR结构体
    nts = dr.ts*size(wm,1);
    dr.distance = dr.distance + dr.kod*norm(dS);
    phim = cnscl(wm);       %仅仅是\phi进行圆锥误差补偿；并没有进行速度补偿
    if length(dS)>1,        %检测里程仪的标矢性
        dSn = qmulv(dr.qnb, dr.Cbo*dS);
    else
        dSn = qmulv(dr.qnb, dr.prj*dS);
    end
    dr.vn = dSn/nts;                        % 速度计算
    dr.eth = earth(dr.pos, dr.vn);          % dr结构体中地球参数更新
    dr.web = phim/nts-dr.Cnb'*dr.eth.wnie;  
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];
    dr.pos = dr.pos + dr.Mpv*dSn;           % 位置更新
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
