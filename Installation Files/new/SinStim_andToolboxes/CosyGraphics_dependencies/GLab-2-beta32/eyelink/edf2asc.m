function [Err,Message] = edf2asc(varargin)
% EDF2ASC  Matlab wrapper for EyeLink's EDF2ASC.EXE program.
%    EDF2ASC(<options,> EdfFileFullName)
%    [Err,Message] = EDF2ASC(<options,> EdfFileFullName)
%
%    NB: evReadEyelink uses -sp options.
%
% Ben,  Jun 2010.
%
%    EDF2ASC.EXE's original documentation:
%
%         EDF2ASC: EyeLink EDF file -> ASCII (text) file translator
%         EDF2ASC version 3.0 MS-DOS Sep 10 2007
%         (c)1995-2007 by SR Research, last modified Sep 10 2007
% 
%         USAGE: c:/edf2asc.exe  [options] <input .edf file>
%         OPTIONS: -p <path> writes output with same name to <path> directory
%                  -p *.<ext> writes output of same name with new extension
%                  -d <filename> creates log data file
%                  -t use only tabs as delimiters
%                  -c check consistency
%                  -z disable check consistency and fix the errors
%                            -v verbose - reports warning messages.
%                            -y overwrite asc file if exists.
%         If no output file name, will match wildcards on input file name,
%         and will write output files to new path or will overwrite old files.
%         DATA OPTIONS: -sp  outputs sample raw pupil position if present
%                       -sh  outputs sample HREF angle data if present
%                       -sg  outputs sample GAZE data if present (default)
%               -l or -nr   outputs left-eye data only if binocular data file
%               -r or -nl   outputs right-eye data only if binocular data file
%               -res         outputs resolution data if present
%               -vel (-fvel) outputs sample velocity (-fvel matches EDFVIEW numbers)
%               -s or -ne   outputs sample data only
%               -e or -ns   outputs event data only
%               -miss <value>     replaces missing (x,y) in samples with <value>
%               -setres <xr> <yr> uses a fixed <xr>,<yr> resolution always
%               -defres <xr> <yr> uses a default <xr>,<yr> resolution if none in file
%               -nv         hide viewer commands
%               -nst        blocks output of start events
%               -nmsg       blocks message event output
%               -neye       outputs only non-eye events (for sample-only files)
%          Use  -neye     to get samples labeled with non-eye events only
%          Use  -neye -ns to get non-eye events only
%         -nflags to disable flags data for EyeLink II or EyeLink1000 data files.
%         -hpos  output head marker positions
%         -avg  output average data
%         -ftime output float time
%         -input output input values in samples.
%         -failsafe runs in failsafe mode and recover partial edf file
%         -ntarget to disable target data forEyeLink1000 Remote data files.

%% !!! === IMPORTANT PROGRAMMER NOTE === !!!
% EDF2ASC.EXE cannot run if EDF2ASC.EXE or the *.EDF file is inside the "My Documents" folder !!!
% As a workaround, we'll copy EDF2ASC.EXE into "X:\glab\lib\" and *.EDF files in "X:\glab\tmp\",   
% where X is the letter of the drive which contains the EDF2ASC.M file. In all known cases in IoNS,  
% this should be writable, and EDF2ASC.EXE should be executable from there.
% edf2asc.m is a part of GLab and therefore uses the GLab's std "X:\glab\*" dirs, but it should be 
% usable stand-alone, with the only condition that EDF2ASC.EXE has to be in the same directory. 
% For this reason:
%   - Always check that directories and files we want to use do exist. <!>
%   - Avoid using other BenTools or GLab functions (e.g.: glabtmp). <!!!>

%% Input Args
EdfFileFullName = varargin{end};
if ~any(EdfFileFullName == filesep), EdfFileFullName = [pwd filesep EdfFileFullName]; end
options = varargin(1:end-1);
disp(' ')
dispinfo('edf2asc.m','info',['Converting "' EdfFileFullName '" to an ASCII file...']);
dispinfo('edf2asc.m','info','EDF2ASC.M is a wrapper for EDF2ASC.EXE.');

%% Check dirs and files do exist
% Check input file
if ~exist(EdfFileFullName,'file')
    error(['Cannot find file "' EdfFileFullName '"'])
end

