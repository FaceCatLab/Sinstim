function setbackground(varargin)
% SETBACKGROUND  <COGENT ONLY !!!> Set default backgound color. {fast}
%    This function is only supported over COgent. If you are using PsychTB, change your background
%    with CLEARBUFFER.
%
%    SETBACKGROUND(rgb)  sets default backgound color to rgb. rgb is a [red green blue] vector in
%    the range 0.0 to 1.0. This background color will be used by NEWBUFFER (by default) and 
%    DISPLAYBUFFER.
%
%    SETBACKGROUND(b)  defines buffer b as the default background.
%
%    SETBACKGROUND([])  undo SETBACKGROUND(b).
%
% See also STARTCOGENT/STARTPSYCH, OPENDISPLAY, NEWBUFFER, DISPLAYBUFFER, GBB.
%
% Ben,	Sep 2007.

%		Mar 2008. Suppr. cogent.display.bg
%       Feb 2009. Update Blank buffer.

% <TODO: Store image in background (?)>
% <TODO: What to do with PTB !!!???>

global COSY_DISPLAY

for i = 1 : nargin
    switch length(varargin{i})
        case 3
            color = varargin{i};
            color = color(:)'; % ensure it's a row vector
            COSY_DISPLAY.BackgroundColor = color;
%             clearbuffer(COSY_DISPLAY.BUFFERS.BlankBuffer) % <TODO: Not used. Suppress???> <Suppr in v3-beta4>
        case 1
            b = varargin{i};
            COSY_DISPLAY.BUFFERS.BackgroundBuffer = b;
        case 0
            COSY_DISPLAY.BUFFERS.BackgroundBuffer = [];
    end
end
clearbuffer(0)