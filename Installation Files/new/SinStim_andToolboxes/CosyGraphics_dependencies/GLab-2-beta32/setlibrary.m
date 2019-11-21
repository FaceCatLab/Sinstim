function setlibrary(varargin)
% SETLIBRARY   Select lower-level C libraries to be used by the toolbox.
%    For graphics operations G-Lab version 2 can run either on top of
%    Cogent(Cog) MEX-files or on top of PsychToolBox (PTB) MEX-files.
%
%    SETLIBRARY('Cog'|'PTB')  selects library for graphics operations and mouse 
%    control, either 'Cog' or 'PTB'.  Non graphics-related operations are not 
%    affected and keep their current settings.
%
%    SETLIBRARY('Cog',Version)  sets library version to use. 'Version' can be
%    [1 24], [1 28] or [1 29].
%
%    SETLIBRARY(Module1,Lib1,Module2,Lib2,...)
%    See below about modules and related libs.
%
%    SETLIBRARY  <deprecated>
%
%    SETLIBRARY('All',LIB)  <TODO>
%
%    SETLIBRARY('Defaults')  resets to defaults.
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
%   Cog-1.28/CG-1.28:	
%
%
% See also STARTCOGENT, STARTPSYCH, GETLIBRARY.
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
%   Cog-1.29/CG-1.29:	Replaces 1.28 in G.Lab v2-beta17+


global GLAB_LIBRARIES


if isempty(GLAB_LIBRARIES) ...                            % SETLIBRARY(...), First call
		|| (nargin == 1 && strcmpi(varargin{1},'Defaults')) % SETLIBRARY('Defaults')
	
	% AVAILABLE LIBS
    if ispc % Windows
        GLAB_LIBRARIES.AVAILABLE.Graphics		= {'CG','PTB'}; % Main lib., for Graphics & Mouse.
        GLAB_LIBRARIES.AVAILABLE.Sound          = {'Cog'};
        GLAB_LIBRARIES.AVAILABLE.Keyboard		= {'Cog','PTB'};
        GLAB_LIBRARIES.AVAILABLE.SerialPort 	= {'Cog','MATLAB'};
        GLAB_LIBRARIES.AVAILABLE.ParallelPort	= {'DAQ'};
        GLAB_LIBRARIES.AVAILABLE.Priority		= {'CG' };
    elseif isunix % Linux / MacOS X
        GLAB_LIBRARIES.AVAILABLE.Graphics		= {'PTB'}; % Main lib., for Graphics & Mouse.
        GLAB_LIBRARIES.AVAILABLE.Sound          = {'PTB'};
        GLAB_LIBRARIES.AVAILABLE.Keyboard		= {'PTB'};
        GLAB_LIBRARIES.AVAILABLE.SerialPort 	= {'MATLAB'};
        GLAB_LIBRARIES.AVAILABLE.ParallelPort	= {};
        GLAB_LIBRARIES.AVAILABLE.Priority		= {'PTB'};
    end
    
	% DEFAULT VALUES
    % < v2-beta29: setupglab now always selects version 1.29 when Cogent is the main lib,
    %  because of 'dontclear' bug in 1.25 (see displaybuffer).
    %  Nothing changes when no CogentGraphics window is open (i.e.: when PTB is the main lib,
    %  or when startglab has not been called): Still using Cog-1.25 on ML-6.5, because v1.25
    %  was more modular: most Cogent2000 v1.25 functions run independantly of a CogentGraphics 
    %  window.
    % >
	if ispc % Windows
		GLAB_LIBRARIES.CURRENT.Graphics		= 'CG'; % Main lib., for Graphics & Mouse.
		GLAB_LIBRARIES.CURRENT.Sound		= 'Cog';
		GLAB_LIBRARIES.CURRENT.Keyboard		= 'Cog';
		GLAB_LIBRARIES.CURRENT.SerialPort 	= 'Cog';
		GLAB_LIBRARIES.CURRENT.ParallelPort	= 'DAQ';
		GLAB_LIBRARIES.CURRENT.Priority		= 'CG';
		v = version;
		if v(1) >= '7' && v(3) >= 5	% MATLAB 7.5+
			% Only 1.28+ is compatible.
			GLAB_LIBRARIES.VERSIONS.CG  = [1 29]; % <v2-beta17: 1.28 -> 1.29 (bug in 1.28: windows open on background)>
			GLAB_LIBRARIES.VERSIONS.Cog = [1 29];
            GLAB_LIBRARIES.CURRENT.Keyboard	= 'Cog'; % CogInput 1.28 crashes if no Cogent window <fixed now>
            GLAB_LIBRARIES.CURRENT.SerialPort = 'MATLAB'; % sendserialbytes critically slow on Matlab 7.5
		else % MATLAB 6.5 to 7.4  <TODO: check that for M7.4 on Caroline's PC>
			% Use the old libs by default.
			GLAB_LIBRARIES.VERSIONS.CG  = [1 24];
			GLAB_LIBRARIES.VERSIONS.Cog = [1 25];
            GLAB_LIBRARIES.CURRENT.Keyboard	= 'Cog';
            GLAB_LIBRARIES.CURRENT.SerialPort = 'Cog';
		end
		GLAB_LIBRARIES.VERSIONS.PTB = [3 0 8];
        
	elseif isunix % Linux / MacOS X
        GLAB_LIBRARIES.CURRENT.Graphics		= 'PTB'; % Main lib., for Graphics & Mouse.
		GLAB_LIBRARIES.CURRENT.Sound		= 'PTB';
		GLAB_LIBRARIES.CURRENT.Keyboard		= 'PTB';
		GLAB_LIBRARIES.CURRENT.SerialPort 	= 'MATLAB';
		GLAB_LIBRARIES.CURRENT.ParallelPort	= '';
		GLAB_LIBRARIES.CURRENT.Priority		= 'PTB';
        GLAB_LIBRARIES.VERSIONS.CG  = [nan nan];
        GLAB_LIBRARIES.VERSIONS.Cog = [nan nan];
        
    end
    
    v = vstr2vnum(version);
    GLAB_LIBRARIES.VERSIONS.MATLAB = v(1:2);
    
