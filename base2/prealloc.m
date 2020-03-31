function varargout = prealloc(row, varargin)
% Pre-allocate memory for variables before being used in loop. 
% all of the variables share the same row, but may have different 
% columns listed in varargin.
%
% Prototype: varargout = prealloc(row, varargin)
%
% See also  setvals.
    for k=1:nargout
        if nargin==2  % if all of the outputs share the same column
            varargout{k} = zeros(row, varargin{1});
        else
            varargout{k} = zeros(row, varargin{k});
        end
    end