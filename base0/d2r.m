%% 角度转换成弧度

function rad = d2r(deg)
% 功能：角度值转成弧度值
% 输入：deg - 角度值
% 输出：rad - 弧度值
global glv
    rad = deg*glv.deg;
