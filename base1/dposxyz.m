function [dpxyz, idx1] = dposxyz(pos)
% 功能：使用pos阵列计算笛卡尔坐标系中的位置增量
% 输入：pos - 位置序列
% 输出：笛卡尔坐标系中的位置增量
% Using pos array to calculate position increment in Cartesian coordinates.
global glv
    idx1 = (normv(pos(:,1:3))~=0);
    idx0 = ~idx1;
    pos(idx0,1) = pos(idx1(1),1);
    pos(idx0,2) = pos(idx1(1),2);
    pos(idx0,3) = pos(idx1(1),3);
    dpxyz = pos;
    dpxyz(:,1:3) = [[pos(:,1)-pos(1,1),(pos(:,2)-pos(1,2))*cos(pos(1,1))]*glv.Re,pos(:,3)-pos(1,3)];