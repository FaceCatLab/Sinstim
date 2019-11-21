function mexall(varargin) 
% MEXALL  Compile all source files (with MEX) in a directory.
%    MEXALL [MEXALL OPTIONS] [MEX OPTIONS] DIRPATH  creates a mex-file (see MEX) for each *.c or
%    *.cpp file in directory.  On Matlab 7.1 and above, MEX-files are created in the same directory
%    than their source files.  On Matlab 6.x and 7.0, MEX-files are created in a "matlab6" sub-dir.
%    Matlab version and compilation date are logged in a file called "mexall.log".
%
%    MEXALL options (case-sensitive):
%        -r[ecursive]  
%            Include sub-directories.
%
%        -u[pdate]
%            Create a mex-file only...
%            * if not already existing, 
%            * if the source file is newer than the already compiled mex-file,
%            * if an existing mex-file was not compiled with exactly same Matlab version
%              (mexall uses the log file "mexall.log" to know that).
%
%        -p[ath]
%            Update Matlab's path to use compiled mex-files.  New path is not saved.
%
%        -s[silent]
%            Don't print info.
%            
%    MEX options:
%        See "help mex".
%
%    Example:
%        mexall -rup D:\MATLAB\mex\  
%
% Ben Jacob, Jun 2011.

%            Jun 2011,  v1.0.
%            Jul 2011,  v1.0.1. Fix case no compilator (or other mex error): display warning.


%% Input Args
% MEXALL Options:
Opt.r = false;
Opt.u = false;
Opt.p = false;
Opt.s = false;
while 1
    s = varargin{1};
    switch s
        case {'-r','-recursive'}
            Opt.r = true;
        case {'-u','-update'}
            Opt.u = true;
        case {'-p','-path'}
            Opt.p = true;
        case {'-s','-silent'}
            Opt.s = true;
        otherwise
            if all(ismember(s,'-rups'))
                for c = 2:length(s)
                    Opt.(s(c)) = true;
                end
            else
                break;  % <--!!
            end
    end
    varargin(1) = [];
end

% Directory's path name:
RootDir = varargin{end};
varargin(end) = [];
if ~exist(RootDir,'dir') 
    error(['Unexisting directory: "' RootDir '".'])
end
if Opt.r,  Dirs = getsubdirlist(RootDir);
else       Dirs = {RootDir};
end

% MEX Options:
MexOptions = varargin;


%% MATLAB 6: Create mex option file
% We'll dump standard mex option file in "Application data" to avoid Matlab 6's abstruse and 
% unusefull questions about the compiler.  This will be done only once.
if ispc
    v = version;
    if v(1) == '6';
        optfile = fullfile(userdir, 'Application Data\MathWorks\MATLAB\R13\mexopts.bat');
        dumpfile = fullfile(bentoolsroot, 'mexopts.bat');
        if ~exist(optfile,'file')
            dispinfo(mfilename,'info',['Copying standard mex option file to: "' optfile '"']);
            copy(dumpfile,optfile);
        end
    end
end


%% Read Log File
% For stability with all Matalb versions, we use a tab-separated text file for our log.
% Here is an example of log file:
%
%           '#This file has been automatically written by MEXALL (v1.0). 
%           '#Don't modify it manually. Delete it if you want to reset MEXALL.
%           'Matlab Version' <TAB> 'Compilation Date' <TAB> 'File Extension' <CR LF>
%           '7.5.0.342 (R2007b)' <TAB> '15-Jun-2011 16:26:18' <TAB> 'mexw32' <CR LF>
%           '6.5.0.180913a (R13)' <TAB> '17-Jun-2011 13:29:21' <TAB> 'dll' <CR LF>
% 
% (Order of versions row is irrelevant.)
%
LogFile = fullfile(RootDir, [mfilename '.log']);
LastCompilDate = [];
if exist(LogFile,'file')
    [n,LogTable] = stdtextread(LogFile,2);
    LogTable(1,:) = []; % suppress titles
    for i = 1 : size(LogTable,1)
        if strcmp(LogTable{i,1},version)
            LastCompilDate = LogTable{i,2};
            LogTable(i,:) = [];
            break
        end
    end
end


