function xygo(xtext, ytext)
% 功能：坐标轴定义
% 输入：xtext - X坐标轴标签
%       ytext - Y坐标轴标签
%       若只输入一个值，则为Y轴标签，X轴标签为时间t
    if nargin==1 % xygo(ytext)
        ytext = xtext;
        xtext = '\itt \rm / s';%意大利斜体t 正常字体/s
    end
	xlabel(labeldef(xtext));
    ylabel(labeldef(ytext));
    grid on;  hold on;
