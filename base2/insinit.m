function ins = insinit(avp0, ts)
% 功能：SINS结构体初始化
% 输入：avp0-初始化位置信息
%       ts-采样周期
% 输出：SINS结构体
% See also  insupdate, avpset, kfinit.
global glv
    avp0 = avp0(:);
    [qnb0, vn0, pos0] = setvals(a2qua(avp0(1:3)), avp0(4:6), avp0(7:9));% 初始姿态四元数，初速度，初始位置
	ins = [];
	ins.ts = ts; ins.nts = [];
    [ins.qnb, ins.vn, ins.pos] = setvals(qnb0, vn0, pos0);              % 初始值捷联初始值注入
	[ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);  ins.Cnb0 = ins.Cnb; % 姿态的不同表示方法
    ins.avp  = [ins.att; ins.vn; ins.pos];                              % 惯导数值统一在同一个向量中
    
    ins.eth = ethinit(ins.pos, ins.vn);                                 % 地球相关参数结构体初始化
    ins.wib = ins.Cnb'*ins.eth.wnin;                                    % 载体系相对于惯性系的角速度
    ins.fn = -ins.eth.gn;  ins.fb = ins.Cnb'*ins.fn;                    % 导航系中的比力，载体系中的比力
	[ins.wnb, ins.web, ins.an] = setvals(zeros(3,1));                   % 载体系相对于导航系的角速度，载体系相对于地球系的角速度初始化
	ins.Mpv = [0, 1/ins.eth.RMh, 0; 1/ins.eth.clRNh, 0, 0; 0, 0, 1];    % 惯导误差方程中的Mpv矩阵
    ins.MpvCnb = ins.Mpv*ins.Cnb;  ins.Mpvvn = ins.Mpv*ins.vn;          % Mpv矩阵
	[ins.Kg, ins.Ka] = setvals(eye(3));                                 % 标度参数，默认单位矩阵
    [ins.eb, ins.db] = setvals(zeros(3,1));                             % 陀螺与与加表的漂移矩阵，默认是3*1零向量
    [ins.tauG, ins.tauA] = setvals(inf(3,1));                           % gyro & acc correlation time 马尔可夫过程
    ins.lever = zeros(3,1); ins = inslever(ins);                        % lever arm
	ins.tDelay = 0;% time delay
    glv.wm_1 = zeros(3,1)';  glv.vm_1 = zeros(3,1)';  % for 'single sample+previous sample' coning algorithm
    ins.an0 = zeros(3,1);
