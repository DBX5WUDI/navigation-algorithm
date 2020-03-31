function eth = ethinit(pos, vn)
% 功能：地球相关参数初始化
% 输入：pos-导航位置参数，vn-导航速度参数
% 输出：eth结构体
global glv
    eth.Re = glv.Re;    % 地球半长轴
    eth.e2 = glv.e2;    % 地球扁率平方
    eth.wie = glv.wie;  % 自转角速率
    eth.g0 = glv.g0;    % 重力值
    eth = ethupdate(eth, pos, vn);                      % 若知道载体的位置与速度即可求出地球相关参数
    % 以下相当于向量转置，行向量->列向量
    eth.wnie = eth.wnie(:);   eth.wnen = eth.wnen(:);   % 地球自转角速度，载体旋转角速度
    eth.wnin = eth.wnin(:);   eth.wnien = eth.wnien(:); % 载体相对惯性系角速度，载体相对惯性系角速度+载体相对于地球系角速度
    eth.gn = eth.gn(:);       eth.gcc = eth.gcc(:);     % 地球重力 
