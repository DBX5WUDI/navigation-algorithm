%% �õ������л��еķ���
function res = normv(vects, dim)
% ���ܣ��õ������л��еķ���
% ���룺vects - ����
%       dim - 1 Ϊ���м��㣬2 Ϊ���м���
% �����res - 1 ������������2 ����������
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