%% Main Loop
isCompil = 0;
for d = 1 : length(Dirs)
    Files = dir(Dirs{d});
    for f = find(~[Files.isdir])
        cfile = fullfile(Dirs{d},Files(f).name);
        [fpath, fname, fext] = filenameparts(cfile);
        if strcmpi(fext,'c') || strcmpi(fext,'cpp')
            % Destination directory:
            if strcmp(mexext,'dll')  % Matlab 6 -> 7.0 on Windows..
                % MEX-file's extention changed in Matlab 7.1 from .dll to .mexw32 (on Windows).
                % Matlab 7.1+ of mex() renames existing *.dll files to *.dll.old. To avoid that
                % we need to put Matlab 6.x-7.0's *.dll files in a specific directory.
                destdir = fullfile(fpath,'matlab6');
                checkdir(destdir);
            else                     % Matlab 7.1 and later..
                destdir = fpath;
            end
            
            % Destination file:
            mexfile = fullfile(destdir, [fname '.' mexext]);
            
            % Must it be compiled?
            tocompile = 1;
            if Opt.u && ~isempty(LastCompilDate) && exist(mexfile,'file')
                try % <To fix Matlab bug on M6.5/Win2000:
                    % ??? Improper assignment with rectangular empty matrix.
                    % Error in ==> F:\MATLAB6p5\toolbox\matlab\timefun\datevec.m
                    % On line 70  ==>          c(2) = find(all((M == d(ones(12,1),k:k+2))'));
                    % Error in ==> f:\work\toolbox+\bentools\getfiledate.m
                    % On line 62  ==>     [year,month,day,hour,min,sec] = datevec(d.date);
                    % >
                    if datenum(getfiledate(cfile)) <= datenum(getfiledate(mexfile)) &&  ...  % there is a mex-file and it's not obsolete..
                            datenum(getfiledate(cfile)) <= datenum(LastCompilDate)           % and compilation has been done exactly the same matlab version..
                        tocompile = 0;  % ..don't recompile
                    end
                catch
                    tocompile = 0; % <hack!> <fixme>
                end
            end
            
            % Compile:
            if tocompile
                % Compile:
                v = version;
                if ~Opt.s
                    if vcmp(v(1:3),'>=','7.1')
                        str = ['Compiling MEX-file: "' cfile '" -> "' fname '.' mexext '"'];
                    else
                        str = ['Compiling MEX-file: "' cfile '" -> ".' filesep 'matlab6' filesep fname '.' mexext '"'];
                    end
                    dispinfo(mfilename, 'info', str)
                end
                od = cd;
                cd(destdir)
                try
                    mex(MexOptions{:}, cfile);
                    isCompil = 1;
                catch
                    msg = 'Error during MEX execution. Compilation failed.';
                    warning(msg)
                    dispinfo(mfilename,'ERROR',msg)
                end
                cd(od);
                
            end
            
            % Update Matlab path:
            if Opt.p
                matlab6dir = fullfile(fpath,'matlab6');
                if vcmp(v(1:3),'>=','7.1') && exist(matlab6dir,'dir')  % We are on ML 7.1+ and there is a "matlab6" dir..
                    if ~isempty(strfind(lower(path),lower(matlab6dir))) % ..if dir is in Matlab's path..
                        rmpath(matlab6dir); % ..remove it.
                    end
                end
                addpath(destdir);
            end

        end
    end
end


%% Write Log File
% Cfr supra about the log file.
if isCompil
    % Header & Titles:
    header = ['#This file has been automatically written by MEXALL (v1.0).' 13 10 ...
        '#Don''t modify it manually. Delete it if you want to reset MEXALL.' 13 10];
    titles = ['Matlab Version    ' 9 'Compilation Date   ' 9 'File Extension' 13 10];

    % Convert LogTable to string:
    if exist(LogFile,'file')
        % Remove from LogTable data about older compilation which has been overwritten:
        if ~isempty(LogTable)
            i = strmatch(mexext, LogTable{:,3});
            LogTable(i,:) = [];
        end
        % Convert LogTable to string:
        LogStr = [header titles];
        for i = 1 : size(LogTable,1)
            LogStr = [LogStr ...
                LogTable{i,1} 9 LogTable{i,2} 9 LogTable{i,3} 13 10];
        end
        LogStr = [LogStr ...
            version 9 datestr(now) 9 mexext 13 10];
    else
        LogStr = [header titles ...
            version 9 datestr(now) 9 mexext 13 10];
    end

    % Write it to file:
    writetxt(LogFile,LogStr);
end