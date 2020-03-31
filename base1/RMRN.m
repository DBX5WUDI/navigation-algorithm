function [RMh, clRNh, RNh] = RMRN(pos)
% 功能：计算当地地球参数
% 输入：载体位置矢量
% 输出：当地子午圈（经圈）主曲率半径，当地卯酉圈主曲率半径，纬圈主曲率半径
global glv
	sl=sin(pos(:,1)); cl=cos(pos(:,1)); sl2=sl.*sl;
	sq = 1-glv.e2*sl2; sq2 = sqrt(sq);
	RMh = glv.Re*(1-glv.e2)./sq./sq2+pos(:,3);
	RNh = glv.Re./sq2+pos(:,3);    
    clRNh = cl.*RNh;
