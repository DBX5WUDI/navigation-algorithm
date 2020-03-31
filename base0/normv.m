%% 得到矩阵行或列的范数
function res = normv(vects, dim)
% 功能：得到矩阵行或列的范数
% 输入：vects - 矩阵
%       dim - 1 为按行计算，2 为按列计算
% 输出：res - 1 范数行向量，2 范数列向量
    if nargin<2,   dim = 2;   end
    res = 0;
    if dim==1
        for k=1:size(vects,1)
            res = res + vects(k,:).^2;
        end
    else
        for k=1:size(vects,2)
            res = res + vects(:,k).^2;
        end
    end
    res = sqrt(res);
