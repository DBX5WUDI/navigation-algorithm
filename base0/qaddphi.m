%% 从精确四元数和失准角中得到计算四元数
function qpb = qaddphi(qnb, phi)
% 功能：从精确四元数和失准角中得到计算四元数
% 输入：qnb - 精确四元数
%       phi - 失准角
% 输出：qpb - 计算四元数
    qpb = qmul(rv2q(-phi),qnb);
% 计算四元数 = 精确四元数 - 失准角