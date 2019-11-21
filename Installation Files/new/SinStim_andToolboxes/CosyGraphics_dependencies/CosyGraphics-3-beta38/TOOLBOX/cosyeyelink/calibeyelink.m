function calibeyelink(SendKey,CalibGrid) % <TODO: add SendKey>
% CALIBEYELINK  EyeLink tracker calibration.
%    CALIBEYELINK('C',CalibGrid)  launches calibration of given type. CalibGrid can  
%    be 'H3', 'HV3', 'HV5', 'HV9' or 'HV13'.
%
%    Examples: 
%       calibeyelink C HV13  % performs the best possible calibration; perfect for sane 
%                            % human subjects.
%       calibeyelink C HV5   % starts a simpler calibration; suggested for monkeys.
%
%    CALIBEYELINK V  starts validation procedure.
%
%    CALIBEYELINK D  starts drift correction (i.e.: pre-trial offset recalibration to correct 
%    subject's head drift). 
%
%    _____________________________________________________________________________________
%    CALIBRATE SCREEN KEY SHORTCUTS: (work on both Matlab PC and EyeLink PC keyboards)
%       Press ENTER or spacebar to accept a fixation
%       Press Backspace to cancel and redo the last point
%
%       Press A to switch Automatic calibration on
%       Press M to switch automatic calibration off (Manual)
%
%       Press Esc to exit the Camera Setup screen (EyeLink version 3.10)
%       Press Esc to restart calibration (EyeLink version 4 and above)
%       Press Esc twice to exit the Camera Setup screen (EyeLink version 4 and above)
%
%       Press V to start Validation
%       Press D to start Drift correction
%
%       Press ENTER, at the end, to accept the calibration and exit
%    _____________________________________________________________________________________
%


% CALIBRATE SCREEN KEY SHORTCUTS (from EyeLink User Manual, p.29):
%  
%   During Calibration
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%   ENTER or Spacebar  Begins calibration sequence or accepts calibration value
%                      given. After first point, also selects manual calibration
%                      mode.
%   ESC                Terminates calibration sequence.
%  
%   M                  Manual calibration (Auto trigger turned off.)
%   A                  Auto calibration set to the pacing selected in Set Options
%                      menu. (Auto trigger ON). EyeLink accepts current fixation
%                      if it is stable.
%   Backspace          Repeats previous calibration target.
%  
%   After Calibration
%   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%   F1                 Help screen
%   ENTER              Accept calibration values
%   V                  Validate calibration values
%   ESC                Discard calibration values
%   Backspace          Repeats last calibration target.

%________________________________________________________________
%    EyeLink's keyboard shortcuts:
%           Press 'C' to start Calibration
%           Press ENTER or spacebar to accept a fixation
%           Press Backspace to cancel and redo the last point
%           Press 'V' to start Validation
%           Press 'D' to start Drift correction
%
%           Press ENTER, at the end, to accept the calibration and exit
%
%           Press Esc to exit the Camera Setup screen (EyeLink version 3.10)
%           Press Esc to restart calibration (EyeLink version 4 and above)
%           Press Esc twice to exit the Camera Setup screen (EyeLink version 4 and above)
%
%           Press A to switch Automatic calibration on
%           Press M to switch automatic calibration off (Manual)
%_________________________________________________________________

% Deprecated:
%    CALIBEYELINK  <does not work!!!> opens EyeLink Camera Setup screen and wait for user events.
%    (User can control calibration either through EyeLink's GUI or through keyboard
%    shortcuts.)

global COSY_EYELINK COSY_DISPLAY

%% %%%%%%%%%%%% PARAMS %%%%%%%%%%%%%%
DefaultCalibType = 'HV5';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Key Shortcuts
% (from EyeLink User Manual, p.29)
KeyShortcuts = [ ...
'  CALIBRATE SCREEN KEY SHORTCUTS:' 10 ...
' ' 10 ...
'  During Calibration' 10 ...
'  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯' 10 ...
'  ENTER or Spacebar  Begins calibration sequence or accepts calibration value' 10 ...
'                     given. After first point, also selects manual calibration' 10 ...
'                     mode.' 10 ...
'  ESC                Terminates calibration sequence.' 10 ...
' ' 10 ...
'  M                  Manual calibration (Auto trigger turned off.)' 10 ...
'  A                  Auto calibration set to the pacing selected in Set Options' 10 ...
'                     menu. (Auto trigger ON). EyeLink accepts current fixation' 10 ...
'                     if it is stable.'  10 ...
'  Backspace          Repeats previous calibration target.' 10 ...
' ' 10 ...
'  After Calibration' 10 ...
'  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯' 10 ...
'  F1                 Help screen' 10 ...
'  ENTER              Accept calibration values' 10 ...
'  V                  Validate calibration values' 10 ...
'  ESC                Discard calibration values' 10 ...
'  Backspace          Repeats last calibration target.' 10 ...
];
dispinfo(mfilename,'info',KeyShortcuts)

%% Checks
if nargin < 1
    dispinfo(mfilename,'error','Not enough input arguments.')
    return % <===!!!
end
if ~isopen('display'),      error('No display window open.')
elseif ~isopen('eyelink'),  openeyelink; 
end
dispinfo(mfilename,'info','Starting EyeLink calibration procedure...')
if checkeyelink('isdummy')
    dispinfo(mfilename,'ERROR','Calibration not possible in dummy mode. Calibration aborted.');
end

%% Global Var
el = COSY_EYELINK.EL;
if isptb
    el.window = gcw; % <fix 15-04-2010>
else
    el.window = newbuffer;
end
% Bg and fg colors: Make sure bg color is up to date; select an opposite fg color
bg = mean(rgb2gray(COSY_DISPLAY.BackgroundColor));
fg = 1 - round(bg);
el.backgroundcolour = round(255 * bg);
el.foregroundcolour = round(255 * fg);

%% Input Vars
if ~nargin
    error('Not enough input arguments.')
end
SendKey = lower(SendKey);
if SendKey == 'c' &&  ~checkeyelink('isopen')
    error('No open connection with EyeLink. Use openeyelink.')
end
if SendKey == 'v' &&  ~checkeyelink('iscalibrated')
    error('EyeLink is not calibrated.')
end
if ~exist('CalibGrid','var')
    switch SendKey
        case 'c',   CalibGrid = DefaultCalibType;
        case 'v',   CalibGrid = COSY_EYELINK.CalibGrid;
        case 'd',   CalibGrid = 'drift';
    end
end
if SendKey == 'c'
    COSY_EYELINK.CalibGrid = CalibGrid;
end

%% Calibration
if ~strcmpi(CalibGrid,'drift') % Full calibration
    % Set calibration type.
    Eyelink('command', ['calibration_type = ' CalibGrid]);

    % Calibrate the eye tracker
    err = sub_EyelinkDoTrackerSetup(el,SendKey); % sub-fun, see below

else % Pre-trial offset recalibration
    EyelinkDoDriftCorrection(el);
    
end

if SendKey == 'c'
    if err ~= 0
        COSY_EYELINK.isCalibrated = 1;
    end
end

dispinfo(mfilename,'info','Done.')

wait(100);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction: sub_EyelinkDoTrackerSetup
% Modified version of EyelinkToolbox's EyelinkDoTrackerSetup.
function result = sub_EyelinkDoTrackerSetup(el,sendkey)
% USAGE: result = EyelinkDoTrackerSetup(el,sendkey)
%
%		el: EyeLink default values
%		sendkey: set to go directly into a particular mode
% 				'v', start validation
% 				'c', start calibration
% 				'd', start driftcorrection
% 				13, or el.ENTER_KEY, show 'eye' setup image

%
% 02-06-01	fwc removed use of global el, as suggest by John Palmer.
%				el is now passed as a variable, we also initialize Tracker state bit
%				and EyeLink key values in 'initeyelinkdefaults.m'
% 15-10-02	fwc	added sendkey variable that allows to go directly into a particular mode
%
%   22-06-06    fwc OSX-ed

result=-1;
if nargin < 1
	error( 'USAGE: result=EyelinkDoTrackerSetup(el [,sendkey])' );
end
	
Eyelink('Command', 'heuristic_filter = ON');
%<ben> Switch EyeLink PC to the "Calibration Setup" screen. This is mandatory
% because keyboard shortcuts are differnents when on other screens. </ben>
Eyelink( 'StartSetup' );		% start setup mode
Eyelink( 'WaitForModeReady', el.waitformodereadytime );  % time for mode change
wait(100) % <ben> ???

EyelinkClearCalDisplay(el);	% setup_cal_display()
key=1;
while key~= 0
	key=EyelinkGetKey(el);		% dump old keys
end

% go directly into a particular mode
if nargin==2
	if el.allowlocalcontrol==1
		switch lower(sendkey)
			case{ 'c', 'v', 'd', el.ENTER_KEY}
                %forcedkey=BITAND(sendkey(1,1),255);
				forcedkey=double(sendkey(1,1));
				Eyelink('SendKeyButton', forcedkey, 0, el.KB_PRESS );
		end
	end
end

%<ben>
% Wait to be sure changes are effectives. <needed?>
wait(50)
%</ben>

tstart=GetSecs;
stop=0;
while stop==0 & bitand(Eyelink( 'CurrentMode'), el.IN_SETUP_MODE)

	i=Eyelink( 'CurrentMode');
	
	if ~Eyelink( 'IsConnected' ) stop=1; break; end;

	if bitand(i, el.IN_TARGET_MODE)			% calibrate, validate, etc: show targets
		%fprintf ('%s\n', 'dotrackersetup: in targetmodedisplay' );
		EyelinkTargetModeDisplay(el);	
%<ben> Seems we where stuck in this elseif case. Replace by an else and break unconditionnally.
    else
        break 
        EyelinkClearCalDisplay(el);	% setup_cal_display()
%    <Suppressed the following code:>
%     elseif bitand(i, el.IN_IMAGE_MODE)		% display image until we're back
% % 		fprintf ('%s\n', 'EyelinkDoTrackerSetup: in ''ImageModeDisplay''' );
% 	  	if EyeLink ('ImageModeDisplay')==el.TERMINATE_KEY 
% 			result=el.TERMINATE_KEY;
% 	    	return;    % breakout key pressed
% 	  	else
% 			EyelinkClearCalDisplay(el);	% setup_cal_display()
% 		end	
%</ben>
	end

	[key, el]=EyelinkGetKey(el);		% getkey() HANDLE LOCAL KEY PRESS
    if 1 && key~=0 && key~=el.JUNK_KEY    % print pressed key codes and chars
        fprintf('%d\t%s\n', key, char(key) );
    end
    
    switch key
        case el.TERMINATE_KEY,				% breakout key code
            result=el.TERMINATE_KEY;
            return; % <=== RETURN !!!
        case { 0, el.JUNK_KEY }          % No or uninterpretable key
        case el.ESC_KEY,
            if Eyelink('IsConnected') == el.dummyconnected
                stop=1; % instead of 'goto exit'
            end
            if el.allowlocalcontrol==1
                Eyelink('SendKeyButton', key, 0, el.KB_PRESS );
            end
        otherwise, 		% Echo to tracker for remote control
            if el.allowlocalcontrol==1
                Eyelink('SendKeyButton', double(key), 0, el.KB_PRESS );
            end
    end
end % while IN_SETUP_MODE

% exit:
% <ben, 15 apr 2010>
% EyelinkClearCalDisplay(el);	% exit_cal_display()
clearbuffer;
displaybuffer;
% </ben>
result=0;
return;	
