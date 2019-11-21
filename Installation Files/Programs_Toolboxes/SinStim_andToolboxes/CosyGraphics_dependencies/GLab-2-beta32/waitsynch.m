function varargout = waitsynch(Dur,Unit,Option)
% WAITSYNCH  Wait function for real-time display programs.
%    This function is intended to be used in conjunction with DISPLAYBUFFER.
%
%    t0 = WAITSYNCH  or  t0 = WAITSYNCH(0)  waits the beginning of next refresh
%    cycle.  This is the same than:  t0 = WAITFRAME.
%
%    WAITSYNCH(t)  waits t milliseconds between two displays. Waiting is synchro-
%    nized with the screen refresh cycle : wait duration will be rounded to an 
%    integer number of screen frames and will end precisely at the beginning  
%    of the last refresh cycle, so the next call to DISPLAYBUFFER will display  
%    exactly t ms after the previous one.
%
%    WAITSYNCH(t,unit)  waits t units. Unit can be 'ms' (default), 'sec' (or 's')
%    or 'frame'.
%
%    err = WAITSYNCH(...)  returns error status. "err" is an estimation of the
%    number of missed frames. (This is not 100pc reliable.)
%
% GLab programmer only: 
%    WAITSYNCH(t,'ms','-displaybuffer')  is used by displaybuffer.
%
% Example: Wait 500ms between two displays
%    displaybuffer(b1); % displays buffer b1.
%    waitsynch(500)     % waits the time needed (actually less than 500ms).
%    displaybuffer(b);  % displays buffer b2, 500ms after buffer b1.
%
% See also : DISPLAYBUFFER, GETFRAMEDUR, WAITFRAME, WAIT, TIME.
%
% Ben,	Oct 2007

% 0.1 	Oct 	
% 1.0	Nov		  Critical fix (!!!): Substract one frame duration: Now the function returns  
%                 after the blanking interval BEFORE the end of the duration, so the next 
%                 call to DISPLAYBUFFER will display the image just in time.
% 2.0   Nov 2008  Major fix (!): Substract GLAB_DISPLAY.LastDisplayTime.
%                 Check abort.
% 2.1   Jan 2010  


global GLAB_DISPLAY GLAB_TRIAL


if ~nargin ...  %    t0 = WAITSYNCH
        || ~Dur %    t0 = WAITSYNCH(0)  <NB: This is used by displayanimation.>
	t = waitframe;
    varargout{1} = t; %(ms)
	
else			%    WAITSYNCH(t,...)
    % Store display duration <v2-beta21>
    if nargin < 3 % it's not  WAITSYNCH(t,'ms','-displaybuffer')  which is used by displaybuffer.
        if GLAB_TRIAL.isStarted % If we are between STARTTRIAL and STOPTRIAL..
            i = GLAB_TRIAL.iDisplay;
            if i
                % <suppr. warning because can be usefull to use waitsynch several times, 
                %  see handselect, blank2 for example>
%                 if ~isnan(GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms(i)), % 
%                     dispinfo(mfilename,'warning','Display has been set more than once.')
%                 end
                GLAB_TRIAL.PERDISPLAY.ExpectedDurations_ms(i) = Dur;
            end
            GLAB_DISPLAY.CurrentDisplayDuration = Dur;
        end
    end
    
    % F: Number of frames to wait
    if nargin < 2, Unit = 'ms'; end % Default unit is ms
    OneFrame = getframedur;
    if strmatch('ms',Unit)
        F = round(Dur/OneFrame);
    elseif strmatch('s',Unit)
        F = round(Dur*1000/OneFrame);
    elseif strmatch('frame',Unit)
        F = Dur;
    elseif ~strcmpi(Unit,'ms')
        error('Invalid Unit argument.')
    end
    
    % F = F - 1
    F = F - 1; % Substract one frame: we need to wait until the vsync *before* the target vsync.
	if F <= 0,
		return % <---!!!
	end
    
    % F0: Already elapsed frames
    if isempty(GLAB_DISPLAY.LastDisplayTime)
        error('WAITSYNCH can only be called between two DISPLAYBUFFER calls.')
    end
    t0 = time;
    F0 = floor( (t0 - GLAB_DISPLAY.LastDisplayTime) / OneFrame );
% t91 =time - GLAB_TRIAL.StartTimeStamp
% f91= F - F0
    % WAIT!
    if F - F0 > 0
        [err,F] = waitframe(F - F0);  %  W . . . a . . . i . . . t . . .
    end
% t95=time - GLAB_TRIAL.StartTimeStamp
    % Output error status
	if nargout
		varargout{1} = err;
		varargout{2} = F;
	end

end