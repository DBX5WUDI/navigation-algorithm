function varargout = setvals(varargin)
% ���ܣ���������ֵ������ȵ����ֵ����Ƕ�ױ�����չ��
% ���룺���ܴ���Ƕ�ױ���������ֵ
% �����ȫչ�������ֵ
    for k=1:nargout
        if nargin==1  % all the outputs are set to the same input value
            if iscell(varargin{1})  % avoid nesting varargin, be careful !
                if iscell(varargin{1}{1})
                    varargout{k} = varargin{1}{1}{k};
                else
                    varargout{k} = varargin{1}{k};
                end
            else
                varargout{k} = varargin{1};
            end
        else
            varargout{k} = varargin{k};
        end
    end