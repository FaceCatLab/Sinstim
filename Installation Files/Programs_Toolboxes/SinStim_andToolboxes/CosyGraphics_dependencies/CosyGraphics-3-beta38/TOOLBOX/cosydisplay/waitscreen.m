function [Key,Time] = waitscreen(Message,varargin)
% WAITSCREEN  Display a message and wait for any key press.
%    WAITSCREEN(Message)
%    WAITSCREEN(Message,Option1,Option2,...)  defines text options.
%       See DRAWTEXT for text options.
%    Key = WAITSCREEN(...)  returns the key id. (See GETKEYMAP)
%    [Key,Time] = WAITSCREEN(...)  returns also the time when the key was
%       pushed down.
%
% Example 1:
%    waitscreen('Press any key when ready.');
%
% Example 2:
%    Key = waitscreen('Press ENTER to continue, Esc to exit.');
%    if strcmp(Key,'Escape'), return, end
%
% See also DRAWTEXT, WAITKEYDOWN, GETKEYMAP.
%
% Ben, Nov. 2007

global COSY_DISPLAY

% Input Arg.
if isnumeric(Message) && length(Message == 3)
    BgColor = Message;
    Message = varargin{1};
    varargin(1) = [];
else
    BgColor = COSY_DISPLAY.BackgroundColor;
end

clearbuffer(0,BgColor);
drawtext(Message,0,varargin{:});
displaybuffer(0);
clearbuffer(0,BgColor);
clearkeys;
[Key,Time] = waitkeydown(inf);
displaybuffer(0);


