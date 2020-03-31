function [nn, ts, nts] = nnts(nn, ts)
% 功能：设置字样数，采样周期，和他们的积
% 输入：子样数，采样周期
% 输出：子样数，采样周期，总周期
    nts = nn*ts;