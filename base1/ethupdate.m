function eth = ethupdate(eth, pos, vn)
% 功能：地球相关参数结构体更新
% 输入：eth - 更新前的地球结构体
%       pos - 载体的几何位置
%       vn - 载体速度
% 输出：更新后的地球相关参数结构体
    if nargin==2,  vn = [0; 0; 0];  end
    eth.pos = pos;  
    eth.vn = vn;
    eth.sl = sin(pos(1));  eth.cl = cos(pos(1));  eth.tl = eth.sl/eth.cl;   % 纬度的sin、cos、tan值 
    eth.sl2 = eth.sl*eth.sl;  sl4 = eth.sl2*eth.sl2;                        % 纬度sin值的2、4次方

    sq = 1-eth.e2*eth.sl2;  RN = eth.Re/sqrt(sq);                           % 卯酉圈主曲率半径
    eth.RNh = RN+pos(3);  eth.clRNh = eth.cl*eth.RNh;                       % 卯酉圈主曲率半径+海平面上高度
    eth.RMh = RN*(1-eth.e2)/sq+pos(3);                                      % 子午圈主曲率半径+海平面上高度
    
    eth.wnie(1) = 0; eth.wnie(2) = eth.wie*eth.cl; eth.wnie(3) = eth.wie*eth.sl;                                                    % 地球自转角速度的在导航系上的投影
    eth.wnen(1) = -vn(2)/eth.RMh; eth.wnen(2) = vn(1)/eth.RNh; eth.wnen(3) = eth.wnen(2)*eth.tl;                                    % 导航系相对于地球系的角速度在导航系上的投影
    eth.wnin(1) = eth.wnie(1) + eth.wnen(1); eth.wnin(2) = eth.wnie(2) + eth.wnen(2); eth.wnin(3) = eth.wnie(3) + eth.wnen(3);      % 导航系相对于惯性系的角速度在导航系上的投影
    eth.wnien(1) = eth.wnie(1) + eth.wnin(1); eth.wnien(2) = eth.wnie(2) + eth.wnin(2); eth.wnien(3) = eth.wnie(3) + eth.wnin(3);   % 地球系和导航系相对于惯性系的角速度之和
    
    eth.g = eth.g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3);   % 考虑高度的不同纬度的重力场
    eth.gn(3) = -eth.g;                                                     % 只有在天向才有分量
    eth.gcc(1) = eth.wnien(3)*vn(2)-eth.wnien(2)*vn(3);                     % 载体运动和地球自转引起的哥氏加速度和载体运动引起的对地向心加速度
    eth.gcc(2) = eth.wnien(1)*vn(3)-eth.wnien(3)*vn(1);                     % 有害加速度
    eth.gcc(3) = eth.wnien(2)*vn(1)-eth.wnien(1)*vn(2)+eth.gn(3);