% Make the "X:\glab\lib" and "X:\glab\tmp\" dirs, if not already existing: <Don't use checkdir, see above>
MFileFullName = which(mfilename);
drive = MFileFullName(1:2);
TmpDir = [drive filesep 'glab' filesep 'tmp' filesep]; % <in case of modification, change also the mkdir args, just below>
LibDir = [drive filesep 'glab' filesep 'lib' filesep];
if ~exist([drive filesep 'glab'])
    [success,msg] = mkdir(drive,'glab');
    if ~success, error(['Cannot create "' drive filesep 'glab' filesep '".' 10 msg]), end
end
if ~exist(TmpDir)
    [success,msg] = mkdir([drive filesep 'glab'],'tmp');
    if ~success, error(['Cannot create "' TmpDir '".' 10 msg]), end
end

%% Copy files to "X:\glab\lib" and "X:\glab\tmp"
% Copy EDF2ASC.EXE into "X:\glab\lib\" dir, if not already done:
sourcefullname = [MFileFullName(1:end-1) 'exe']; 
if ~exist(sourcefullname,'file')
    error('A copy of edf2asc.exe has to be in the same directory than edf2asc.m.')
end
if ~exist([LibDir 'edf2asc.exe'])
    cmd = ['xcopy "' sourcefullname '" "'  LibDir '" /vy'];
    dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
    dos(cmd);
end

% Copy *.EDF file into "X:\glab\tmp\" dir:
sep = find(EdfFileFullName == filesep);
sourcefullname = EdfFileFullName;
targetfullname = [TmpDir EdfFileFullName(sep(end)+1:end)];
cmd = ['xcopy "' sourcefullname '" "' TmpDir '" /vy'];
dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
dos(cmd);

%% Execute EDF2ASC.EXE !
% <todo: remove existing output file>
optstr = '-y '; % program freezes when call from Matlab and waiting for a "y"
for o = 1 : length(options)
    optstr = [optstr options{o} ' '];
end
targetfullname = [TmpDir EdfFileFullName(sep(end)+1:end)];
cmd = [LibDir 'EDF2ASC.EXE ' optstr ' ' targetfullname];
disp(' ')
dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
[e,msg] = dos(cmd);
% Error & message
if ~isempty(strfind(msg,'Converted successfully'))
    Err = 0; % NB: "e" seems always to be e=255. Let's make our own error variable.
    i0 = strfind(msg,'Processed [          ]0%');
    i1 = strfind(msg,'100%') + 4;
    msg(i0:i1) = [];
else
    Err = -1;
end
Message = msg;
disp(msg);

%% Move output file to original EDF file's dir:
sep = find(EdfFileFullName == filesep);
originaldir = EdfFileFullName(1:sep(end));
shortname = EdfFileFullName(sep(end)+1:end-4);
sourcefullname = [TmpDir shortname '.asc'];
cmd = ['xcopy "' sourcefullname '" "' originaldir '" /vy'];
dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
dos(cmd);

%% Delete all *.EDF and *.ASC files from "X:\glab\tmp\"
cmd = ['del ' TmpDir '*.edf /Q /F'];
dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
dos(cmd);
cmd = ['del ' TmpDir '*.asc /Q /F'];
dispinfo('edf2asc.m','info',['Executing MS-DOS command (Ctrl+C if it freezes):  '  cmd])
dos(cmd);
dispinfo('edf2asc.m','info','Done.');
disp(' ')

%% %%%%%%%%%%%%%%%%%%%%%%%%%% SUB-FUCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% dispinfo <copy of GLab's function>
function dispinfo(CallerName,InfoType,Message)
% DISPINFO  Display caller function info/warning/error in command window.
%    DISPINFO(MFILENAME,InfoType,Message)  displays caller function name (got from MFILENAME) and 
%    message in command window. MFILENAME is the standard Matlab function. InfoType can be 'INFO', 
%    'WARNING' or 'ERROR'.
%
%    This function is intended to be used by all GLab fuunctions to display their message in the
%    command window. It does nothing wonderfull curently, but it provides a centralized way to
%    modify the way all function infos are displayed, if needed.
%
% Example:
%    dispinfo('edf2asc.m','info','Hello world!')

CallerName = upper(CallerName);
if any(strfind(lower(InfoType),'info')),  InfoType = lower(InfoType);
else                                      InfoType = upper(InfoType);
end
message = [CallerName '-' InfoType ': ' Message];
disp(message)