function varargout = setvals(varargin)
% 功能：根据输入值设置相等的输出值，将嵌套变量都展开
% 输入：可能存在嵌套变量的输入值
% 输出：全展开的输出值
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