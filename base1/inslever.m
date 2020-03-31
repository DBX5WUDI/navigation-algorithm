function ins = inslever(ins, lever)
% 功能：SINS杆臂检测或者补偿
% 输入：ins-惯导结构体输入，lever-杆臂一列代表一个检测点
% 输出：ins-带有杆臂参数的惯导结构体
    if nargin<2, lever = ins.lever;  end
    ins.CW = ins.Cnb*askew(ins.web);
    ins.MpvCnb = ins.Mpv*ins.Cnb;
    ins.Mpvvn = ins.Mpv*ins.vn;
    n = size(lever,2);
    if n>1,
        ins.vnL = repmat(ins.vn,1,n) + ins.CW*lever;
        ins.posL = repmat(ins.pos,1,n) + ins.MpvCnb*lever;
    else  % else n==1, the following code is faster
        ins.vnL = ins.vn + ins.CW*lever;
        ins.posL = ins.pos + ins.MpvCnb*lever;
    end
