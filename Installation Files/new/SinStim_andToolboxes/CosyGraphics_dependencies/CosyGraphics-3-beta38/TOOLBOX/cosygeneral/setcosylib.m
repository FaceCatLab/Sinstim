function setcosylib(varargin)
% SETCOSYLIB   Select lower-level C libraries to be used by the toolbox.
%    For graphics operations CosyGraphics version 2 can run either on top of
%    Cogent(Cog) MEX-files or on top of PsychToolBox (PTB) MEX-files.
%
%    SETCOSYLIB('Cog'|'PTB')  selects library for graphics operations and mouse 
%    control, either 'Cog' or 'PTB'.  Non graphics-related operations are not 
%    affected and keep their current settings.
%
%    SETCOSYLIB('Cog',Version)  sets library version to use. 'Version' can be
%    [1 24], [1 28] or [1 29].
%
%    SETCOSYLIB(Module1,Lib1,Module2,Lib2,...)
%    See below about modules and related libs.
%
%    SETCOSYLIB  <deprecated>
%
%    SETCOSYLIB('All',LIB)  <TODO>
%
%    SETCOSYLIB('Defaults')  resets to defaults.
%
%
% Available Libraries per Modules:
% ================================
%	 Module				Lib			Files							Notes
%	 ------             ---         -----                           -----
%	'Graphics'			CG			cg*.mex*, gprim.mex				Graphics + mouse. Alpha blending to slow!
%                       PTB         Screen.dll | Screen.mex*
%	'Sound'				Cog			CogSound.mex*,CogCapture.mex*
%	'Keyboard'			Cog	(v1.28)	CogInput.mex* (Does not work!)	Critical bug!, on MATLAB 6.5 & 7.5, on WinXP SP2
%						Cog	(v1.25)	CogInput.dll					Works fine. Cannot be used with CG 1.28.
%	'SerialPort'		Cog			CogSerial.mex*                  Matlab 6.5: Works fine. 
%                                                                   Matlab 7.5: Critical performance bug: several secs.
%                                                                               Crashes with PSB's USB serial.
%                       MATLAB      toolbox/matlab/iofun/@serial/*  Performance issue: several ms to send 1 byte. 
%	'ParallelPort'		DAQ			toolbox/daq/*
%	'Time'				CG			cogstd.mex*						No wait function: Must do buzzy wait.
%						PTB			GetSecs.mex*,WaitSecs.mex*		WaitSecs: Avoid buzzy wait.
%	'Priority'			CG			cogstd.mex*
%
%
% Libraries Info:
% ===============
%	Abr.	Name				Versions	For
%	----    ----                --------    ---
%	'CG'	Cogent Graphics		1.24, 1.29	Graphics, Sound (not yet supported), Mouse.
%	'Cog'	Cogent 2000			1.25, 1.29	Sound, Keyboard, Mouse (not supported),
%											Serial Port, Time, Priority.
%	'PTB'	PsychToolBox 3		3.0.8		Time. (Other stuffs will be supported in v2.0)
%	'DAQ'	Data Acquisition 	-			Parallel Port.
%			Toolbox
%
%
% Library Versions:
% =================
% 	Cog-1.25/CG-1.24:	Was powering G.Lab v. 0.x to 1.5.x.
%						Compatible with MATLAB 6.5 to 7.4 (R2007a).
%						Not compatible with MATLAB 7.5 (R2007b) and later.
%                       Only on known bug: 'dontclear' does not work (see displaybuffer).
%	Cog-1.28/CG-1.28:	Default libraries in G.Lab v1.6+
%						Compatible with MATLAB 6.5 and later.
%						MATLAB 7.5: Keyboard problem.
%						Needs a specific version for MATLAB 7.1.
%   Cog-1.29/CG-1.29:	Current version.
%
%
% See also STARTCOGENT, STARTPSYCH, GETCOSYLIB.
%
% Ben, Sept-Oct 2008


% Library Versions:
% =================
% 	Cog-1.25/CG-1.24:	Was powering G.Lab v. 0.x to 1.5.x.
%						Compatible with MATLAB 6.5 to 7.4 (R2007a).
%						Not compatible with MATLAB 7.5 (R2007b) and later.
%	Cog-1.28/CG-1.28:	Default libraries in G.Lab v1.6+
%						Compatible with MATLAB 6.5 and later.
%						MATLAB 7.5: Keyboard problem.
%						Needs a specific version for MATLAB 7.1.
%                       Bug in ML 7.5+: 
%   Cog-1.29/CG-1.29:	Replace 1.28 in G.Lab v2-beta17+
%   Cog-1.30/CG-1.30:	Replace 1.28 in G.Lab v2-beta51+


global COSY_GENERAL


if ~isfield(COSY_GENERAL,'LIBRARIES') ...                    % SETCOSYLIB(...), First call
		|| (nargin == 1 && strcmpi(varargin{1},'Defaults'))  % SETCOSYLIB('Defaults')
	
	% AVAILABLE LIBS
    if ispc % Windows
        COSY_GENERAL.LIBRARIES.AVAILABLE.Graphics		= {'CG','PTB'}; % Main lib., for Graphics & Mouse.
        COSY_GENERAL.LIBRARIES.AVAILABLE.Sound          = {'Cog','PTB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.Keyboard		= {'Cog','PTB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.SerialPort 	= {'Cog','MATLAB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.ParallelPort	= {'DAQ','InpOut32'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.Priority		= {'CG' };
    elseif isunix % Linux / MacOS X
        COSY_GENERAL.LIBRARIES.AVAILABLE.Graphics		= {'PTB'}; % Main lib., for Graphics & Mouse.
        COSY_GENERAL.LIBRARIES.AVAILABLE.Sound          = {'PTB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.Keyboard		= {'PTB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.SerialPort 	= {'MATLAB'};
        COSY_GENERAL.LIBRARIES.AVAILABLE.ParallelPort	= {};
        COSY_GENERAL.LIBRARIES.AVAILABLE.Priority		= {'PTB'};
    end
    
	% DEFAULT VALUES
    % < v2-beta29: setupcosy now always selects version 1.29 when Cogent is the main lib,
    %  because of 'dontclear' bug in 1.25 (see displaybuffer).
    %  Nothing changes when no CogentGraphics window is open (i.e.: when PTB is the main lib,
    %  or when startcosy has not been called): Still using Cog-1.25 on ML-6.5, because v1.25
    %  was more modular: most Cogent2000 v1.25 functions run independantly of a CogentGraphics 
    %  window.
    % >
	if ispc % Windows
		COSY_GENERAL.LIBRARIES.CURRENT.Graphics		= 'CG'; % Main lib., for Graphics & Mouse.
		COSY_GENERAL.LIBRARIES.CURRENT.Sound		= 'Cog';
		COSY_GENERAL.LIBRARIES.CURRENT.Keyboard		= 'Cog';
		COSY_GENERAL.LIBRARIES.CURRENT.SerialPort 	= 'Cog';
		COSY_GENERAL.LIBRARIES.CURRENT.ParallelPort	= 'DAQ';
		COSY_GENERAL.LIBRARIES.CURRENT.Priority		= 'CG';
		v = version;
		if v(1) >= '7' && v(3) >= 4	% MATLAB 7.4+  <TODO: check that for M7.4. Not very sure this changes at 7.4. (but PTB's mex changes from 7.4)>
			% Only 1.28+ is compatible.
			COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 30]; % <v2-beta17: 1.28 -> 1.29 (bug in 1.28: windows open on background)> <v2-beta51: -> 1.30>
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 30];
            COSY_GENERAL.LIBRARIES.CURRENT.Keyboard	= 'Cog'; % CogInput 1.28 crashes if no Cogent window <fixed now>
%             COSY_GENERAL.LIBRARIES.CURRENT.SerialPort = 'MATLAB'; % sendserialbytes critically slow on Matlab 7.5  <suppr. 3-beta35: pb no more observed (??)>
		else % MATLAB 6.5 to 7.3 
			% Use the old libs by default.
			COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 24];
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 25];
		end
		COSY_GENERAL.LIBRARIES.VERSIONS.PTB = [3 0 8];
        
	elseif isunix % Linux / MacOS X
        COSY_GENERAL.LIBRARIES.CURRENT.Graphics		= 'PTB'; % Main lib., for Graphics & Mouse.
		COSY_GENERAL.LIBRARIES.CURRENT.Sound		= 'PTB';
		COSY_GENERAL.LIBRARIES.CURRENT.Keyboard		= 'PTB';
		COSY_GENERAL.LIBRARIES.CURRENT.SerialPort 	= 'MATLAB';
		COSY_GENERAL.LIBRARIES.CURRENT.ParallelPort	= '';
		COSY_GENERAL.LIBRARIES.CURRENT.Priority		= 'PTB';
        COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [nan nan];
        COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [nan nan];
        
    end
    
    v = vstr2vnum(version);
    COSY_GENERAL.LIBRARIES.VERSIONS.MATLAB = v(1:2);
    
end

% SET VALUES
if nargin == 1 && ~strcmpi(varargin{1},'Defaults') % SETCOSYLIB(LIB)
	lib = upper(varargin{1});
	if 		strncmpi('C',lib,1)
		COSY_GENERAL.LIBRARIES.CURRENT.Graphics = 'CG';
	elseif 	strncmpi('P',lib,1)
		COSY_GENERAL.LIBRARIES.CURRENT.Graphics = 'PTB';
	else
		error('Bad value for ''lib'' argument. Valid values are ''CG'' and ''PTB''.')
	end
	
elseif nargin == 2 && isnumeric(varargin{2}) % SETCOSYLIB(LIB,Version)
	switch varargin{2}(2)
		case {24,25}
			COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 24];
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 25];
		case 28
			COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 28];
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 28];
% 			COSY_GENERAL.LIBRARIES.CURRENT.Keyboard = 'PTB'; % CogInput broken in 1.28 <???> <supppr. in v2-beta17>
        case 29
            COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 29];
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 29];
% 			COSY_GENERAL.LIBRARIES.CURRENT.Keyboard = 'PTB'; % <???> <TODO: check this !?!>
        case 30
            COSY_GENERAL.LIBRARIES.VERSIONS.CG  = [1 30];
			COSY_GENERAL.LIBRARIES.VERSIONS.Cog = [1 30];
	end
	
elseif nargin >= 2 % SETCOSYLIB(Module1,Lib1,Module2,Lib2,...)
	for m = 1 : 2 : nargin/2
		mod = varargin{m};
		lib = varargin{m+1};
		if ~isfield(COSY_GENERAL.LIBRARIES.CURRENT,mod) % Check module validity
			error('Invalid module name. (Check case.)')
        elseif ~any(strcmpi(COSY_GENERAL.LIBRARIES.AVAILABLE.(mod),lib)) % <v2-beta17>
            error(['Invalid library name. Library "' lib '"is not availaible for module "' mod '".'])
        else
			COSY_GENERAL.LIBRARIES.CURRENT.(mod) = lib;
		end
    end
    
end

% STORE FLAGS TO OPTIMIZE ISCOG & ISPTB
switch COSY_GENERAL.LIBRARIES.CURRENT.Graphics
    case 'CG'
        COSY_GENERAL.LIBRARIES.iscog = true;
        COSY_GENERAL.LIBRARIES.isptb = false;
    case 'PTB'
        COSY_GENERAL.LIBRARIES.iscog = false;
        COSY_GENERAL.LIBRARIES.isptb = true;
end