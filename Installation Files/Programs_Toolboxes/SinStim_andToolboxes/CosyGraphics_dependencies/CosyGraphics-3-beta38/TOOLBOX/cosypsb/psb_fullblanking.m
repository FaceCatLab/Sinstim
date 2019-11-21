function psb_fullblanking(color,state)
% PSB_FULLBLANKING  
%    PSB_FULLBLANKING BLUE ON
%    PSB_FULLBLANKING BLUE OFF
%    PSB_FULLBLANKING GREEN ON
%    PSB_FULLBLANKING GREEN OFF

global COSY_PSB

%% PSB?
if ~isopen('psb')
    warning('No PSB open.')
    return % !!!
end

%% Command
cmd = '!#B??xxxx$';

switch lower(color)
    case 'blue',    cmd(4) = 'B';
    case 'green',   cmd(4) = 'G';
    otherwise   error('Invalid color. Color argument can be ''blue'' or ''green''.')
end

switch lower(state)
    case 'on',  cmd(5) = '1';
    case 'off', cmd(5) = '0';
    otherwise   error('Invalid ''state'' argument.')
end

%% Send command
psb_sendserialcommand(cmd);