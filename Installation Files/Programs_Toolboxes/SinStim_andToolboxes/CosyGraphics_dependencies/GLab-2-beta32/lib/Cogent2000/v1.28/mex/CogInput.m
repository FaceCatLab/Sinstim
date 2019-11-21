function varargout = CogInput(varargin)
% CogInput  Replacement of CogInput.mex v1.28, which is critically bugged!
%			Keyboard will not be open and a warning will be issued.

warning(['Keyboard support is not available with ''Cog'' library v1.28.' ...
		char(10) 'Use version 1.25 if you need keyboard.'])

for i = 1 : nargout
	varargout{i} = [];
end