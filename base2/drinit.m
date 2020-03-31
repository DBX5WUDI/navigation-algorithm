function dr = drinit(avp0, inst, kod, ts)
% 功能：航位推算结构体初始化
% 输入：avp0-初始化导航位置参数
%       inst-里程仪与捷联惯组之间的安装误差，其中横滚偏差角为零(rad)
%       kod-里程仪刻度系数误差  （m/pulse）
%       ts-
	dr = [];
    avp0 = avp0(:);
	dr.qnb = a2qua(avp0(1:3)); dr.vn = zeros(3,1); dr.pos = avp0(7:9);
    [dr.qnb, dr.att, dr.Cnb] = attsyn(dr.qnb);
    dr.avp = [dr.att; dr.vn; dr.pos];
    
	dr.kod = kod;
    dr.Cbo = a2mat(-inst)*kod;      %里程仪刻度系数误差
	dr.prj = dr.Cbo*[0;1;0];        % from OD to SIMU
	dr.ts = ts;
	dr.distance = 0;
	dr.eth = earth(dr.pos);
    dr.Mpv = [0, 1/dr.eth.RMh, 0; 1/dr.eth.clRNh, 0, 0; 0, 0, 1];

