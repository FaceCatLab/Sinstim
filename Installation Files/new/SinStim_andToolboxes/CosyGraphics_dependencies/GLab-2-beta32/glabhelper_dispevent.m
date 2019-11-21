function glabhelper_dispevent(CallerName,EventStr,Time,ExpectedInterval)
% HELPER_DISPEVENT  GLab helper function: Display Event message, with time in ms.
%    HELPER_DISPEVENT -INIT  inits function ; used by starttrials.
%
%    HELPER_DISPEVENT(MFILENAME,Str,Time)
%
%    HELPER_DISPEVENT(MFILENAME,Str,Time,ExpectedInterval)
%
% Ben,  Jun 2010.

%% Global vars
global GLAB_TRIAL GLAB_DEBUG GLAB_DISPLAY

%% Persistent variable
% The function stores last timestamps in it's own persistent variable and not in GLAB_TRIALS because
% events can use the trial events system (trough optional args to displaybuffer) or be programmed 
% directly by the user via direct use of, e.g., sendparallelbytes. 
persistent LastTimeStamps % Used to compute intervals, only during trial (between starttrial & stoptrial)

%% Main
if nargin == 1 && strcmpi(CallerName,'-init')
    LastTimeStamps.display     = 0;
    LastTimeStamps.parallelout = 0;
    
elseif GLAB_DEBUG.doDispEvents % Only if verbose mode is not (not the default)..
    % Time
    t_abs = Time;
    delta = 0;

    if GLAB_TRIAL.isStarted || ...
        GLAB_TRIAL.isWaitingFirstFrame % Between starttrial & stoptrial..
        % ..Use relative time (from trial start):
        if GLAB_TRIAL.isWaitingFirstFrame, t = 0;
        else                               t = t_abs - GLAB_TRIAL.StartTimeStamp;
        end
        % ..Add time interval:
        switch lower(CallerName)
            case 'displaybuffer',     Event = 'display';
            case 'sendparallelbyte',  Event = 'parallelout';
            case 'displayframeseq',   Event = 'display';
            otherwise                 Event = '';
        end
        if ~isempty(Event)
            if LastTimeStamps.(Event)
                delta = t_abs - LastTimeStamps.(Event);
            end
            LastTimeStamps.(Event) = t_abs;
        end
        
    else % Not during trial..
        % ..basic mode: Display only absolute time.
        t = t_abs;
        
    end

    % Time string
%     tstr = num2str(round(t*10) / 10);
%     if any(tstr == '.'),  n = 7;
%     else                  n = 5;
%     end
%     tstr = [blanks(length(tstr)-6)  tstr];
%     tstr = [tstr ' ms: '];
    if iscog, tstr = sprintf('%d ms: ', round(t));
    else      tstr = sprintf('%8.1f ms: ', t);
    end
        
    % Event string
    if EventStr(end) ~= '.', EventStr(end+1) = '.'; end
    
    % Interval string
    if delta
        df = round(delta/getframedur);
%         dstr = [' Interval: ' num2str(round(delta*10) / 10) ' ms, ' ...
%                 num2str(df) ' frames'];
        if iscog, dstr = sprintf('  Interval: %6d ms,%4d frames.', round(delta), df);
        else      dstr = sprintf('  Interval:%7.1f ms,%4d frames.', delta, df);
        end
    else
        dstr = '';
    end
    
    % End string
    if delta && GLAB_TRIAL.isStarted && exist('ExpectedInterval','var') && ~isnan(ExpectedInterval)
        n = round(ExpectedInterval / getframedur);
        dstr(end) = ',';
        if n == df,  estr = sprintf('%4d expected.  [ok]    ', n);
        else         estr = sprintf('%4d expected.  [ERROR!]', n);
        end
    else
        estr = '';
    end
  
    % Final string
    String = [tstr EventStr dstr estr];
    
    % Display info:
    switch GLAB_DEBUG.doDispEvents
        case 1 % Store in global var which will be printed at trial end
            if isfield(GLAB_TRIAL,'isStarted') && GLAB_TRIAL.isStarted % Between starttrial & stoptrial..
                i0 = GLAB_TRIAL.EventsString_i0;
                di = length(String);
                GLAB_TRIAL.EventsString(i0+1:i0+di) = String;
                GLAB_TRIAL.EventsString(i0+di+1) = char(10);
                GLAB_TRIAL.EventsString_i0 = i0 + di + 1; 
                if i0 > 1e7
                    warning('To many events. EventsString to short !!! Timing errors probable !!!')
                end
            else % Trial not started: Display nothing.
            end
        case 2 % Print during trial
            dispinfo(CallerName,'event',String);
    end
   
end