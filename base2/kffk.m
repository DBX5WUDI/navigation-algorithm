%% 建立卡尔曼滤波状态转移阵
function [Fk, Ft] = kffk(ins, varargin)
% 功能：建立卡尔曼滤波状态转移阵
% 输入：ins - SINS结构体
% 输出：Fk - 离散时间转移矩阵
%       Ft - 连续时间转移矩阵
    nts = ins.nts;
    Ft = etm(ins);   Ft(21,21) = 0;             %SINS误差方程中各个矩阵
    Mpp = Ft(7:9,7:9);
    Mpvvn = ins.Mpv*ins.vn;
    Mpvvnx = ins.Mpv*askew(ins.vn);
    MpvvnxCnb = Mpvvnx*ins.Cnb;                                             %DR误差方程中矩阵计算
    Ft(16:18,[1:3,16:18,19:20,21]) = [Mpvvnx,Mpp,MpvvnxCnb(:,[1,3]),Mpvvn]; %连续时间转移矩阵
	Fk = Ft*nts;                                % 离散时间转移矩阵 = 连续时间转移矩阵 * 总周期
    if nts>0.1                                  % 对于长时间周期，以下计算方法可能更精确。
        Fk = expm(Fk);                          % 自然指数exp()
    else                                        % Fk = I + Ft*nts + 1/2*(Ft*nts)^2  , 一步转移阵Φk,k-1计算
        Fk = eye(size(Ft)) + Fk;                % + Fk*Fk*0.5; 
    end
    
