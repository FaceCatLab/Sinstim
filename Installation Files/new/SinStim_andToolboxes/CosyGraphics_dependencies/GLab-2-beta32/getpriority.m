function p = getpriority
% GETPRIORITY  Get current priority level of the MATLAB thread.
%    PRIORITY = GETPRIORITY  returns current priority level. 
%    See "help setpriority" about priority levels.

% Ben, Nov. 2008

global GLAB_CURRENT_PRIORITY

lib = getlibrary('Priority');

if strncmpi(lib,'C',1)     % Cog
    if isempty(GLAB_CURRENT_PRIORITY)
        % G-Lab not started: 
        try % Let's try to use PTB's Screen if present in path:
            n = Screen('GetMouseHelper', -3);
            if      n == 0,     p = 'NORMAL';
            elseif  n == 1,     p = 'HIGH';
            elseif  n == 2,     p = 'REALTIME';
            end
            GLAB_CURRENT_PRIORITY = p;
        catch % Let's assume it's be Windows' default. (This is only a hack.)
            p = 'NORMAL';
        end
        
    else
        p = GLAB_CURRENT_PRIORITY;
        
    end
    
elseif strncmpi(lib,'P',1) % PTB
    if ispc
        n = Screen('GetMouseHelper', -3);
        if      n == 0,     p = 'NORMAL';
        elseif  n == 1,     p = 'HIGH';
        elseif  n == 2,     p = 'REALTIME';
        end
        
    else
        p = Priority; % <todo: ???>
        
    end
end