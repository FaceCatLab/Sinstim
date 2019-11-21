function [Keys,Times] = psb_getkeydown
% PSB_GETKEYDOWN
%    [Keys,Times] = PSB_GETKEYDOWN
%
% <TODO: fix case more than 1 key pressed.>

if ~isopen('psb')
    error('PSB not initialized. See OPENPSB.')
end

%% Read serial port
bytes = double(psb_getserialbytes);
i = 1;
while rem(length(bytes),4)
    if i <= 10
        try
            bytes = [bytes double(psb_getserialbytes)];
        catch
            beep
            dispinfo(mfilename, 'ERROR', 'Error when reading input from PSB on COM port: Error in psb_getserialbytes.')
            dispinfo(mfilename, 'debuginfo', 'MATLAB issued the following error message: (Please, copy/paste it somwhere!)')
            disp(lasterr)
            bytes = [nan nan nan nan];
            break % <--!!
        end
        i = i + 1;
    else
        bytes = [nan nan nan nan];
        dispinfo(mfilename, 'ERROR', 'Error when reading input from PSB on COM port: Max recursion limit reached.')
        dispinfo(mfilename, 'debuginfo', sprintf('%d bytes received (on 4 waited).', length(bytes)))
    end
end

%% Convert
if length(bytes) > 0
    Keys = bytes(1:4:end);
    Times = bytes(2:4); % <debug>
    Keys = bytes(1); % <debug> <TODO: fix case more than one key>
    Times = (bytes(2)*256^2 + bytes(3)*256 + bytes(4)) * .128; % <debug>
else
    Keys = [];
    Times = [];
end
