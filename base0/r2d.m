%% 弧度转换为角度

function deg = r2d(rad)
% 功能：弧度转换为角度
% 输入：rad - 弧度值
% 输出：deg - 角度值
global glv
    deg = rad/glv.deg;
