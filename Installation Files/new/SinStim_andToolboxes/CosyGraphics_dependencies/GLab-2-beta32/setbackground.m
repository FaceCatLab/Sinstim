function setbackground(varargin)
% SETBACKGROUND  Set default backgound color.
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

global GLAB_DISPLAY GLAB_BUFFERS

for i = 1 :  nargin
    switch length(varargin{i})
        case 3
            color = varargin{i};
            color = color(:)'; % ensure it's a row vector
            GLAB_DISPLAY.BackgroundColor = color;
            clearbuffer(GLAB_BUFFERS.BlankBuffer) % <TODO: Not used. Suppress???>
        case 1
            b = varargin{i};
            GLAB_BUFFERS.BackgroundBuffer = b;
        case 0
            GLAB_BUFFERS.BackgroundBuffer = [];
    end
end
clearbuffer(0)