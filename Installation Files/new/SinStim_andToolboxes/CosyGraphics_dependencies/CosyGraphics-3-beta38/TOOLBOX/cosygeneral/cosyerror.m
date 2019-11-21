function cosyerror(msg,varargin)
% COSYERROR  CosyGraphics' error function. <DOESN'T WORK AS EXPECTED>
%    COSYERROR(MSG)  stops cosygraphics if needed (if a display is open), then issues an error with
%    message MSG.
%
%    COSYERROR(MSG,A,B,C,...)  is the same than COSYERROR(SPRINTF(MSG,A,B,C,...)).
%
% Ben.J., Oct 2012.

msg = sprintf(msg,varargin{:});
cmd = ['error(''' msg ''');'];
evalin('caller',cmd);