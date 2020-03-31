%% 捷联惯导数值更新算法
function ins = insupdate(ins, imu)
% 功能：SINS数值更新算法
% 输入：ins - 数值更新前的SINS结构体
%       imu - 多子样惯导IMU数据
% 输出：数值更新后的SINS结构体
    nn = size(imu,1);                                               %字样个数，size返回数据行数
    nts = nn*ins.ts;  nts2 = nts/2;  ins.nts = nts;                 %采样周期，总周期
    [phim, dvbm] = cnscl(imu,0);                                    %锥进补偿后的旋转矢量， 经过旋转与划桨补偿后的速度增量
    phim = ins.Kg*phim-ins.eb*nts; dvbm = ins.Ka*dvbm-ins.db*nts;   %器件标度参数与常值偏差补偿
    %% earth & angular rate updating 
    vn01 = ins.vn+ins.an*nts2; pos01 = ins.pos+ins.Mpv*vn01*nts2;   % extrapolation at t1/2
    ins.eth = ethupdate(ins.eth, pos01, vn01);                      %地球相关结构体更新
    ins.wib = phim/nts; ins.fb = dvbm/nts;                          %运载体相对于惯性系的角速度=旋转矢量/周期 比力=速度变化/周期
    ins.web = ins.wib - ins.Cnb'*ins.eth.wnie;                      %
    ins.wnb = ins.wib - (ins.Cnb*rv2m(phim/2))'*ins.eth.wnin;       
    %% (1)velocity updating
    ins.fn = qmulv(ins.qnb, ins.fb);                                %比力
    ins.an = rotv(-ins.eth.wnin*nts2, ins.fn) + ins.eth.gcc;        %比力+有害加速度
    vn1 = ins.vn + ins.an*nts;                                      %速度更新
    %% (2)position updating
    ins.Mpv(4)=1/ins.eth.RMh; ins.Mpv(2)=1/ins.eth.clRNh;
    ins.Mpvvn = ins.Mpv*(ins.vn+vn1)/2;
    ins.pos = ins.pos + ins.Mpvvn*nts;  
    ins.vn = vn1;
    ins.an0 = ins.an;
    %% (3)attitude updating
    ins.Cnb0 = ins.Cnb;
    ins.qnb = qupdt2(ins.qnb, phim, ins.eth.wnin*nts);
    [ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);
    ins.avp = [ins.att; ins.vn; ins.pos];

