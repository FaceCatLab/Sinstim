function p = getpriority
% GETPRIORITY  Get current priority level of the MATLAB thread.
%    P = GETPRIORITY  returns current priority level. 
%    See " help setpriority " about priority levels.
%
% Ben, 2008-2011.


if ispc
    if isptbinstalled
        n = Screen('GetMouseHelper', -3);
        switch n
            case 0,   p = 'NORMAL';
            case 1,   p = 'HIGH';
            case 2,   p = 'REALTIME';
        end
    else
        p = 'UNKNOWN'; % PTB not installed: there is no "getpriority" function in Cogent.
    end

else
    p = Priority;  % <TODO: ???>

end
