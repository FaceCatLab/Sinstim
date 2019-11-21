function clearbuffer(b,color)
% CLEARBUFFER   Clear offscreen buffer.
%    CLEARBUFFER(b)  clears buffer b to default background color (as set 
%    with SETBACKGROUND).
%
%    CLEARBUFFER  is the same than  CLEARBUFFER(0).
%
%	 CLEARBUFFER(b,color)  clears buffer b to given color.
%	
% Example:
%	 clearbuffer(6,[1 1 1]);  % clears buffer 6 to white.
%
% Performances:
%    With no background buffer, on WinXP, on Matlab 6.5, on DARTAGNAN:
%    - On PTB:    0.18 ms
%    - On Cogent: 0.38 ms
%
% See also NEWBUFFER SETBACKGROUND.
%
% Ben, 	Sept 2007

% 		Avr. 2008: Fix pen color bug.

global GLAB_DISPLAY GLAB_BUFFERS

% Check input arg.
if ~nargin, b = 0; end
if length(b) > 1, error('First argument must be the buffer handle.'), end
if nargin < 2,
	color = GLAB_DISPLAY.BackgroundColor;
end

% Copy background buffer on back buffer:
if b == 0 && ~isempty(GLAB_BUFFERS.BackgroundBuffer)
    copybuffer(GLAB_BUFFERS.BackgroundBuffer,0);
    
% Clear buffer:
else
    if iscog % CG
        cgsetsprite(b);
        S = cgGetData('GPD');
        cgpencol(color(1),color(2),color(3)); % --!
        cgrect;
        cgpencol(S.DrawCOL.CR.Red/255,S.DrawCOL.CR.Grn/255,S.DrawCOL.CR.Blu/255) % --!
    else     % PTB
        if ~b, b = gcw; end
        Screen('FillRect', b, round(color*255));
    end
    
end