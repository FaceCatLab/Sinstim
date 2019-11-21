function [x,y,isDown] = getjoystick
% GETJOYSTICK  Get current joystick pointer position and button states.
%    This function can only be used when a trial is started (between STARTTRIAL and STOPTRIAL).
%
%    xy = GETJOYSTICK  returns current joystick position. If joystick has been calibrated,
%    units are normalised (from -1 to +1), otherwise units are Volts.
%
%    [x,y] = GETJOYSTICK  does the same.
%
%    [x,y,isDown] = GETJOYSTICK  returns also the state of the buttons. 'isDown' is 
%    a 3-elements vector of logical values containing a 1 if left/middle/right button,
%    repectively, is down and a 0 if it's not. 
%
% See also; OPENANALOGJOYSTICK, STARTTRIAL, STOPTRIAL.
%
% Ben.J., Oct. 2012.

global COSY_DAQ
global AI DIO

%% Checks
if ~isopen('analoginput')
    if isopen('display'); stopcosy; end
    error('Analog joystick not initialised. See OPENANALOGJOYSTICK.')
elseif strcmp(AI.Running,'Off')
    if isopen('display'); stopcosy; end
    error(['Analog input session not started.' 10 ...
        'You have two possiblities:' 10 ...
        '- If you use STARTTRIAL/STOPTRIAL, the AI acquisition is automatically triggered at trial onset (onset of first frame).' 10 ...
        '- If you don´t want to use STARTTRIAL, you have to start and trigger the object manually with START(AI); TRIGGER(AI);']')
elseif strcmp(AI.Logging,'Off')
    if isopen('display'); stopcosy; end
    if isopen('trial')
        error(['Analog input session is started but has not been triggered.' 10 ...
            'The AI acquisition is automatically triggered at trial onset (onset of first frame) by DISPAYBUFFER.' 10 ...
            'That means that you have to call displaybuffer to trigger the acquisition, even if you don´t want to display something.']')
    else
        error(['Analog input session is started but has not been triggered.' 10 ...
            'After having started the AI object with start(AI), you need to trigger it with trigger(AI).']')
    end
end

%% Get values
bc = AI.BufferingConfig;
nSamples = min([bc(1) AI.SamplesAvailable]);
if nSamples
    xy = mean(peekdata(AI,nSamples));
else
    xy = [NaN NaN];
end

if nargout >= 3 
    if isfield(COSY_DAQ,'isDIO') && COSY_DAQ.isDIO
        isDown = getvalue(DIO);
        if COSY_DAQ.Joystick.ButtonsInverted
            isDown = ~isDown;
        end
    else
        isDown = [];
    end
end

%% Output args
if nargout <= 1
    x = xy;
else
    x = xy(1);
    y = xy(2);
end