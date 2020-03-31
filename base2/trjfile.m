%% 加载或者保存*.mat文件
function trj = trjfile(fname, trj)
% 功能：加载或者保存*.mat文件
% 输入：fname - 带有默认扩展'.mat'的数据文件
%       trj - 若保存文件，输入保存的数据文件
% 输出：trj - 若加载文件，输出保存的数据文件
% 用法：
%    保存: trjfile(fname, trj);
%    加载: trj = trjfile(fname);
global glv
    if isempty(strfind(fname, '.'))     % 输入规范检查
        fname = [fname, '.', 'mat']; 
    end
    if ~exist(['.\',fname],'file')      % 检查工作路径下有无轨迹文件
        fname = [glv.datapath, fname];  % 若无，在data路径下寻找
    end
    
    if nargin<2                         % 加载
        trj = load(fname);
        trj = trj.trj;
    else                                % 保存
        save(fname, 'trj');
    end

