function helper_dispevent(CallerName, EventStr, t_abs, ExpectedInterval)
% HELPER_DISPEVENT  CosyGraphics helper function: Display event message, with time in ms.
%    HELPER_DISPEVENT -INIT  inits function. Used by STARTTRIAL.
%
%    HELPER_DISPEVENT(MFILENAME, Str, Time <,ExpectedInterval>)  generates a string containg event
%    infos (timestamp, error status, etc.) and:
%    - if called between STARTTRIAL and STOPTRIAL, and COSY_GENERAL.doDispEvents = 2, stores this
%      string in a global var, COSY_TRIALLOG.EventsString. This stored string will be later printed
%      by STOPTRIAL once the real-time phase is over. (This is because printing in Command Window
%      can cause delays of several milliseconds.)
%    - if called outside STARTTRIAL-STOPTRIAL, or COSY_GENERAL.doDispEvents = 1, prints directly
%      in Command Window. Don't do that during an experiment.
%    - if COSY_GENERAL.doDispEvents = 0, does nothing.
%
% Ben,  Jun 2010.


%% Global vars
global COSY_GENERAL COSY_TRIALLOG

%% Persistent variable
% The function stores last timestamps in it's own persistent variable and not in COSY_TRIALLOGS because
% events can use the trial events system (trough optional args to displaybuffer) or be programmed
% directly by the user via direct use of, e.g., sendparallelbytes.
persistent LastTimeStamps % Used to compute intervals, only during trial (between starttrial & stoptrial)

%% Main
if nargin == 1 && strcmpi(CallerName,'-init')
    LastTimeStamps.display     = 0;
    LastTimeStamps.parallelout = 0;

elseif isfield(COSY_GENERAL,'doDispEvents')
    if COSY_GENERAL.doDispEvents % Only in verbose mode. Default is 1 (0: don't display, 1: display after trial / don't display if not in trial, 2: display during trial.)..
        delta = 0;

        if COSY_TRIALLOG.isStarted || ...
                COSY_TRIALLOG.isWaitingFirstFrame % Between starttrial & stoptrial..
            % ..Use relative time (from trial start):
            if COSY_TRIALLOG.isWaitingFirstFrame, t = 0;
            else                                  t = t_abs - COSY_TRIALLOG.StartTimeStamp;
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

        % Time string + ...
        %     tstr = num2str(round(t*10) / 10);
        %     if any(tstr == '.'),  n = 7;
        %     else                  n = 5;
        %     end
        %     tstr = [blanks(length(tstr)-6)  tstr];
        %     tstr = [tstr ' ms: '];
        if iscog, tstr = sprintf('%d ms: ', round(t));
        else      tstr = sprintf('%8.2f ms: ', t);
        end

        % + Event string
        if EventStr(end) ~= '.', EventStr(end+1) = '.'; end

        % + Interval string
        if delta
            df = round(delta/oneframe);
            if iscog
                dstr = sprintf('       -> Display interval: %6d ms,%4d frames.', round(delta), df);
            else
                dstr = sprintf('         -> Display interval:%7.2f ms,%4d frames.', delta, df);
            end
        else
            dstr = '';
        end

        % + End string
        if delta && COSY_TRIALLOG.isStarted && exist('ExpectedInterval','var') && isfinite(ExpectedInterval) && ExpectedInterval > 0
            n = round(ExpectedInterval / oneframe);
            dstr(end) = ',';
            if n == df,       estr = sprintf('%4d expected.  [ok]    ', n);
            else              estr = sprintf('%4d expected.  [ERROR!]', n);
            end
        else
            estr = '';
        end

        % Concat. final string  <v2-beta43: change order & print on 2 lines>
        if ~isempty(dstr),  String = [dstr estr 10 tstr EventStr];
        else                String = [tstr EventStr];
        end

        % Display info:
        switch COSY_GENERAL.doDispEvents
            case 1 % Store in global var which will be printed at trial end
                if isfield(COSY_TRIALLOG,'isStarted') && COSY_TRIALLOG.isStarted % Between starttrial & stoptrial..
                    i0 = COSY_TRIALLOG.EventsString_i0;
                    di = length(String);
                    COSY_TRIALLOG.EventsString(i0+1:i0+di) = String;
                    COSY_TRIALLOG.EventsString(i0+di+1) = char(10);
                    COSY_TRIALLOG.EventsString_i0 = i0 + di + 1;
                    if i0 > 1e7
                        warning('To many events. EventsString to short !!! Timing errors probable !!!')
                    end
                else % Trial not started: Display nothing.
                end
            case 2 % Print during trial
                dispinfo(CallerName,'event',String);
        end
    end
end