end

% SET VALUES
if nargin == 1 && ~strcmpi(varargin{1},'Defaults') % SETLIBRARY(LIB)
	lib = upper(varargin{1});
	if 		strncmpi('C',lib,1)
		GLAB_LIBRARIES.CURRENT.Graphics = 'CG';
	elseif 	strncmpi('P',lib,1)
		GLAB_LIBRARIES.CURRENT.Graphics = 'PTB';
	else
		error('Bad value for ''lib'' argument. Valid values are ''CG'' and ''PTB''.')
	end
	
elseif nargin == 2 && isnumeric(varargin{2}) % SETLIBRARY(LIB,Version)
	switch varargin{2}(2)
		case {24,25}
			GLAB_LIBRARIES.VERSIONS.CG  = [1 24];
			GLAB_LIBRARIES.VERSIONS.Cog = [1 25];
		case 28
			GLAB_LIBRARIES.VERSIONS.CG  = [1 28];
			GLAB_LIBRARIES.VERSIONS.Cog = [1 28];
% 			GLAB_LIBRARIES.CURRENT.Keyboard = 'PTB'; % CogInput broken in 1.28 <???> <supppr. in v2-beta17>
        case 29
            GLAB_LIBRARIES.VERSIONS.CG  = [1 29];
			GLAB_LIBRARIES.VERSIONS.Cog = [1 29];
% 			GLAB_LIBRARIES.CURRENT.Keyboard = 'PTB'; % <???> <TODO: check this !?!>
	end
	
elseif nargin >= 2 % SETLIBRARY(Module1,Lib1,Module2,Lib2,...)
	for m = 1 : 2 : nargin/2
		mod = varargin{m};
		lib = varargin{m+1};
		if ~isfield(GLAB_LIBRARIES.CURRENT,mod) % Check module validity
			error('Invalid module name. (Check case.)')
        elseif ~any(strcmpi(GLAB_LIBRARIES.AVAILABLE.(mod),lib)) % <v2-beta17>
            error(['Invalid library name. Library "' lib '"is not availaible for module "' mod '".'])
        else
			GLAB_LIBRARIES.CURRENT.(mod) = lib;
		end
    end
    
end

% STORE FLAGS TO OPTIMIZE ISCOG & ISPTB
switch GLAB_LIBRARIES.CURRENT.Graphics
    case 'CG'
        GLAB_LIBRARIES.iscog = true;
        GLAB_LIBRARIES.isptb = false;
    case 'PTB'
        GLAB_LIBRARIES.iscog = false;
        GLAB_LIBRARIES.isptb = true;
end