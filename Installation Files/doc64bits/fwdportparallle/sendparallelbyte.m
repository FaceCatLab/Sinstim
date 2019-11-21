function t = sendparallelbyte(value,dur)
% SENDPARALLELBYTE  Change parallel port state.
%    t = SENDPARALLELBYTE(n)  changes states of the parallelport, n is an integer in the range 0:255, 
%    and returns timestamp in milliseconds. 
%
%    t = SENDPARALLELBYTE(bits)  'bits' is a vector of binary values.
%
%    t = SENDPARALLELBYTE(n|bits, duration)  sends given byte, waits 'duration' in milliseconds,  
%    then resets the // port to 0.  This is a blocking function: it'll return after the reset.
%
% Examples:
%       openparallelport out;               % open the port for output (open the 8 lines)
%       t = sendparallelbyte(8)             % set port value to: 0 0 0 0 1 0 0 0
%       wait(1)                             % let line 3 stay high 1 ms
%       sendparallelbyte(0)                 % reset to 0 (all lines low)
%       t = sendparallelbyte([1 0 1])       % set port value to: 0 0 0 0 0 1 0 1
%       wait(1)                             % let lines 0 and 2 stay high 1 ms
%       sendparallelbyte([0 0 0 0 0 0 0 0]) % reset to 0 (all lines low)
%

global ioObj LPT1

if value < 0
    error('SENDPARALLELBYTE: Invalid value. Value cannot be negative.')
elseif value > 255
    warning(sprintf('SENDPARALLELBYTE: Too high value: %d. Value has been clipped to 255.',value))
    value = 255;
end

%% Send byte!

    t0 = time;
    io32(ioObj,LPT1,value); %io64(ioObj,LPT1,value);
    t = time;
 %   disp(value);
%     disp(t);
%     disp('yes parallelbyte');

%% Print event in command window
if value > 0
    helper_dispevent(mfilename, sprintf('Sent parallel byte %s (%d).',dec2bin(value,8),value), t);
end

%% Reset port to 0
if nargin >= 2
    waituntil(t+dur);
    sendparallelbyte(0);  %             <===RECURSIVE-CALL===!!!
end