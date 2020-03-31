function eth = earth(pos, vn)
% 功能：计算地球相关参数
% Calculate the Earth related parameters.
%
% Prototype: eth = earth(pos, vn)
% Inputs: pos - geographic position [lat;lon;hgt]
%         vn - velocity
% Outputs: eth - parameter structure array
%
% See also  ethinit, ethupdate, insupdate, trjsimu, etm.
global glv
    if nargin==1,  vn = [0; 0; 0];  end
    eth = glv.eth; 
    eth.pos = pos;  eth.vn = vn;
    eth.sl = sin(pos(1));  eth.cl = cos(pos(1));  eth.tl = eth.sl/eth.cl;   %pos(1)载体所在纬度
    eth.sl2 = eth.sl*eth.sl;  sl4 = eth.sl2*eth.sl2;                        %纬度的三角函数计算
    sq = 1-glv.e2*eth.sl2;  sq2 = sqrt(sq);                                 
    eth.RMh = glv.Re*(1-glv.e2)/sq/sq2+pos(3);                              %子午圈主曲率半径+高度
    eth.RNh = glv.Re/sq2+pos(3);  eth.clRNh = eth.cl*eth.RNh;               %卯酉圈主曲率半径+高度
    eth.wnie = [0; glv.wie*eth.cl; glv.wie*eth.sl];                         %地球自转角速度在地理系的向量
    vE_RNh = vn(1)/eth.RNh;                                                 
    eth.wnen = [-vn(2)/eth.RMh; vE_RNh; vE_RNh*eth.tl];                     %经、纬、高度变化率
    eth.wnin = eth.wnie + eth.wnen;                                         %n系相对i系旋转在n系的分量
    eth.wnien = eth.wnie + eth.wnin;
    eth.g = glv.g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3);   %讲义3.2-24；地球表面各地重力
    eth.gn = [0;0;-eth.g];                                                  %重力加速度在n系的向量
    eth.gcc =  [ eth.wnien(3)*vn(2)-eth.wnien(2)*vn(3);                     
                 eth.wnien(1)*vn(3)-eth.wnien(3)*vn(1);
                 eth.wnien(2)*vn(1)-eth.wnien(1)*vn(2)+eth.gn(3) ];         %有害加速度
    