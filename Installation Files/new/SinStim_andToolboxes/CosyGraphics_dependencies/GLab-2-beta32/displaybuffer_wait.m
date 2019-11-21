function t = displaybuffer(b,Wait)
% DISPLAYBUFFER  Display content of offscreen buffer at next refresh cycle.
%    t = DISPLAYBUFFER  or  DISPLAYBUFFER(0)  flips the frontbuffer and the 
%    backbuffer of the onscreen window: at next refresh cycle the current 
%    backbuffer will become the new frontbuffer and be displayed. Returns time
%    of the beginning of the screen refresh cycle, in milliseconds.
%
%	 t = DISPLAYBUFFER(b)  displays buffer b. Buffer will first be copied
%    into the backbuffer (or buffer 0), then the backbuffer will be flipped
%    as explained above and displayed.
%
%    t = DISPLAYBUFFER(b,WAIT)  waits WAIT duration in msec from the onset
%    of the previous display, then displays buffer b.
%    This is the same than  WAITSYNCH(WAIT); t = DISPLAYBUFFER(b);  which is
%    deprecated.
%
% Example:
%    % Draw consign in an offscreen buffer:
%    b1 = newbuffer; % use newbuffer to create a drawable offscreen buffer
%    drawtext('Press Enter when ready.',b1);
%    % Load image from file and store it an offscreen buffer:
%    I = loadimage(filename);
%    b2 = storeimage(I); % use storeimage to store image in an offscreen buffer
%    % Display:
%    displaybuffer(b1); % display consign
%    displaybuffer(b2,700); % wait 700 msec and display image
%    displaybuffer(0,2000); % wait 2000 msec and clear screen (i.e.: display buffer 0, which had 
%                           % been automatically cleared after the last display.)
%
% See also NEWBUFFER, STOREIMAGE, GCB
%
% Ben,	Sept-Oct 2007

%  		May 2008: Suppr. 'dontclear' option (Did not work).

global GLAB_BUFFERS GLAB_DISPLAY GLAB_TRIAL GLAB_PHOTODIODE GLAB_EYELINK GLAB_IS_ABORT

%% Check Abort
if checkkeydown('Escape');
    GLAB_IS_ABORT = 1;
    t = -1;
    return %                  <===!!!
end

%% Input arg.
if ~nargin
	b = 0;
end
if ischar(b),
    b = str2num(b); % To allow a command syntax in the Command Window.
end
% if nargin == 2  % v1.5.3: 'dontclear' doesn't work!	<TODO: check if working with cg1.28>
% 	switch lower(dontclear)
% 		case 'dontclear', dontclear = 1;
% 		case 'clear',     dontclear = 0;
% 	end
% else
% 	dontclear = b;
% end

%% Copy b -> 0
% If buffer to display is not the backbuffer of the onscreen window,
% we have first to copy it first to the backbuffer (buffer 0). This 
% operation is not synchronized with the refresh cycle.
if b > 0 && b ~= gcw
    copybuffer(b,0);
end

%% Photodiodes: Draw squares
if ~isempty(GLAB_PHOTODIODE) && GLAB_PHOTODIODE.isPhotodiode
    [x0,x1] = getscreenxlim;
    [y0,y1] = getscreenylim;
    w = GLAB_PHOTODIODE.SquareSize;
    POS = [x0+w/2 y1-w/2; x0+w/2 y0+w/2; x1-w/2 y1-w/2; x1-w/2 y0+w/2]; % [UL; BL; UR; BR]
    RGB = repmat(GLAB_PHOTODIODE.Values(:),1,3);
    POS(~GLAB_PHOTODIODE.Locations(:),:) = [];
    RGB(~GLAB_PHOTODIODE.Locations(:),:) = [];
    drawshape('square',0,POS,w,RGB);
end

%% Wait?
if nargin >= 2
    waitsynch(Wait);
end

%% Display! 
% Flip backbuffer (buffer 0) and onscreen buffer and clear backbuffer 
% This operation is synchronized with the refresh cycle.
if iscog % CG
    bg = GLAB_DISPLAY.BackgroundColor;
    t = cgflip(bg(1),bg(2),bg(3)); % <== DISPLAY !
    if t == -2, error('cgflip error: Probably no Cogent display open.'), end
    t = t * 1000; % sec -> ms      % < v2-alpha2: suppr. "floor" !>
    % 	if dontclear  % <v1.5.3: 'dontclear' doesn't work!>
    % 		t = floor(cgflip * 1000);
    % 	else
    % 		bg = GLAB_DISPLAY.BackgroundColor;
    % 		t = floor(cgflip(bg(1),bg(2),bg(3)) * 1000);
    % 	end

else     % PTB
    w = gcw;
    Screen('DrawingFinished',w); % Optimization.
    t = Screen('Flip',w); % <== DISPLAY !
    t = t * 1000; % sec -> ms
    
end

%% Immediately after display
% Trial: First frame onset synchronization events
if ~isempty(GLAB_TRIAL) && GLAB_TRIAL.isWaitingFirstFrame
    % Eyelink: Send trial sync message
    if ~isempty(GLAB_EYELINK) && GLAB_EYELINK.isOpen % don't use checkeyelink for optimization
        sendeyelinksync;
    end
end

%% Update global var.
GLAB_BUFFERS.LastDisplayedBuffer = b;
GLAB_DISPLAY.LastDisplayTime = t;

%% Output time?
if ~nargout
	clear t
end