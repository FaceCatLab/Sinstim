function setpriority(priority,option)
% SETPRIORITY  Request Windows to change the priority level given to MATLAB.
%    SETPRIORITY OPTIMAL   raises priority, letting G-Lab choose for you the best compromize between 
%    raising privilege and avoiding troubles, depending of your OS and peripherals in use.
%
%    SETPRIORITY NORMAL    Like any other user program.
%
%    SETPRIORITY HIGH      Higher priority than other user programs, but lower than system processes.
%
%    SETPRIORITY REALTIME  Higher priority than some system processes. That can cause troubles. Don't
%    stay longer than necessary in this priority level. If you still experiment troubles, use HIGH 
%    priority instead. Note that "REALTIME" priority does not ensure by itself that you'll get a 
%    perfect timing accuracy. "REALTIME" is just the name that Microsoft choosed for the highest 
%    priority level that a user program can get in the Windows operating system (which is NOT a 
%    real-time operating system).
%
%    SETPRIORITY LOW       Less than normal. Usefull to let Windows do its management task.
%
%    SETPRIORITY XXX -SILENT    runs in "silent" mode: displays nothing in command window.

% Ben, Sept 2007.

global GLAB_CURRENT_PRIORITY cogent


%% Input Args
if ischar(priority)
    priority = upper(priority);
    priority_str = priority;
else
    priority_num = priority;
end
if nargin > 1 && strcmpi(option,'-silent')
    isSilent = 1;
else
    isSilent = 0;
end
    
%% Set priority
% On windows we'll use CG's cogstd(), on Linux & MacOSX we'll use PTB's Priority()
if ispc % MS-Windows: We'll use CogentGraphics's "cogstd" function 
    if strcmpi(priority,'OPTIMAL')
        % On Windows, the PsychToolbox3, uses always HIGH priority exept if sound
        % is needed. Let's do the same.
        if isfield(cogent,'sound')
            priority = 'NORMAL';
        else
            priority = 'HIGH';
        end
    end

    if strcmpi(priority,'LOW')
        priority = 'IDLE'; % CG uses "IDLE" for Microsoft "LOW" priority.
    end
    
    switch priority
        case {'IDLE','NORMAL','HIGH','REALTIME'}
            cogstd('sPriority',priority)
        otherwise
            error('Invalid Priority argument. Priority can be ''OPTIMAL'', ''LOW'', ''NORMAL'', ''HIGH'' or ''REALTIME''.')
            % NB: Other Windows priority levels (BelowNormal, AboveNormal) are not supported by cogstd.
    end
    
else % Linux / MacOS X: We'll use PTB's "Priority" function
    if ischar(priority)         
        % char -> #
        if IsLinux % ('IsLinux' is a PTB function) Linux
            switch priority
                case {'IDLE','LOW','NORMAL'},   priority_num = 0;
                case 'NORMAL',                  priority_num = 0;
                case 'HIGH',                    priority_num = 1;
                case 'OPTIMAL',                 priority_num = 1; % 1 is suggested by PTB doc
                case 'REALTIME',                priority_num = 99;
                otherwise, error('Invalid Priority argument. Priority can be ''OPTIMAL'', ''NORMAL'', ''HIGH'' or ''REALTIME''.')
            end
            
        elseif IsOSX % ('IsOSX' is a PTB function) OS X: We'll use PTB's "Priority" function
            switch priority
                case {'IDLE','LOW','NORMAL'},   priority_num = 0;
                case 'NORMAL',                  priority_num = 0;
                case 'HIGH',                    priority_num = 5; % arbitrarily decided 
                case 'OPTIMAL',                 priority_num = 9; % following PTB's doc, no adverse effect if we use max priority
                case 'REALTIME',                priority_num = 9; % max priority = 9
                otherwise, error('Invalid Priority argument. Priority can be ''OPTIMAL'', ''NORMAL'', ''HIGH'' or ''REALTIME''.')
            end

        end

    end
    
    Priority(priority_num); % 'Priority' is a PTB function ; 'priority' is our input variable.
    
end


%% Update GLab's global var
GLAB_CURRENT_PRIORITY = priority; % <TODO: Fix case str/num on different OSes>


%% Display infos
if ~isSilent
    if ischar(priority)
        if ispc, % Windows (always waiting a Windows priority name as argument)
            if strcmp(priority_str,'OPTIMAL') % special case of "OPTIMAL" (this is not a MS name, it's aGLab name)
                str = sprintf('Priority set to "%s" (= "%s").', priority_str, priority);
            else
                str = sprintf('Priority set to "%s".', priority);
            end
        else % OSX/Linux, Windows priority name was given has argument
            str = sprintf('Priority set to %d ("%s").', priority_num, priority);
        end
    else % OSX/Linux, OSX/Linux priority number was given has argument
        str = sprintf('Priority set to %d.', priority);
    end
    
    dispinfo(mfilename,'info', str)
    
end
