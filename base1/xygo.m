function xygo(xtext, ytext)
% ���ܣ������ᶨ��
% ���룺xtext - X�������ǩ
%       ytext - Y�������ǩ
%       ��ֻ����һ��ֵ����ΪY���ǩ��X���ǩΪʱ��t
    if nargin==1 % xygo(ytext)
        ytext = xtext;
        xtext = '\itt \rm / s';%�����б��t ��������/s
    end
	xlabel(labeldef(xtext));
    ylabel(labeldef(ytext));
    grid on;  hold on;
